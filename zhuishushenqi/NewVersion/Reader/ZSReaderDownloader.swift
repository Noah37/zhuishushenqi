//
//  ZSBookDownloader.swift
//  zhuishushenqi
//
//  Created by yung on 2020/1/5.
//  Copyright © 2020 QS. All rights reserved.
//

import UIKit
import Alamofire
import YungNetworkTool

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
    
    func requestData(url:String, handler:@escaping ZSBaseCallback<Data>) {
        let task = DataTask(url: url)
        task.resultHandler = { (data, error) in
            handler(data)
        }
        task.resume()
    }
    
    func requestString(url:String,
                       encoding:String.Encoding,
                       contentReg:String,
                       contentReplaceReg:String,
                       handler:@escaping ZSBaseCallback<String>) {
        requestData(url: url) { [weak self] (data) in
            guard let strongSelf = self else { return }
            guard let responseData = data else { return }
            let originContent = strongSelf.getContent(htmlData: responseData, reg: contentReg, encoding: encoding)
            let targetContent = strongSelf.contentTrim(content: originContent, reg: contentReplaceReg)
            handler(targetContent)
        }
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
                let encoding = String.Encoding.zs_encoding(str: book.searchEncoding)
                self.requestString(url: chapter.chapterUrl, encoding: encoding, contentReg: book.content, contentReplaceReg: book.contentReplace, handler: { [weak self ](resultString) in
                    guard let strongSelf = self else { return }
                    guard let string = resultString else { return }
                    chapter.chapterContent = string
                    ZSBookCache.share.cacheContent(content: chapter, for: book.bookName)
                    DispatchQueue.main.async {
                        handler(index)
                    }
                    strongSelf.semaphore.signal()
                })
            }
        }
    }
    
    func download(chapter:ZSBookChapter, book:ZSAikanParserModel, reg:String,_ handler:@escaping ZSReaderBaseCallback<ZSBookChapter>) {
        let key = chapter.chapterUrl
        let encoding = String.Encoding.zs_encoding(str: book.searchEncoding)
        requestString(url: key, encoding: encoding, contentReg: book.content, contentReplaceReg: book.contentReplace) { [weak chapter](resultString) in
            guard let strongChapter = chapter else { return }
            if let string = resultString {
                strongChapter.chapterContent = string
                ZSBookCache.share.cacheContent(content: strongChapter, for: book.bookName)
                handler(strongChapter)
            } else {
                handler(strongChapter)
            }
        }
    }
    
    func getContent(htmlData:Data, reg:String, encoding:String.Encoding) ->String {
        let htmlString = String(data: htmlData, encoding: encoding) ?? ""
        guard let document = OCGumboDocument(htmlString: htmlString) else { return "" }
        let parse = AikanHtmlParser()
        let contentString = parse.string(withGumboNode: document, withAikanString: reg, withText: false)
        return contentString
    }
    
    func contentTrim(content:String, reg:String) -> String {
        let contentReplaceString = contentReplace(string: content, reg: reg)
        let brContent = contentReplaceString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let noBrContent = defaultContentReplace(string: brContent)
        return noBrContent
    }
    
    func contentReplace(string:String, reg:String) ->String {
        var resultString = string
        guard let data = reg.data(using: .utf8) else { return resultString }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.fragmentsAllowed) as? [[String:Any]] else {
            return resultString
        }
        
        for dict in json {
            let first = dict["first"] as? String ?? ""
            let noRegular:Bool = dict[bool:"noRegular"]
            if !noRegular {
                resultString = regularString(string: resultString, first: first)
            } else {
                resultString = resultString.replacingOccurrences(of: first, with: "")
            }
        }
        
        return resultString
    }
    
    private func regularString(string:String, first:String) ->String {
        var resultString = string
        let regStr = try? NSRegularExpression(pattern: first, options: NSRegularExpression.Options.caseInsensitive)
        if let results = regStr?.matches(in: resultString, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, resultString.oc_length)) {
            var removeLength = 0
            for result in results {
                var range = result.range
                range.location = range.location - removeLength
                let subString = resultString.ocString.substring(with: range)
                resultString = resultString.ocString.replacingOccurrences(of: subString, with: "")
                removeLength = removeLength + subString.oc_length
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
