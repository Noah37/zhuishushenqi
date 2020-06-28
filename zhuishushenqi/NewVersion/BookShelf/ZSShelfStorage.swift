//
//  ZSShelfStorage.swift
//  zhuishushenqi
//
//  Created by caony on 2020/6/18.
//  Copyright © 2020 QS. All rights reserved.
//

import UIKit

class ZSShelfStorage {
    
    private let syncStorage:ZSSyncStorage
    
    private var cacheDict:[String:Any] = [:]
    
    static var share = ZSShelfStorage()
    
    private init() {
        self.syncStorage = ZSSyncStorage(serialQueue:  DispatchQueue(label: "ZSSQ.ZSSyncStorage.SerialQueue"), concurrentQueue:DispatchQueue(label: "ZSSQ.ZSSyncStorage.ConcurrentQueue", qos: .userInitiated, attributes: .concurrent))
        NotificationCenter.default.addObserver(self, selector: #selector(didReceivememoryWarning), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    private func didReceivememoryWarning() {
        syncStorage.async_barrier {
            self.cacheDict.removeAll()
        }
    }
    
    private func getAndCacheFile(path:String) ->Any? {
        assert(path.length != 0)
        if path.length == 0 {
            return nil
        }
        var result:Any? = nil
        let manager = FileManager.default
        if cacheDict[path] != nil && manager.fileExists(atPath: path) {
            result = cacheDict[path]
            return result
        }
        if manager.fileExists(atPath: path) {
            if let data = manager.contents(atPath: path) {
                result = NSKeyedUnarchiver.unarchiveObject(with: data)
            }
        }
        if result != nil {
            cacheDict[path] = result!
        }
        return result
    }
    
    func object(for path:String) ->Any? {
        let start = CFAbsoluteTimeGetCurrent()
        assert(path.count != 0)
        if path.length == 0 {
            return nil
        }
        var obj:Any? = nil
        syncStorage.sync {
            obj = getAndCacheFile(path: path)
        }
        let end = CFAbsoluteTimeGetCurrent()
        print("get object for key:\(path), time:\(end - start)")
        return obj
    }
    
    @discardableResult
    func setObject(obj:Any, path:String) ->Bool {
        let start = CFAbsoluteTimeGetCurrent()
        assert(path.count != 0)
        if path.length == 0 {
            return false
        }
        syncStorage.sync {
            self.cacheDict[path] = obj
        }
        syncStorage.async_barrier { [weak self] in
            self?.saveFile(path: path, obj: obj)
        }
        let end = CFAbsoluteTimeGetCurrent()
        print("set object for key:\(path), time:\(end - start)")
        return true
    }
    
    @discardableResult
    func removeObject(path:String) ->Bool {
        let start = CFAbsoluteTimeGetCurrent()
        assert(path.count != 0)
        if path.length == 0 {
            return false
        }
        syncStorage.async_barrier { [weak self] in
            self?.removeFile(path: path)
        }
        let end = CFAbsoluteTimeGetCurrent()
        print("set object for key:\(path), time:\(end - start)")
        return true
    }
    
    private func saveFile(path:String, obj:Any){
        syncStorage.async_serial {
            let data = NSKeyedArchiver.archivedData(withRootObject: obj)
            let url = URL(fileURLWithPath: path)
            try? data.write(to: url)
        }
    }
    
    private func removeFile(path:String) {
        syncStorage.async_serial {
            if FileManager.default.fileExists(atPath: path) {
                let url = URL(fileURLWithPath: path)
                try? FileManager.default.removeItem(at: url)
            }
        }
    }
    
    func asyncMain(block:@escaping()->Void) {
        DispatchQueue.main.async {
            block()
        }
    }
    
    func write(data:NSData?, path:String) {
        if data == nil || path.count == 0 {
            return
        }
        syncStorage.async {
            data?.write(toFile: path, atomically: true)
        }
    }
    
    func read(path:String, block:@escaping(_ data:NSData?) ->Void) {
        if path.count == 0 {
            asyncMain {
                block(nil)
            }
            return
        }
        syncStorage.async { [weak self] in
            let data:NSData? = FileManager.default.contents(atPath: path) as NSData?
            self?.asyncMain {
                block(data)
            }
        }
    }
    
    func delete(path:String) {
        if path.count == 0 {
            return
        }
        syncStorage.async {
            try? FileManager.default.removeItem(atPath: path)
        }
    }
    
    func archive(obj:Any?, path:String) {
        if obj == nil || path.count == 0 {
            return
        }
        syncStorage.async {
            let data = NSKeyedArchiver.archivedData(withRootObject: obj!) as NSData
            data.write(toFile: path, atomically: true)
        }
    }
    
    func unarchive(path:String, block:@escaping(_ obj:Any?) ->Void) {
        if path.count == 0 {
            asyncMain {
                block(nil)
            }
            return
        }
        syncStorage.async { [weak self] in
            if let data = FileManager.default.contents(atPath: path) {
                let obj:Any? = NSKeyedUnarchiver.unarchiveObject(with: data)
                self?.asyncMain {
                    block(obj)
                }
            } else {
                self?.asyncMain {
                    block(nil)
                }
            }
        }
    }
}
