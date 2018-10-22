//
//  ZSUserBind.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2018/10/20.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit
import HandyJSON

class ZSUserBind: NSObject, HandyJSON {

    var bind:ZSUserBinds?
    var ok = true
    required override init() {}
}

class ZSUserBinds: NSObject, HandyJSON {
    
    var QQ:ZSUserModel?
    var Weixin:ZSUserModel?
    var SinaWeibo:ZSUserModel?
    var Xiaomi:ZSUserModel?
    var Mobile:ZSUserModel?

    required override init() {}
}

class ZSUserModel: NSObject, HandyJSON {
    var name:String = ""
    
    required override init() {}
}

//        {
//            "bind": {
//                "QQ": {},
//                "Weixin": {
//                    "name": "神偷520"
//                },
//                "SinaWeibo": {},
//                "Xiaomi": {},
//                "Mobile": {}
//            },
//            "ok": true
//        }
