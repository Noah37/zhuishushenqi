//
//  NSObject+Extension.swift
//  zhuishushenqi
//
//  Created by yung on 2018/2/6.
//  Copyright © 2018年 QS. All rights reserved.
//

import Foundation

extension NSObject {
    
    public func fetchProperties() ->[String:Any] {
        var outCount:UInt32 = 0
        let properties = class_copyPropertyList(self.classForCoder, &outCount)
        var dict = [String:Any]()
        let count = Int(outCount)
        for idx in 0..<count  {
            let property = properties![idx]
            let ivarName = property_getName(property)
            let ivarKey = String(cString: ivarName)
            let ivarValue = value(forKey: ivarKey)
            if let iValue = ivarValue {
                dict["\(ivarKey)"] = iValue as Any
            }
        }
        return dict
    }
}
