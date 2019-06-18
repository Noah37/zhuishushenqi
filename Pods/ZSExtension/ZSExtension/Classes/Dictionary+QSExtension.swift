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
        let value = values[index]
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
    
    //MARK: - transform
    public var toJSON: String {
        if !JSONSerialization.isValidJSONObject(self) {
            return ""
        }
        if let data  = try? JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.init(rawValue: 0)) {
            if let jsonString = String(data: data, encoding: .utf8) {
                return jsonString
            }
        }
        return ""
    }
}

extension Dictionary where Value: Any {
    
    public func decoding<T>(with key: Key) -> T? {
        guard let any: Any = self[key] else {
            return nil
        }
        if let value: T = any as? T {
            return value
        } else {
            switch T.self {
            case is String.Type:
                switch any {
                case let someInt as Int:
                    return String(someInt) as? T
                case let someDouble as Double:
                    return String(someDouble) as? T
                case let someBool as Bool:
                    return String(someBool) as? T
                default:
                    return nil
                }
            case is Int.Type:
                if let someString: String = any as? String {
                    return Int(someString) as? T
                } else if let someDouble: Double = any as? Double {
                    return Int(someDouble) as? T
                } else {
                    return nil
                }
            case is Double.Type:
                if let someString: String = any as? String {
                    return Double(someString) as? T
                } else if let someInt: Int = any as? Int {
                    return Double(someInt) as? T
                } else {
                    return nil
                }
            case is Bool.Type:
                if let someString: String = any as? String {
                    return Bool(someString) as? T
                } else {
                    return nil
                }
            default:
                return nil
            }
        }
    }
}
