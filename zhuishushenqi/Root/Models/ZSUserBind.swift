//
//  ZSUserBind.swift
//  zhuishushenqi
//
//  Created by yung on 2018/10/20.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit
import HandyJSON

class ZSUserBind: HandyJSON {

    var bind:ZSUserBinds?
    var ok = true
    required init() {}
}

class ZSUserBinds: HandyJSON {
    
    var QQ:ZSUserModel?
    var Weixin:ZSUserModel?
    var SinaWeibo:ZSUserModel?
    var Xiaomi:ZSUserModel?
    var Mobile:ZSUserModel?

    required init() {}
}

class ZSUserModel: HandyJSON {
    var name:String = ""
    
    required init() {}
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
