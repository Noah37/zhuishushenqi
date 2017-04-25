//
//  CategoryModel.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/3/10.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit

@objc(CategoryModel)
class CategoryModel: NSObject {

    var _id:String  = ""
    var title:String = ""
    var author:String = ""
    var shortIntro:String = ""
    var cover:String = ""
    var site:String = ""
    var majorCate:String = ""
    var latelyFollower:Int = 0
    var latelyFollowerBase:Int = 0
    var minRetentionRatio:CGFloat = 0
    var retentionRatio:CGFloat = 0
    var lastChapter:String = ""
    var tags:String = ""
    
    
    class func modelCustomPropertyMapper() ->NSDictionary{
        return ["_id":"_id","shortIntro":"shortIntro","title":"title","author":"author","cover":"cover","site":"site","majorCate":"majorCate","latelyFollower":"latelyFollower","latelyFollowerBase":"latelyFollowerBase","minRetentionRatio":"minRetentionRatio","retentionRatio":"retentionRatio","lastChapter":"lastChapter","tags":"tags"]
    }
}
