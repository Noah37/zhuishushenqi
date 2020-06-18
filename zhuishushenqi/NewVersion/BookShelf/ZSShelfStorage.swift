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
    
    static var share = ZSShelfStorage()
    private init() {
        self.syncStorage = ZSSyncStorage(serialQueue:  DispatchQueue(label: "ZSSQ.ZSSyncStorage.SerialQueue"), concurrentQueue:DispatchQueue(label: "ZSSQ.ZSSyncStorage.ConcurrentQueue", qos: .userInitiated, attributes: .concurrent))
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
            block(nil)
            return
        }
        syncStorage.async_barrier {
            let data:NSData? = FileManager.default.contents(atPath: path) as NSData?
            block(data)
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
            block(nil)
            return
        }
        syncStorage.async_barrier {
            if let data = FileManager.default.contents(atPath: path) {
                let obj:Any? = NSKeyedUnarchiver.unarchiveObject(with: data)
                block(obj)
            } else {
                block(nil)
            }
        }
    }
}
