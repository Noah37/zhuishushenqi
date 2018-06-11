//
//  Dictionary.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2018/2/11.
//  Copyright © 2018年 QS. All rights reserved.
//

import Foundation

extension Dictionary {
    public func valueForKey(key:String) ->Any?{
        let dict = self as NSDictionary
        let value  = dict[key]
        return value
    }
    
    public func key(at index:Int) ->String{
        let dict = self as NSDictionary
        let keys = dict.allKeys
        let key = keys[index] as? String
        return key ?? ""
    }
    
    public func value(at index:Int) ->Any?{
        let dict = self as NSDictionary
        let values = dict.allValues
        let value = values[index] as? BookDetail
        return value
    }
    
    public func allKeys()->[String]{
        let dict = self as NSDictionary
        let allKeys = dict.allKeys as! [String]
        return allKeys
    }
    
    public func allValues()->[Any]{
        let dict = self as NSDictionary
        let allValues = dict.allValues as! [Any]
        return allValues
    }
}
