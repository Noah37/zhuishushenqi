//
//  Book.swift
//  zhuishushenqi
//
//  Created by Nory Chao on 16/10/4.
//  Copyright © 2016年 QS. All rights reserved.
//

import UIKit

@objc(Book)
class Book: NSObject {

    var author:String?
    var title:String?
    var cat:String?
    var shortIntro:String?
    var retentionRatio:String?
    var latelyFollower:String?
    var cover:String?
    var _id:String?
    
    class func modelCustomPropertyMapper() ->NSDictionary{
        return ["author":"author",
                "title":"title","cat":"cat","shortIntro":"shortIntro","retentionRatio":"retentionRatio","latelyFollower":"latelyFollower","cover":"cover","_id":"_id"]
    }
}
