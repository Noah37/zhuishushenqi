//
//  ZSCoin.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2018/10/20.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit
import HandyJSON

public class ZSCoin: NSObject, HandyJSON {

    public var ok = true
    public var info:ZSCoinInfo?
    public required override init() {}

}

public class ZSCoinInfo: NSObject, HandyJSON {
    public var total:CGFloat = 0
    public var gold:CGFloat = 100
    public var balance:String = "0.00"
    public var yGold:CGFloat = 0
    public var yBalance:String = "0.00"
    public var name:String = ""
    public var IDCardNo:String = ""
    public var phone:String = ""
    public var address:String = ""
    public var autoEnchashmentVoucher = false
    public var nickname:String = ""
    public var avatar:String = ""
    
    public required override init() {}
}

//{
//    "ok": true,
//    "info": {
//        "total": 0,
//        "gold": 100,
//        "balance": "0.00",
//        "yGold": 0,
//        "yBalance": "0.00",
//        "name": "",
//        "IDCardNo": "",
//        "phone": "",
//        "address": "",
//        "autoEnchashmentVoucher": false,
//        "nickname": "神偷520",
//        "avatar": "/icon/avatar.png"
//    }
//}
