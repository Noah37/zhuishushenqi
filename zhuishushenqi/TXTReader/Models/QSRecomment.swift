//
//  QSRecomment.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2017/4/21.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit

@objc(QSRecomment)
class QSRecomment: NSObject {
    
    var id:String = ""
    var title:String = ""
    var author:String = ""
    var site:String = ""
    var cover:String = ""
    var shortIntro:String = ""
    var lastChapter:String = ""
    var retentionRatio:CGFloat = 0
    var latelyFollower:Int = 0
    var cat:String = ""
    var majorCate:String = ""
    var minorCate:String = ""
    
    
    class func modelCustomPropertyMapper() ->NSDictionary{
        return ["author":"author","site":"site","lastChapter":"lastChapter","cat":"cat","majorCate":"majorCate","minorCate":"minorCate",
                "title":"title","cat":"cat","shortIntro":"shortIntro","retentionRatio":"retentionRatio","latelyFollower":"latelyFollower","cover":"cover","id":"_id"]
    }
}
