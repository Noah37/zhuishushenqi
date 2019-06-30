//
//  ZSBookDownloader.swift
//  zhuishushenqi
//
//  Created by caony on 2019/1/21.
//  Copyright © 2019年 QS. All rights reserved.
//

import UIKit

class ZSBookDownloader {
    
    private var semaphore = DispatchSemaphore(value: 5)
    private var group = DispatchGroup()
    private var queue = DispatchQueue(label: "com.cnydev.zssq")
    
    /// key:chapterId or link, value:chapterContent
    private var chapterInfo:[String:String] = [:]
    
    static let shared = ZSBookDownloader()
    private init() {
        
    }
    
    @discardableResult
    func cacheContent(content:ZSChapterBody, for key:String) ->Bool {
        let cachePath = ZSCacheHelper.bookshelfBooksPath
        let success = ZSCacheHelper.shared.storage(obj: content, for: key, cachePath: cachePath)
        return success
    }
    
    func content(for key:String) ->ZSChapterBody? {
        let cachePath = ZSCacheHelper.bookshelfBooksPath
        if let obj = ZSCacheHelper.shared.cachedObj(for: key, cachePath: cachePath) as? ZSChapterBody {
            return obj
        }
        return nil
    }
    
    func isContentExist(_ key:String) ->Bool {
        let cachePath = ZSCacheHelper.bookshelfBooksPath
        if let _ = ZSCacheHelper.shared.cachedObj(for: key, cachePath: cachePath) {
            return true
        }
        return false
    }
    
    func download(book:BookDetail, start:Int, handler:@escaping ZSBaseCallback<Bool>) {
        guard let chaptersInfo = book.chaptersInfo else { return }
        let totalChapterCount = chaptersInfo.count
        if start > totalChapterCount {
            return
        }
        queue.async(group: group) {
            for index in start..<totalChapterCount {
                let key = chaptersInfo[index].link
                if self.isContentExist(key) {
                    continue
                }
                let timeout:Double? = 30.00
                let timeouts = timeout.flatMap { DispatchTime.now() + $0 }
                    ?? DispatchTime.distantFuture
                _ = self.semaphore.wait(timeout: timeouts)
                self.download(for: key, { (body) in
                    if let bodyInfo = body {
                        self.semaphore.signal()
                        self.cacheContent(content: bodyInfo, for: key)
                    }
                })
            }
            DispatchQueue.main.async {
                handler(true)
            }
        }
    }
    
    private func download(for key:String,_ handler:@escaping ZSBaseCallback<ZSChapterBody>) {
        let link = (key as NSString).urlEncode() ?? key
        let api = QSAPI.chapter(key: link, type: BaseType.chapter)
        zs_get(api.path, parameters: api.parameters) { (json) in
            if let body = ZSChapterBody.deserialize(from: json?["chapter"] as? [String:Any]) {
                handler(body)
            }
        }
    }
}
