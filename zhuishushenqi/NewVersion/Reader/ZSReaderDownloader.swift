//
//  ZSBookDownloader.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2020/1/5.
//  Copyright © 2020 QS. All rights reserved.
//

import UIKit
import Alamofire

// 下载完成后放入内存缓存中
class ZSReaderDownloader {
    
    private var semaphore = DispatchSemaphore(value: 1)
    private var group = DispatchGroup()
    private var queue = DispatchQueue(label: "com.cnydev.zssq", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit)
    
    static let share = ZSReaderDownloader()
    
    let defaultReplaces:[String:String] = ["<br/>":"\n",
                                                  "<p>":"",
                                                  "</p>":"",
                                                  "&ldquo;":"",
                                                  "&rdquo;":"",
                                                  "&hellip;":"",
                                                  "</div>":""]
    
    private var cancel = false
    
    private init() {
        
    }
    
    func cancelDownload() {
        cancel = true
    }
    
    func download(book:ZSAikanParserModel, start:Int, handler:@escaping ZSBaseCallback<Int>) {
        let chaptersInfo = book.chaptersModel
        let totalChapterCount = chaptersInfo.count
        if start > totalChapterCount {
            return
        }
        queue.async(group: group) {
            for index in start..<totalChapterCount {
                if self.cancel {
                    break
                }
                let chapter = chaptersInfo[index]
                let key = chapter.chapterUrl
                if ZSBookCache.share.isContentExist(key, book: book.bookName) {
                    continue
                }
                let timeout:Double? = 10.00
                let timeouts = timeout.flatMap { DispatchTime.now() + $0 }
                    ?? DispatchTime.distantFuture
                _ = self.semaphore.wait(timeout: timeouts)
                self.download(chapter: chapter,book: book, reg: book.content) { (chapter) in
                    DispatchQueue.main.async {
                        handler(index)
                    }
                    self.semaphore.signal()
                }
            }
        }
    }
    
    func download(chapter:ZSBookChapter, book:ZSAikanParserModel, reg:String,_ handler:@escaping ZSReaderBaseCallback<ZSBookChapter>) {
        let key = chapter.chapterUrl
        download(for: key,book:book, reg: reg) { [unowned self] (contentString) in
            if let content = contentString, content.length > 0 {
                let contentReplaceString = self.contentReplace(string: content, reg: book.contentReplace)
                let brContent = contentReplaceString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                let noBrContent = self.defaultContentReplace(string: brContent)
                chapter.chapterContent = noBrContent
                ZSBookCache.share.cacheContent(content: chapter, for: book.bookName)
                handler(chapter)
            } else {
                handler(chapter)
            }
        }
    }
    private func download(for key:String, book:ZSAikanParserModel, reg:String,_ handler:@escaping ZSBaseCallback<String>) {
        let link = key
        var headers = SessionManager.defaultHTTPHeaders
        headers["User-Agent"] = YouShaQiUserAgent
        let manager = SessionManager.default
        manager.delegate.sessionDidReceiveChallenge = {
            session,challenge in
            return  (URLSession.AuthChallengeDisposition.useCredential,URLCredential(trust:challenge.protectionSpace.serverTrust!))
        }
        Alamofire.request(link, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseData { (data) in

            if let htmlData = data.data {
                let htmlString = String(data: htmlData, encoding: String.Encoding.zs_encoding(str: book.searchEncoding)) ?? ""
                guard let document = OCGumboDocument(htmlString: htmlString) else { return }
                let parse = AikanHtmlParser()
//                let contentString = ZSAikanHtmlParser.string(node: document, aikanString: reg, text: true)
                let contentString = parse.string(withGumboNode: document, withAikanString: reg, withText: false)
                handler(contentString)
            } else {
                handler("")
            }
        }
    }
    
    private func contentReplace(string:String, reg:String) ->String {
        var resultString = string
        guard let data = reg.data(using: .utf8) else { return resultString }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [[String:Any]] else {
            return resultString
        }
        
        for dict in json {
            let first = dict["first"] as? String ?? ""
            if let noRegular = dict["noRegular"] as? Bool {
                if !noRegular {
                    let regStr = try? NSRegularExpression(pattern: first, options: NSRegularExpression.Options.caseInsensitive)
                    if let results = regStr?.matches(in: string, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, string.length)) {
                        for result in results {
                            let range = result.range
                            let subString = resultString.substingInRange(range.location..<(range.location + range.length)) ?? ""
                            resultString = resultString.replacingOccurrences(of: subString, with: "")
                        }
                    }
                } else {
                    resultString = resultString.replacingOccurrences(of: first, with: "")
                }
            }
        }
        
        return resultString
    }
    
    private func defaultContentReplace(string:String)->String {
        var replaceString = string
        for (key,value) in defaultReplaces {
            replaceString = replaceString.replacingOccurrences(of: key, with: value)
        }
        return replaceString
    }

}
