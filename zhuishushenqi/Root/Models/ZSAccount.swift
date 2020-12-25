//
//  ZSAccount.swift
//  zhuishushenqi
//
//  Created by yung on 2018/10/20.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit
import HandyJSON


class ZSAccount: HandyJSON {

    var balance:CGFloat = 0
    var iosBalance:CGFloat = 0
    var voucherBalance:CGFloat = 62
    var beanVoucherBalance:CGFloat = 0
    var monthly:Int = 0
    var isMonthly:Bool = false
    var voucherCount:Int = 0
    var beanVoucherCount:Int = 0
    var isNewUser:Bool = false
    var time:CGFloat = 0
    var voucherSum:Int = 0
    var isFree:Bool = false
    var freeTime:CLongLong = 1537431804
    var isAppstoreAutoMonthly = false
    var ok = true
    
    required init() {}
}
//{
//    "balance": 0,
//    "iosBalance": 0,
//    "voucherBalance": 62,
//    "beanVoucherBalance": 0,
//    "monthly": 0,
//    "isMonthly": false,
//    "voucherCount": 2,
//    "beanVoucherCount": 0,
//    "isNewUser": false,
//    "time": 0,
//    "voucherSum": 62,
//    "isFree": false,
//    "freeTime": 1537431804,
//    "isAppstoreAutoMonthly": false,
//    "ok": true
//}
