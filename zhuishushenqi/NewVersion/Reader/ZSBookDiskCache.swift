//
//  ZSReaderDiskCache.swift
//  zhuishushenqi
//
//  Created by yung on 2020/1/5.
//  Copyright © 2020 QS. All rights reserved.
//

import UIKit

class ZSBookDiskCache {
    static let share = ZSBookDiskCache()
    private init() {
        
    }
    
    @discardableResult
    func cacheContent(content:ZSBookChapter, for book:String) ->Bool {
        let cachePath = ZSCacheHelper.bookshelfDownloadPath.appending("/\(book)")
        let success = ZSCacheHelper.shared.storage(obj: content, for: content.chapterUrl, cachePath: cachePath)
        return success
    }
    
    func content(for key:String, book:String) ->ZSBookChapter? {
        let cachePath = ZSCacheHelper.bookshelfDownloadPath.appending("/\(book)")
        if let obj = ZSCacheHelper.shared.cachedObj(for: key, cachePath: cachePath) as? ZSBookChapter {
            return obj
        }
        return nil
    }
    
    
    /// 缓存是否存在
    /// - Parameters:
    ///   - key: chapterUrl
    ///   - book: bookName
    func isContentExist(_ key:String, book:String) ->Bool {
        let cachePath = ZSCacheHelper.bookshelfDownloadPath.appending("/\(book)")
        if let _ = ZSCacheHelper.shared.cachedObj(for: key, cachePath: cachePath) {
            return true
        }
        return false
    }
    
    func remove(_ key:String, book:String) {
        let cachePath = ZSCacheHelper.bookshelfDownloadPath.appending("/\(book)")
        ZSCacheHelper.shared.clear(for: key, cachePath: cachePath)
    }
    
    func remove(_ book:String) {
        let cachePath = ZSCacheHelper.bookshelfDownloadPath.appending("/\(book)")
        let fullPath = NSHomeDirectory().appending("/Documents").appending(cachePath)
        do {
            try FileManager.default.removeItem(atPath: fullPath)
        } catch let error {
            print(error)
        }
    }
}
