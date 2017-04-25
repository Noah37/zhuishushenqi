//
//  Book.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 16/10/4.
//  Copyright © 2016年 QS. All rights reserved.
//

import UIKit

@objc(Book)
class Book: NSObject {

    var author:String?
    var title:String?
    var cat:String?
    var majorCate:String = ""
    var shortIntro:String?
    var retentionRatio:CGFloat = 0
    var latelyFollower:CGFloat = 0
    var cover:String?
    var _id:String?
    
    class func modelCustomPropertyMapper() ->NSDictionary{
        return ["author":"author",
                "title":"title","cat":"cat","shortIntro":"shortIntro","retentionRatio":"retentionRatio","latelyFollower":"latelyFollower","cover":"cover","_id":"_id","majorCate":"majorCate"]
    }
}
