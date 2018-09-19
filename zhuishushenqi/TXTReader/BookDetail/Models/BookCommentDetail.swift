//
//  BookCommentDetail.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/3/14.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit
import YYKit
import HandyJSON

@objc(BookCommentDetail)
class BookCommentDetail: NSObject,HandyJSON {
    
    var _id:String = ""
    var content:String = "" {
        didSet{
//            let attri = NSMutableAttributedString(string: "")
//            let scale:CGFloat = 1.149
//            var font:CGFloat = 12
//            let version = Double(UIDevice.current.systemVersion) ?? 10.0
//            if  version >= 10.0 {
//                if content.characters.count < 80{
//                    font = font*scale
//                }else{
//                    font = font*1.05
//                }
//            }
//            attri.append(NSMutableAttributedString(string: content,attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: font)]))
//            
//            let textContainer = YYTextContainer(size: CGSize(width: ScreenWidth - 65, height: 9999))
//            self.textLayout = YYTextLayout(container: textContainer, text: attri)
        }
    }
    var author:BookCommentAuthor = BookCommentAuthor()
    var floor:Int = 0 {
        didSet{
            let width = "\(floor)楼".qs_width(UIFont.systemFont(ofSize: 12), height: 21)
            floorWidth = width + 5
        }
    }
    var replyAuthor:String = ""
    var likeCount:Int = 0
    var created:String = ""
    var replyTo:ReplyTo?
    var height:CGFloat = 0
    var replyHeight:CGFloat = 0
    var floorWidth:CGFloat = 0
    var textLayout:YYTextLayout?

    required override init() {
        
    }
}

@objc(ReplyTo)
class ReplyTo: NSObject,HandyJSON {
    var _id:String = ""
    var floor:Int = 0
    var author:BookCommentAuthor = BookCommentAuthor()
    
    required override init() {
        
    }
}
