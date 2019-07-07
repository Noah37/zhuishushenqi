//
//  ZSNotification.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2019/7/7.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit
import HandyJSON

enum MsgType:String,HandyJSONEnum {
    case none = ""
    case postPush = "post_push"
    case commentReply = "comment_reply"
    case commentLike = "comment_like"
    
    var image:UIImage? {
        switch self {
        case .postPush:
            return UIImage(named: "personal_icon_topic_14_14_14x14_")
        case .commentReply:
            return UIImage(named: "personal_icon_reply_14_14_14x14_")
        case .commentLike:
            return UIImage(named: "personal_icon_reply_14_14_14x14_")
        default:
            return nil
        }
    }
}

struct ZSNotification:HandyJSON {
    
    var _id:String = ""
    var type:MsgType = .postPush
    var post:ZSNotificationPost?
    var title:String = ""
    var trigger:ZSNotificationTrigger?
    var comment:ZSNotificationComment?
    var myComment:ZSNotificationMyComment?
    var deleted:Bool = false
    var created:String = ""

}

struct ZSNotificationPost:HandyJSON {
    var _id:String = ""
    var type:UserType = .normal
    var title:String = ""
}

struct ZSNotificationTrigger:HandyJSON {
    var _id:String = ""
    var avatar:String = ""
    var nickname:String = ""
    var type:UserType = .normal
    var lv:Int = 0
    var gender:String = ""
}

struct ZSNotificationComment:HandyJSON {
    var _id:String = ""
    var content:String = ""
    var floor:Int = 0
}

struct ZSNotificationMyComment:HandyJSON {
    var _id:String = ""
    var content:String = ""
}
//{
//    "notifications": [{
//    "_id": "5c9df5ba113ca53246a60349",
//    "type": "post_push",
//    "post": {
//    "_id": "5c9df54461465a4c4605170a",
//    "type": "normal",
//    "title": "【好消息】追书喜提晋江，各路大神文应有尽有,万本精品同步更新中！"
//    },
//    "title": "【好消息】晋江掌阅好书来了！各路大神文应有尽有，万本精品同步更新中！",
//    "trigger": null,
//    "comment": null,
//    "myComment": null,
//    "deleted": false,
//    "created": "2019-03-29T10:38:50.298Z"
//    }, {
//    "_id": "5c4151669cb008ec1e0a730d",
//    "type": "comment_reply",
//    "post": {
//    "_id": "5c3fffd1b250154e3737ad54",
//    "type": "normal",
//    "title": "〔推书〕:读书人不得不看的三本优质网文！😉（含书评）"
//    },
//    "user": "57ac9879c12b61e826bd7221",
//    "myComment": {
//    "_id": "5c4130cc18dd9c1c65086261",
//    "content": "可以\\n不错哟"
//    },
//    "comment": {
//    "_id": "5c4151669cb008ec1e0a730c",
//    "content": "谢谢💓",
//    "floor": 26
//    },
//    "trigger": {
//    "_id": "57d9fa98d466c43c346612bf",
//    "avatar": "/avatar/5b/4c/5b4c8db957f7db769e251fff6681f68c",
//    "nickname": "ઇGodfatherଓ",
//    "type": "normal",
//    "lv": 10,
//    "gender": "female"
//    },
//    "deleted": false,
//    "created": "2019-01-18T04:09:10.000Z"
//    }, {
//    "_id": "5be71c0b2b6cdd1000ef8bcc",
//    "type": "comment_reply",
//    "post": {
//    "_id": "5be29607474e10bd576ec1e4",
//    "type": "normal",
//    "title": "随便画画"
//    },
//    "user": "57ac9879c12b61e826bd7221",
//    "myComment": {
//    "_id": "5be70b63d0074f1000171921",
//    "content": "测试下评论，没有做超链接的展示"
//    },
//    "comment": {
//    "_id": "5be71c0b2b6cdd1000ef8bcb",
//    "content": "什么鬼◑▂◑◐▂◐",
//    "floor": 24
//    },
//    "trigger": {
//    "_id": "5addba11c127e26e7ef59051",
//    "avatar": "/avatar/d0/ee/d0ee266d66821762d950a8096aaa8548",
//    "nickname": "七月殇",
//    "type": "normal",
//    "lv": 7,
//    "gender": "male"
//    },
//    "deleted": false,
//    "created": "2018-11-10T17:57:31.000Z"
//    }, {
//    "_id": "5be4237d7ccde0c779bbbc6d",
//    "type": "comment_reply",
//    "post": {
//    "_id": "5be29607474e10bd576ec1e4",
//    "type": "normal",
//    "title": "随便画画"
//    },
//    "user": "57ac9879c12b61e826bd7221",
//    "myComment": {
//    "_id": "5be41fa3acc7d9350a427903",
//    "content": "试试"
//    },
//    "comment": {
//    "_id": "5be4237d7ccde0c779bbbc6c",
//    "content": "什么",
//    "floor": 16
//    },
//    "trigger": {
//    "_id": "5addba11c127e26e7ef59051",
//    "avatar": "/avatar/d0/ee/d0ee266d66821762d950a8096aaa8548",
//    "nickname": "七月殇",
//    "type": "normal",
//    "lv": 7,
//    "gender": "male"
//    },
//    "deleted": false,
//    "created": "2018-11-08T11:52:29.000Z"
//    }, {
//    "_id": "5bb1b0100e7abeaa7362fd86",
//    "type": "post_push",
//    "post": {
//    "_id": "5baf14726f660bbe4fe5dc36",
//    "type": "vote",
//    "title": "【活动】🇨🇳国庆七天乐：红歌大比拼，更多活动豪礼砸不停~【楼层奖励名单已出】"
//    },
//    "title": "[有人@你]🇨🇳喜迎国庆🇨🇳追书七天福利送！最强攻略在这里！",
//    "trigger": null,
//    "comment": null,
//    "myComment": null,
//    "deleted": false,
//    "created": "2018-10-01T05:26:40.131Z"
//    }],
//    "ok": true
//}
