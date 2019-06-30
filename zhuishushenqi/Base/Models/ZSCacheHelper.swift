//
//  ZSCacheHelper.swift
//  zhuishushenqi
//
//  Created by caony on 2019/1/18.
//  Copyright © 2019年 QS. All rights reserved.
//

import UIKit
import Cache

class ZSCacheHelper {
    
    static let bookshelfPath = "/ZSBookShelf"
    static let bookshelfBooksPath = "/ZSBookShelf/Books"
    static let historyPath = "/History"
    
    private let path:String = "/Documents"
    private let fileManager = FileManager.default
    
    var cachePath:String  = "/ZSSQ/"
    var storeKey:String?
    
    static let shared = ZSCacheHelper()
    private init() {
        
    }
    
    // MARK: - get
    func cachedObj() ->Any? {
        if let key = storeKey {
            return cachedObj(for: key)
        }
        return nil
    }
    func cachedObj(for key:String) ->Any? {
        return cachedObj(for: key, cachePath: self.cachePath)
    }
    
    func cachedObj(for key:String, cachePath:String) ->Any? {
        // 去除首尾的斜线
        var realPath = cachePath
        if realPath == "" {
            return nil
        }
        if !realPath.hasPrefix("/") {
            realPath = "/\(realPath)"
        }
        if !realPath.hasSuffix("/") {
            realPath = "\(realPath)/"
        }
        
        let filePath = NSHomeDirectory().appending(path).appending(realPath)
        let fullPath = filePath.appending("\(key.md5())")
        let url = URL(fileURLWithPath: fullPath)
        if let data = try? Data(contentsOf: url) {
            if let obj = NSKeyedUnarchiver.unarchiveObject(with: data) {
                return obj
            }
        }
        return nil
    }
    
    //MARK: - storage
    @discardableResult
    func storage(obj:Any, for key:String, cachePath:String) ->Bool {
        if key == "" {
            return false
        }
        var realPath = cachePath
        if realPath != "" {
            if !realPath.hasPrefix("/") {
                realPath = "/\(realPath)"
            }
            if !realPath.hasSuffix("/") {
                realPath = "\(realPath)/"
            }
        } else {
            realPath = self.cachePath
        }
        let filePath = NSHomeDirectory().appending(path).appending(realPath)
        let data = NSKeyedArchiver.archivedData(withRootObject: obj)
        if data.count == 0 {
            return false
        }
        try? fileManager.createDirectory(atPath: filePath, withIntermediateDirectories: true, attributes: nil)
        let fullPath = filePath.appending("\(key.md5())")
        let success = fileManager.createFile(atPath: fullPath, contents: data, attributes: nil)
        return success
    }
    
    @discardableResult
    func storage(obj:Any, for key:String) ->Bool {
        return storage(obj: obj, for: key, cachePath: self.cachePath)
    }
    
    @discardableResult
    func storage(obj:Any) ->Bool {
        guard let key = storeKey else { return false }
        let success = storage(obj: obj, for: key)
        return success
    }
    
    //MARK: - clear
    @discardableResult
    func clear(for key:String,cachePath:String) ->Bool {
        if key == "" {
            return false
        }
        var realPath = cachePath
        if realPath != "" {
            if !realPath.hasPrefix("/") {
                realPath = "/\(realPath)"
            }
            if !realPath.hasSuffix("/") {
                realPath = "\(realPath)/"
            }
        } else {
            realPath = self.cachePath
        }
        let filePath = NSHomeDirectory().appending(path).appending(realPath)
        let fullPath = filePath.appending("\(key.md5())")
        let exist = fileManager.fileExists(atPath: fullPath)
        if exist {
            try? fileManager.removeItem(atPath: fullPath)
            return true
        }
        return false
    }
}
