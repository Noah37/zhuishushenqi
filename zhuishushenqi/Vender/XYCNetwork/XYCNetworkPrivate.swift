//
//  XYCNetworkPrivate.swift
//  CNYNetworking
//
//  Created by caonongyun on 16/7/14.
//  Copyright © 2016年 CNY. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class XYCNetworkPrivate: NSObject {

    class func urlStringWithOriginUrlString(_ originUrlString:String? = "",appendParameters:NSDictionary? = nil) ->String{
        var filteredUrl = originUrlString
        let paraUrlString:String? = self.urlParametersStringFromParameters(appendParameters!)
        if paraUrlString != "" && paraUrlString != nil{
            if (originUrlString! as NSString).range(of: "?").location != NSNotFound{
                
                filteredUrl = filteredUrl! + paraUrlString!
            }else{
                
                filteredUrl = filteredUrl! + "?\((paraUrlString! as NSString).substring(from: 1))"
            }
            return filteredUrl!
        }else{
            return originUrlString!
        }
    }
    
    class func urlParametersStringFromParameters(_ parameters:NSDictionary? = nil) ->String{
        let urlParametersString:NSMutableString = NSMutableString(string: "")
        if parameters != nil && parameters?.count > 0{
            for (key,value) in parameters! {
                var valueString = value
                valueString = "\(valueString)"
                valueString = self.urlEncode(valueString as! String)
                urlParametersString.append("&\(key)=\(valueString)")
            }
        }
        return urlParametersString as String
    }
    
    class func urlEncode(_ str:String) ->String{
        //iOS9.0以后抛弃了
        //let result:String = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, str, String(format: "."), ":/?#[]@!$&'()*+,;=", CFStringBuiltInEncodings.UTF8.rawValue) as String
        
        //新方法
        let resultString = str.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        return resultString!
    }
}
