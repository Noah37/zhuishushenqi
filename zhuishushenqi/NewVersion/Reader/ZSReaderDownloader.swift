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
    
    private init() {
        
    }
    
    func download(book:AikanParserModel, start:Int, handler:@escaping ZSBaseCallback<Bool>) {
        guard let chaptersInfo = book.chaptersModel as? [ZSBookChapter] else { return }
        let totalChapterCount = chaptersInfo.count
        if start > totalChapterCount {
            return
        }
        queue.async(group: group) {
            for index in start..<totalChapterCount {
                let chapter = chaptersInfo[index]
                let key = chapter.chapterUrl
                if ZSBookCache.share.isContentExist(key, book: book.bookName) {
                    continue
                }
                let timeout:Double? = 10.00
                let timeouts = timeout.flatMap { DispatchTime.now() + $0 }
                    ?? DispatchTime.distantFuture
                _ = self.semaphore.wait(timeout: timeouts)
                self.download(chapter: chapter,book: book.bookName, reg: book.content) { (chapter) in
                    self.semaphore.signal()
                }
            }
            DispatchQueue.main.async {
                handler(true)
            }
        }
    }
    
    func download(chapter:ZSBookChapter, book:String, reg:String,_ handler:@escaping ZSBaseCallback<ZSBookChapter>) {
        let key = chapter.chapterUrl
        download(for: key,book:book, reg: reg) { (contentString) in
            if let content = contentString, content.length > 0 {
                chapter.chapterContent = content
                ZSBookCache.share.cacheContent(content: chapter, for: book)
                handler(chapter)
            } else {
                handler(chapter)
            }
        }
    }
    private func download(for key:String, book:String, reg:String,_ handler:@escaping ZSBaseCallback<String>) {
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
                let htmlString = String(data: htmlData, encoding: .utf8) ?? ""
                guard let document = OCGumboDocument(htmlString: htmlString) else { return }
                let parse = AikanHtmlParser()
                let contentString = parse.string(withGumboNode: document, withAikanString: reg, withText: true)
                handler(contentString)
            } else {
                handler("")
            }
        }
    }

}
