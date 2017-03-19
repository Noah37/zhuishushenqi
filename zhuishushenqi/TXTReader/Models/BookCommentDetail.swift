//
//  BookCommentDetail.swift
//  zhuishushenqi
//
//  Created by Nory Chao on 2017/3/14.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit

@objc(BookCommentDetail)
class BookCommentDetail: NSObject {
    
    var _id:String = ""
    var content:String = ""
    var author:BookCommentAuthor = BookCommentAuthor()
    var floor:Int = 0
    var replyAuthor:String = ""
    var likeCount:Int = 0
    var created:String = ""
    var replyTo:ReplyTo = ReplyTo()
    
    
    class func modelCustomPropertyMapper() ->NSDictionary{
        return ["_id":"_id","content":"content","author":"author","floor":"floor","replyAuthor":"replyAuthor","likeCount":"likeCount","created":"created","replyTo":"replyTo"]
    }
}

@objc(ReplyTo)
class ReplyTo: NSObject {
    var _id:String = ""
    var floor:Int = 0
    var author:BookCommentAuthor = BookCommentAuthor()
    class func modelCustomPropertyMapper() ->NSDictionary{
        return ["_id":"_id","floor":"floor","author":"author"]
    }
}
