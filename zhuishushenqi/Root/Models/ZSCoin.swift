//
//  ZSCoin.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2018/10/20.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit
import HandyJSON

class ZSCoin: NSObject, HandyJSON {

    var ok = true
    var info:ZSCoinInfo?
    required override init() {}

}

class ZSCoinInfo: NSObject, HandyJSON {
    var total:CGFloat = 0
    var gold:CGFloat = 100
    var balance:String = "0.00"
    var yGold:CGFloat = 0
    var yBalance:String = "0.00"
    var name:String = ""
    var IDCardNo:String = ""
    var phone:String = ""
    var address:String = ""
    var autoEnchashmentVoucher = false
    var nickname:String = ""
    var avatar:String = ""
    
    required override init() {}
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
