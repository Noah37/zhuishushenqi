//
//  ZSShelfMessage.swift
//  zhuishushenqi
//
//  Created by caony on 2018/6/8.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit

//@objc(ZSShelfMessage)
class ZSShelfMessage: NSObject {
    
    @objc dynamic var postLink:String = ""
    @objc var highlight:Bool = false {
        didSet{
            if highlight {
                textColor = UIColor.red
            }
        }
    }
    
    //    class func modelCustomPropertyMapper() ->NSDictionary{
    //        return ["postLink":"postLink","highlight":"highlight"]
    //    }
    internal var textColor:UIColor = UIColor.gray
    
    func postMessage() ->(String,String,UIColor){
        var id:String = ""
        var title:String = ""
        
        // 此处如果过滤方式不正确，则返回空,按中文【 开头，]]结尾
        let qsLink:NSString = self.postLink as NSString
        let startRange = qsLink.range(of: "【")
        let endRange = qsLink.range(of: "]]")
        let endContainRange = qsLink.range(of: "]]]")
        let post = qsLink.range(of: "post:")
        if startRange.location == NSNotFound {
            if endRange.location != NSNotFound {
                if qsLink.length > 32 {
                    // 过滤方式变更
                    title = postLink.qs_subStr(start: 32, end: endRange.location)
                    id = postLink.qs_subStr(start: 7, length: 24)
                }
            }
            return (id,title,textColor)
        }
        title = postLink.qs_subStr(start: startRange.location, end: endRange.location)
        if endContainRange.location != NSNotFound {
            title = postLink.qs_subStr(start: startRange.location, end: endContainRange.location - 1)
        }
        if post.location == NSNotFound {
            return (id,title,textColor)
        }
        id = postLink.qs_subStr(start: post.location + post.length, end: startRange.location)
        return (id,title,textColor)
    }
}
