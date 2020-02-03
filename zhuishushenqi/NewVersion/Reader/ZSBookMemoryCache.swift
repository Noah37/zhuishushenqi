//
//  ZSBookMemoryCache.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2020/1/5.
//  Copyright © 2020 QS. All rights reserved.
//

import UIKit


/// key:url,value:text
class ZSBookMemoryCache {
    
    /// key:chapterId or link, value:chapterContent
    private var chapterInfo:[String:ZSBookChapter] = [:]
    
    static let share = ZSBookMemoryCache()
    private init() {
        
    }
    
    @discardableResult
    func cacheContent(content:ZSBookChapter, for key:String) ->Bool {
        chapterInfo[content.chapterUrl] = content
        return true
    }
    
    func content(for key:String) ->ZSBookChapter? {
        if let obj = chapterInfo[key] {
            return obj
        }
        return nil
    }
    
    func isContentExist(_ key:String) ->Bool {
        let content = chapterInfo[key]
        return content != nil
    }
    
    func removeAllCache() {
        chapterInfo.removeAll()
    }
    
    func remove(_ key:String) {
        chapterInfo.removeValue(forKey: key)
    }
}
