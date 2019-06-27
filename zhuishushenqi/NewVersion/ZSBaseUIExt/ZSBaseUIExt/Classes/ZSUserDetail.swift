//
//  ZSUserDetail.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2018/10/20.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit
import HandyJSON

public class ZSUserDetail: NSObject, HandyJSON {
    
    public var _id:String = ""
    public var nickname:String = ""
    public var avatar:String = ""
    public var exp:CGFloat = 25
    public var rank:CLongLong = 0
    public var lv:Int = 0
    public var vipLv:Int = 0
    public var mobile:CLongLong = 0
    public var type:String = ""
    public var gender:String = ""
    public var genderChanged = false
    public var today_tasks:ZSUserDetailTodayTask?
    public var this_week_tasks:ZSUserDetailThisWeekTask?
    public var post_count:ZSUserDetailPostCount?
    public var book_list_count:ZSUserDetailTodayTask?
    public var lastDay = 0
    public var ok = true

    public required override init() {}
}

public class ZSUserDetailTodayTask: NSObject,HandyJSON {
    public var launch = false
    public var post = false
    public var comment = false
    public var vote = false
    public var share = false
    public var share_book = false
    public var flopen = false
    
    public required override init() {}
}

public class ZSUserDetailThisWeekTask: NSObject, HandyJSON {
    public var rate = false
    public required override init() {
        
    }
}

public class ZSUserDetailPostCount: NSObject,HandyJSON {
    public var posted = 0
    public var collected = 0
    
    public required override init() {
        
    }
}

public class ZSUserDetailBookListCount: NSObject, HandyJSON {
    public var posted = 0
    public var collected = 0
    
    public required override init() {
        
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
