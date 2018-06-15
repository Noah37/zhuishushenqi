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
    
}

@objc(Helpful)
class Helpful: NSObject {
    var no:Int = 0
    var total:Int = 0
    var yes:Int = 0
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
}
