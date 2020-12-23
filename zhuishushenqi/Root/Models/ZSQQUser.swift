//
//  ZSQQUser.swift
//  zhuishushenqi
//
//  Created by yung on 2018/10/19.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit
import HandyJSON

class ZSQQLoginResponse: NSObject, HandyJSON ,NSCoding {
    var user:ZSQQUser?
    var token:String = ""
    var isWeixinNew:Bool = false
    var ok:Bool = true
    var isNew:Bool = true
    var bindMobile:Bool = false
    var register:Bool = false
    var code:String = ""
    
    required override init() {}
    
    required init?(coder aDecoder: NSCoder) {
        self.user = aDecoder.decodeObject(forKey: "user") as? ZSQQUser
        self.token = aDecoder.decodeObject(forKey: "token") as! String
        self.isWeixinNew = aDecoder.decodeBool(forKey: "isWeixinNew")
        self.ok = aDecoder.decodeBool(forKey: "ok")
        self.isNew = aDecoder.decodeBool(forKey: "isNew")
        self.bindMobile = aDecoder.decodeBool(forKey: "bindMobile")
        self.register = aDecoder.decodeBool(forKey: "register")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.user, forKey: "user")
        aCoder.encode(self.token, forKey: "token")
        aCoder.encode(self.isWeixinNew, forKey: "isWeixinNew")
        aCoder.encode(self.ok, forKey: "ok")
        aCoder.encode(self.isNew, forKey: "isNew")
        aCoder.encode(self.bindMobile, forKey: "bindMobile")
        aCoder.encode(self.register, forKey: "register")

    }
    
}

class ZSQQUser: NSObject, HandyJSON, NSCoding {
    var _id:String = ""
    var nickname:String = ""
    var avatar:String = ""
    var exp:Int = 0
    var lv:Int = 0
    var gender:String = ""
    var type:String = ""
    var likeCate:ZSLikeCate?
    required override init() {}
    
    required init?(coder aDecoder: NSCoder) {
        self._id = aDecoder.decodeObject(forKey: "_id") as! String
        self.nickname = aDecoder.decodeObject(forKey: "nickname") as! String
        self.avatar = aDecoder.decodeObject(forKey: "avatar") as! String
        self.exp = aDecoder.decodeInteger(forKey: "exp")
        self.lv = aDecoder.decodeInteger(forKey: "lv")
        self.gender = aDecoder.decodeObject(forKey: "gender") as! String
        self.type = aDecoder.decodeObject(forKey: "type") as! String
        self.likeCate = aDecoder.decodeObject(forKey: "likeCate") as? ZSLikeCate

    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self._id, forKey: "_id")
        aCoder.encode(self.nickname, forKey: "nickname")
        aCoder.encode(self.avatar, forKey: "avatar")
        aCoder.encode(self.exp, forKey: "exp")
        aCoder.encode(self.lv, forKey: "lv")
        aCoder.encode(self.gender, forKey: "gender")
        aCoder.encode(self.type, forKey: "type")
        aCoder.encode(self.likeCate, forKey: "likeCate")

    }

}

class ZSLikeCate: NSObject, HandyJSON, NSCoding {
    var male:[String] = []
    var female:[String] = []
    var press:[String] = []
    var picture:[String] = []
    required override init() {}

    required init?(coder aDecoder: NSCoder) {
        self.male = aDecoder.decodeObject(forKey: "male") as! [String]
        self.female = aDecoder.decodeObject(forKey: "female") as! [String]
        self.press = aDecoder.decodeObject(forKey: "press") as! [String]
        self.picture = aDecoder.decodeObject(forKey: "picture") as! [String]
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.male, forKey: "male")
        aCoder.encode(self.female, forKey: "female")
        aCoder.encode(self.press, forKey: "press")
        aCoder.encode(self.picture, forKey: "picture")

    }
}

//{
//    "user": {
//        "_id": "57ac9879c12b61e826bd7221",
//        "nickname": "高手寂寞",
//        "avatar": "/avatar/80/9c/809cf8858bc8c8008793612a935f72f7",
//        "exp": 2470,
//        "lv": 8,
//        "gender": "female",
//        "type": "normal",
//        "likeCate": {
//            "male": ["都市", "历史", "游戏"],
//            "female": [],
//            "press": [],
//            "picture": []
//        }
//    },
//    "token": "2T6IONkhfG4LEg49w9rCMqwA",
//    "isWeixinNew": false,
//    "ok": true,
//    "isNew": false,
//    "bindMobile": false,
//    "register": false
//}
