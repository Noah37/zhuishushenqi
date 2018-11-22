//
//  ZSJSON.swift
//  zhuishushenqi
//
//  Created by caony on 2018/11/20.
//  Copyright © 2018 QS. All rights reserved.
//

import UIKit

protocol ZSJSON {
    func toJSONModel() -> Any?
}

extension ZSJSON {
    func toJSONModel() -> Any? {
        let mirror = Mirror(reflecting: self)
        if mirror.children.count > 0 {
            var result : [String:Any] = [:]
            for children in mirror.children {
                let propertyNameString = children.label!
                let value = children.value
                if let jsonValue = value as? ZSJSON {
                    result[propertyNameString] = jsonValue.toJSONModel()
                }
            }
            return result
        }
        return self
    }
}

extension Optional : ZSJSON {
    func toJSONModel() -> Any? {
        if let x = self {
            if let value = x as? ZSJSON {
                return value.toJSONModel()
            }
        }
        return nil
    }
}

extension String : ZSJSON {}
extension Int : ZSJSON {}
extension Bool : ZSJSON {}
extension CGFloat : ZSJSON {}
extension Float : ZSJSON {}
extension Double : ZSJSON {}
extension Dictionary : ZSJSON {
    func encode(obj:Any) -> Any? {
        let mirror = Mirror(reflecting: obj)
        
        return nil
    }
}
extension Array : ZSJSON {}
