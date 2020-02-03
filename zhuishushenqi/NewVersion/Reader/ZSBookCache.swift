//
//  ZSBookCache.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2020/1/5.
//  Copyright © 2020 QS. All rights reserved.
//

import UIKit

class ZSBookCache {
    
    static let share = ZSBookCache()
    
    private init() {
        
    }
    
    @discardableResult
    func cacheContent(content:ZSBookChapter, for book:String) ->Bool {
        ZSBookMemoryCache.share.cacheContent(content: content, for: book)
        ZSBookDiskCache.share.cacheContent(content: content, for: book)
        return true
    }
    
    func content(for key:String, book:String) ->ZSBookChapter? {
        if let obj = ZSBookMemoryCache.share.content(for: key) {
            return obj
        } else if let obj = ZSBookDiskCache.share.content(for: key, book: book) {
            // 内存缓存不存在,磁盘缓存存在,则将磁盘缓存加载到内存中
            ZSBookMemoryCache.share.cacheContent(content: obj, for: key)
            return obj
        }
        return nil
    }
    
    func isContentExist(_ key:String, book:String) ->Bool {
        if ZSBookMemoryCache.share.isContentExist(key) {
            return true
        } else if ZSBookDiskCache.share.isContentExist(key, book: book) {
            return true
        }
        return false
    }

    func remove(_ key:String, book:String) {
        ZSBookMemoryCache.share.remove(key)
        ZSBookDiskCache.share.remove(key, book: book)
    }
    
    func remove(_ book:String) {
        ZSBookMemoryCache.share.removeAllCache()
        ZSBookDiskCache.share.remove(book)
    }
}
