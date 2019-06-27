//
//  ZSUserBind.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2018/10/20.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit
import HandyJSON

public class ZSUserBind: NSObject, HandyJSON {

    public var bind:ZSUserBinds?
    public var ok = true
    public required override init() {}
}

public class ZSUserBinds: NSObject, HandyJSON {
    
    public var QQ:ZSUserModel?
    public var Weixin:ZSUserModel?
    public var SinaWeibo:ZSUserModel?
    public var Xiaomi:ZSUserModel?
    public var Mobile:ZSUserModel?

    public required override init() {}
}

public class ZSUserModel: NSObject, HandyJSON {
    public var name:String = ""
    
    public required override init() {}
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
