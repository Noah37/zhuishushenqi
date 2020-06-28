//
//  ZSSyncStorage.swift
//  zhuishushenqi
//
//  Created by caony on 2020/6/18.
//  Copyright © 2020 QS. All rights reserved.
//

import UIKit

class ZSSyncStorage {
    
    public let serialQueue: DispatchQueue
    public let concurrentQueue: DispatchQueue


    public init(serialQueue: DispatchQueue, concurrentQueue:DispatchQueue) {
        self.serialQueue = serialQueue
        self.concurrentQueue = concurrentQueue
    }
    
    func sync(execute block: () -> Void) {
        serialQueue.sync {
            block()
        }
    }
    
    func async_barrier(execute block: @escaping() -> Void) {
        concurrentQueue.async(flags: .barrier) {
            block()
        }
    }
    
    func async( block : @escaping () -> Void) {
        concurrentQueue.async {
            block()
        }
    }
    
    func async_serial( block : @escaping () -> Void) {
        serialQueue.async {
            block()
        }
    }
}
