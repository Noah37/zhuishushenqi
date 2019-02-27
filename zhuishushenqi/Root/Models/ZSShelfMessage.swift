//
//  ZSShelfMessage.swift
//  zhuishushenqi
//
//  Created by caony on 2018/6/8.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit
import HandyJSON

enum ZSShelfMessageType {
    case post
    case link
    case booklist
}

//@objc(ZSShelfMessage)
class ZSShelfMessage: NSObject,HandyJSON {
    
    @objc dynamic var postLink:String = ""
    @objc var highlight:Bool = false {
        didSet{
            if highlight {
                textColor = UIColor.red
            }
        }
    }
    
    required override init() {
        
    }
    
    internal var textColor:UIColor = UIColor.gray
    
    func postMessage() ->(String,String, ZSShelfMessageType,UIColor){
        var id:String = ""
        var title:String = ""
        
        // 过滤方式变更
        // 目前已知的有三种 post或者link或booklist
        // post一般跳转到评论页,post后跟的默认为24位的字符串
        // link一般打开链接,link一般以link后的第一个空格作为区分
        // booklist一般打开书单
        
        var type:ZSShelfMessageType = .post
        let qsLink:NSString = self.postLink as NSString
        var typePost = qsLink.range(of: "post:") //[[post:5baf14726f660bbe4fe5dc36 🇨🇳喜迎国庆【惊喜】追书又双叒叕送福利！]]
        if typePost.location == NSNotFound {
            typePost = qsLink.range(of: "link:")
            type = .link
        }
        if typePost.location == NSNotFound {
            typePost = qsLink.range(of: "booklist:")
            type = .booklist
        }
        // 去除首尾的中括号,再以空格区分文字与post
        let noLeadLink = self.postLink.qs_subStr(from: 2)
        let noTailLink = noLeadLink.substingInRange(0..<(noLeadLink.count - 2)) ?? noLeadLink
        let spaceRange = (noTailLink as NSString).range(of: " ")
        id = noTailLink.substingInRange(typePost.length..<spaceRange.location) ?? noLeadLink
        title = noTailLink.qs_subStr(from: spaceRange.location + 1)
        return (id, title, type, textColor)
    }
}
