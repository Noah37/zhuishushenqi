//
//  QSHotComment.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/3/9.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit

@objc(QSHotComment)
class QSHotComment: NSObject {

    var _id:String = ""
    var content:String = ""
    var rating:Int = 1
    var title:String = ""
    var likeCount:Int = 0
    var state:String = ""
    var updated:String = ""
    var created:String = ""
    var commentCount:Int = 0
    
    var author:Author = Author()
    var helpful:Helpful = Helpful()
    var book:QSHotBook = QSHotBook()
    
    class func modelCustomPropertyMapper() ->NSDictionary{
        return ["_id":"_id","content":"content","rating":"rating","title":"title","likeCount":"likeCount","state":"state","updated":"updated","created":"created","commentCount":"commentCount","author":"author","helpful":"helpful"]
    }
}

@objc(Author)
class Author: NSObject {
    var _id:String = ""
    var avatar:String = ""
    var nickname:String = ""
    var activityAvatar:String = ""
    var type:String = ""
    var lv:Int = 0
    var gender:String = ""
    
    class func modelCustomPropertyMapper() ->NSDictionary{
        return ["_id":"_id","avatar":"avatar","nickname":"nickname","activityAvatar":"activityAvatar","type":"type","lv":"lv","gender":"gender"]
    }
}

@objc(Helpful)
class Helpful: NSObject {
    var no:Int = 0
    var total:Int = 0
    var yes:Int = 0
    class func modelCustomPropertyMapper() ->NSDictionary{
        return ["no":"no","total":"total","yes":"yes"]
    }
}

//"book": {
//    "_id": "51d11e782de6405c45000068",
//    "cover": "/agent/http://image.cmfu.com/books/2750457/2750457.jpg",
//    "title": "大主宰",
//    "id": "51d11e782de6405c45000068",
//    "latelyFollower": null,
//    "retentionRatio": null
//},
@objc(QSHotBook)
class QSHotBook: NSObject {
    var id:String = ""
    var cover:String = ""
    var title:String = ""
    var latelyFollower = ""
    var retentionRatio = "'"
    class func modelCustomPropertyMapper() ->NSDictionary{
        return ["id":"id","cover":"cover","title":"title","latelyFollower":"latelyFollower","retentionRatio":"retentionRatio"]
    }
}
