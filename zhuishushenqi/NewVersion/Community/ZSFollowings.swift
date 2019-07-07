//
//  ZSFollowings.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2019/7/6.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit
import HandyJSON

enum ZSDynamicType: String,HandyJSONEnum {
    case none = ""
    case retweet = "RETWEET"
    case article = "ARTICLE"
}

struct ZSDynamicTweetFrom:HandyJSON {
    var _id:String = ""
    var avatar:String = ""
    var nickname:String = ""
    var activityAvatar:String = ""
    var type:UserType = .none
    var lv:Int = 0
    var gender:String = ""
}

struct ZSDynamicTweetReTweet:HandyJSON {
    var _id:String = ""
    var title:String = ""
    var content:String = ""
    var __v:Int = 0
    var hotAt:String = ""
    var post:[String:Any] = [:]
    var votes:[Any] = []
    var deleted:Bool = false
    var isHot:Bool = false
    var score:Int = 0
    var commented:Int = 0
    var retweeted:Int = 0
    var type:String = ""
    var created:String = ""
    var haveImage:Bool = false
}

struct ZSDynamicTweetBook:HandyJSON {
    var _id:String = ""
    var author:String = ""
    var title:String = ""
    var cover:String = ""
    var allowFree:Bool = false
    var apptype:[Int] = []
    var allowMonthly:Bool = false
    var wordCount:Int = 0
}


struct ZSDynamicTweet:HandyJSON {
    var _id:String = ""
    var title:String = ""
    var content:String = ""
    var user:ZSDynaicUser?
    var from:ZSDynamicTweetFrom?
    var refTweet:ZSDynamicTweetReTweet?
    var book:ZSDynamicTweetBook?
    var _v:Int = 0
    var post:Any?
    var votes:[Any] = []
    var deleted:Bool = false
    var isHot:Bool = false
    var score:Int = 0
    var commented:Int = 0
    var retweeted:Int = 0
    var type:ZSDynamicType = .none
    var created:String = ""
    var haveImage:Bool = false
}

struct ZSDynamic:HandyJSON {
    var user:ZSDynaicUser?
    var tweets:[ZSDynamicTweet] = []
}

struct ZSFollowings:HandyJSON {
    var _id: String = ""
    var avatar:String = ""
    var nickname:String = ""
    var mobile:String = ""
    var followers:Int = 0
    var followings:Int = 0
    var tweets:Int = 0
    var type:UserType = .none
    var lv:Int = 0
    
}

struct ZSDynaicUser:HandyJSON {
    var _id:String = ""
    var nickname:String = ""
    var avatar:String = ""
    var exp:Int = 0
    var lv:Int = 0
    var type:UserType = .none
    var gender:String = ""
    var genderChanged:Bool = false
    var tweets:Int = 0
    var followings:Int = 0
    var followers:Int = 0
    var rank:CGFloat = 0
    var bindMobile:Bool = false
    var grouping:ZSDynamicUserGrouping?
}

struct ZSDynamicUserGrouping:HandyJSON {
    var level2_group_id:Int = 0
    var level3_group_id:Int = 0
    var level4_group_id:Int = 0
    var level5_group_id:Int = 0

}

//    user": {
//    "_id": "56e903c1febd4661455a0692",
//    "nickname": "追书家的眼镜娘",
//    "avatar": "/avatar/65/be/65be796b6f8d0e0a8179737752a991c9",
//    "exp": 10270,
//    "lv": 10,
//    "type": "official",
//    "gender": "female",
//    "genderChanged": true,
//    "tweets": 1202,
//    "followings": 44,
//    "followers": 57166,
//    "rank": 0.5946728430804864,
//    "bindMobile": true,
//    "grouping": {
//    "level2_group_id": 51,
//    "level3_group_id": 166,
//    "level4_group_id": 1012,
//    "level5_group_id": 2004
//    }
