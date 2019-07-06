//
//  QSHotModel.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/3/22.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit
import HandyJSON

class QSHotModel:HandyJSON {
    var user:QSHotUser = QSHotUser()
    var tweet:QSHotTweet = QSHotTweet()
    
    required init() {}
}

class QSHotUser:HandyJSON{
    var _id:String = ""
    var avatar:String = ""
    var nickname:String = ""
    var activityAvatar:String = ""
    var type:UserType = .none
    var lv:Int = 0
    var gender:String = ""
    
    required init() {
        
    }
}

class QSHotTweet: HandyJSON{
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
    var book:ZSHotBook?
    var haveImage:Bool = false
    
    required init() {}
}

struct ZSHotBook:HandyJSON {
    var _id:String = ""
    var author:String = ""
    var title:String = ""
    var cover:String = ""
    var allowFree:Bool = false
    var apptype:[Int] = []
    var allowMonthly:Bool = false
    var wordCount:Int = 0
    
    init() {}
}

@objcMembers
class ZSDBTestModel:NSObject, ZSDBModel {
    
    var id:String?
    var num:Int = 0
    var data:Data?
    var subModel:ZSDBTestSubModel?
    
    func tableName() -> String! {
        return "bookshelf"
    }
    
    func primaryKey() -> String! {
        return ""
    }
    
    func foreignKey() -> String! {
        return ""
    }
    
    func dbColumnMapping() -> [String : String]! {
        return [:]
    }
    
    func ignoredKeys() -> [String]! {
        return []
    }
}

@objcMembers
class ZSDBTestSubModel:NSObject, ZSDBModel {
    @objc dynamic var key:String?
    
    func tableName() -> String! {
        return "record"
    }
    
    func primaryKey() -> String! {
        return ""
    }
    
    func foreignKey() -> String! {
        return ""
    }
    
    func dbColumnMapping() -> [String : String]! {
        return [:]
    }
    
    func ignoredKeys() -> [String]! {
        return []
    }
}

//{
//    "user": {
//        "_id": "56ada4e2c911b9455cedeaee",
//        "avatar": "/avatar/87/40/8740ea7f3c175a40092bdd7ab906d5ed",
//        "nickname": "魅影鹿",
//        "activityAvatar": "",
//        "type": "normal",
//        "lv": 8,
//        "gender": "male"
//    },
//    "tweet": {
//        "_id": "58d128b8c7d432f527f1d736",
//        "title": "搞笑段子！！三十一！！",
//        "content": "1、邻居家孩子百日宴，作为邻居老王的我参加这次庆生，喝高兴了，就唱了首最拿手的歌曲：我种下一颗种子，终于长出了果实...我擦...不说了，被打的血到现在还没止住呢！\n2、一哥们姓王，大家都调侃的叫他“隔壁老王”，有天他终于给他说急了，他强忍住后淡定的和我们说：以后你们就叫我老王吧！后来...我们就叫他“老王八...老王八”\n3、老王经常和他媳妇吵架，一吵架他媳妇就会娘家了，老王也不管，过了几天后又回来了，久而久之就习惯了，一天又和媳妇吵架了，老王事后想想挺对不住媳妇的，就去娘家接她，到了娘家老丈人说：几个月不见你们回来一次，怎么？你媳妇没和你一起回来啊？\n4、下班回家的路上看到小侄子和一个男孩还有一个女孩一起玩耍，小女孩说：我演妈妈，你演粑粑...然后指着小侄子说：你演隔壁老王，重要的是那两熊孩子竟然同意了！\n5、老王说：我打错我媳妇了。我说：怎么了？老王说：我发现我媳妇在日记本里写着和隔壁邻居偷情的事。我激动的说：恩...这种事打就对了！老王说：不是，后来我才想起那个隔壁邻居是我...\n6问：为什么有的人找对象就像在菜市场买菜，想要就能有呢？神回复：可能他认识优秀的农民。\n7、问：为什么很多男人在结婚后有了孩子就会长胖。神回复：因为有奶喝，营养高。\n8、问：我得了健忘症怎么办？神回复：那岂不是很爽，每天早上起来都发现自己睡不同的男人...\n9、问：男友和我闹矛盾了，是我逼太紧了吗？神回：不，是太松了！\n10、问：你见过最娘的男人是什么样？神回复：打飞机用兰花指...",
//        "__v": 0,
//        "hotAt": "2017-03-22T01:07:23.875Z",
//        "post": null,
//        "votes": [],
//        "deleted": false,
//        "isHot": true,
//        "score": 0,
//        "commented": 2,
//        "retweeted": 0,
//        "type": "ARTICLE",
//        "created": "2017-03-21T13:20:56.736Z"
//    }
//}
