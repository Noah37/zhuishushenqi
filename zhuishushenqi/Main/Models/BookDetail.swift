//
//  BookDetail.swift
//  zhuishushenqi
//
//  Created by caonongyun on 16/10/4.
//  Copyright © 2016年 CNY. All rights reserved.
//

import UIKit

@objc(BookDetail)
class BookDetail: NSObject {

    
    var _id:String?
    var author:String?
    var cover:String?
    var creater:String?
    var longIntro:String?
    var title:String?
    var cat:String?
    var majorCate:String?
    var minorCate:String?
    var latelyFollower:String?
    var retentionRatio:String?
    var serializeWordCount:String? //每天更新字数
    var wordCount:String?
    var updated:String?//更新时间
    var tags:NSArray?
    
    class func modelCustomPropertyMapper() ->NSDictionary{
        return ["author":"author","cover":"cover","creater":"creater","longIntro":"longIntro","title":"title","cat":"cat","majorCate":"majorCate","minorCate":"minorCate","latelyFollower":"latelyFollower","retentionRatio":"retentionRatio","serializeWordCount":"serializeWordCount","wordCount":"wordCount","updated":"updated","tags":"tags","_id":"_id"]
    }
}
