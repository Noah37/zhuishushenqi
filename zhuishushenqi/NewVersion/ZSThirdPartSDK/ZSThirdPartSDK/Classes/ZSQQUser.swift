//
//  ZSQQUser.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2018/10/19.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit
import HandyJSON

@objcMembers
public class ZSQQLoginResponse: NSObject, HandyJSON ,NSCoding {
    public var user:ZSQQUser?
    public var token:String = ""
    public var isWeixinNew:Bool = false
    public var ok:Bool = true
    public var isNew:Bool = true
    public var bindMobile:Bool = false
    public var register:Bool = false
    public var code:String = ""
    
    public required override init() {}
    
    public required init?(coder aDecoder: NSCoder) {
        self.user = aDecoder.decodeObject(forKey: "user") as? ZSQQUser
        self.token = aDecoder.decodeObject(forKey: "token") as! String
        self.isWeixinNew = aDecoder.decodeBool(forKey: "isWeixinNew")
        self.ok = aDecoder.decodeBool(forKey: "ok")
        self.isNew = aDecoder.decodeBool(forKey: "isNew")
        self.bindMobile = aDecoder.decodeBool(forKey: "bindMobile")
        self.register = aDecoder.decodeBool(forKey: "register")
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.user, forKey: "user")
        aCoder.encode(self.token, forKey: "token")
        aCoder.encode(self.isWeixinNew, forKey: "isWeixinNew")
        aCoder.encode(self.ok, forKey: "ok")
        aCoder.encode(self.isNew, forKey: "isNew")
        aCoder.encode(self.bindMobile, forKey: "bindMobile")
        aCoder.encode(self.register, forKey: "register")

    }
    
}

@objcMembers
public class ZSQQUser: NSObject, HandyJSON, NSCoding {
    public var _id:String = ""
    public var nickname:String = ""
    public var avatar:String = ""
    public var exp:Int = 0
    public var lv:Int = 0
    public var gender:String = ""
    public var type:String = ""
    public var likeCate:ZSLikeCate?
    public required override init() {}
    
    public required init?(coder aDecoder: NSCoder) {
        self._id = aDecoder.decodeObject(forKey: "_id") as! String
        self.nickname = aDecoder.decodeObject(forKey: "nickname") as! String
        self.avatar = aDecoder.decodeObject(forKey: "avatar") as! String
        self.exp = aDecoder.decodeInteger(forKey: "exp")
        self.lv = aDecoder.decodeInteger(forKey: "lv")
        self.gender = aDecoder.decodeObject(forKey: "gender") as! String
        self.type = aDecoder.decodeObject(forKey: "type") as! String
        self.likeCate = aDecoder.decodeObject(forKey: "likeCate") as? ZSLikeCate

    }
    
    public func encode(with aCoder: NSCoder) {
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

@objcMembers
public class ZSLikeCate: NSObject, HandyJSON, NSCoding {
    public var male:[String] = []
    public var female:[String] = []
    public var press:[String] = []
    public var picture:[String] = []
    public required override init() {}

    public required init?(coder aDecoder: NSCoder) {
        self.male = aDecoder.decodeObject(forKey: "male") as! [String]
        self.female = aDecoder.decodeObject(forKey: "female") as! [String]
        self.press = aDecoder.decodeObject(forKey: "press") as! [String]
        self.picture = aDecoder.decodeObject(forKey: "picture") as! [String]
    }
    
    public func encode(with aCoder: NSCoder) {
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
