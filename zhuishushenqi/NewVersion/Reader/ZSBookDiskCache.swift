//
//  ZSReaderDiskCache.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2020/1/5.
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
    
    func isContentExist(_ key:String, book:String) ->Bool {
        let cachePath = ZSCacheHelper.bookshelfDownloadPath.appending("/\(book)")
        if let _ = ZSCacheHelper.shared.cachedObj(for: key, cachePath: cachePath) {
            return true
        }
        return false
    }
}
