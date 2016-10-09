//
//  XYCNetworkPrivate.swift
//  CNYNetworking
//
//  Created by caonongyun on 16/7/14.
//  Copyright © 2016年 CNY. All rights reserved.
//

import UIKit

class XYCNetworkPrivate: NSObject {

    class func urlStringWithOriginUrlString(originUrlString:String? = "",appendParameters:NSDictionary? = nil) ->String{
        var filteredUrl = originUrlString
        let paraUrlString:String? = self.urlParametersStringFromParameters(appendParameters!)
        if paraUrlString != "" && paraUrlString != nil{
            if (originUrlString! as NSString).rangeOfString("?").location != NSNotFound{
                
                filteredUrl = filteredUrl!.stringByAppendingString(paraUrlString!)
            }else{
                
                filteredUrl = filteredUrl!.stringByAppendingString("?\((paraUrlString! as NSString).substringFromIndex(1))")
            }
            return filteredUrl!
        }else{
            return originUrlString!
        }
    }
    
    class func urlParametersStringFromParameters(parameters:NSDictionary? = nil) ->String{
        let urlParametersString:NSMutableString = NSMutableString(string: "")
        if parameters != nil && parameters?.count > 0{
            for (key,value) in parameters! {
                var valueString = value
                valueString = "\(valueString)"
                valueString = self.urlEncode(valueString as! String)
                urlParametersString.appendString("&\(key)=\(valueString)")
            }
        }
        return urlParametersString as String
    }
    
    class func urlEncode(str:String) ->String{
        //iOS9.0以后抛弃了
        //let result:String = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, str, String(format: "."), ":/?#[]@!$&'()*+,;=", CFStringBuiltInEncodings.UTF8.rawValue) as String
        
        //新方法
        let resultString = str.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        
        return resultString!
    }
}
