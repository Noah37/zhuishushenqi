//
//  ZSUserDetail.swift
//  zhuishushenqi
//
//  Created by yung on 2018/10/20.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit
import HandyJSON

class ZSUserDetail: NSObject, HandyJSON {
    
    var _id:String = ""
    var nickname:String = ""
    var avatar:String = ""
    var exp:CGFloat = 25
    var rank:CLongLong = 0
    var lv:Int = 0
    var vipLv:Int = 0
    var mobile:CLongLong = 0
    var type:String = ""
    var gender:String = ""
    var genderChanged = false
    var today_tasks:ZSUserDetailTodayTask?
    var this_week_tasks:ZSUserDetailThisWeekTask?
    var post_count:ZSUserDetailPostCount?
    var book_list_count:ZSUserDetailTodayTask?
    var lastDay = 0
    var ok = true

    required override init() {}
}

class ZSUserDetailTodayTask: NSObject,HandyJSON {
    var launch = false
    var post = false
    var comment = false
    var vote = false
    var share = false
    var share_book = false
    var flopen = false
    
    required override init() {}
}

class ZSUserDetailThisWeekTask: NSObject, HandyJSON {
    var rate = false
    required override init() {
        
    }
}

class ZSUserDetailPostCount: NSObject,HandyJSON {
    var posted = 0
    var collected = 0
    
    required override init() {
        
    }
}

class ZSUserDetailBookListCount: NSObject, HandyJSON {
    var posted = 0
    var collected = 0
    
    required override init() {
        
    }
}

//{
//    "_id": "5bc9c8706900af100060ea21",
//    "nickname": "神偷520",
//    "avatar": "/icon/avatar.png",
//    "exp": 25,
//    "rank": 0.003558718861209953,
//    "lv": 2,
//    "vipLv": 0,
//    "vipExp": 0,
//    "mobile": 0,
//    "type": "normal",
//    "gender": "female",
//    "genderChanged": false,
//    "today_tasks": {
//        "launch": false,
//        "post": false,
//        "comment": true,
//        "vote": true,
//        "share": false,
//        "share_book": false,
//        "fl-open": true
//    },
//    "this_week_tasks": {
//        "rate": true
//    },
//    "post_count": {
//        "posted": 0,
//        "collected": 0
//    },
//    "book_list_count": {
//        "posted": 0,
//        "collected": 0
//    },
//    "lastDay": 0,
//    "ok": true
//}
