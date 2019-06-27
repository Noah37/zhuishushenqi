//
//  ZSAccount.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2018/10/20.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit
import HandyJSON


public class ZSAccount: NSObject, HandyJSON {

    public var balance:CGFloat = 0
    public var iosBalance:CGFloat = 0
    public var voucherBalance:CGFloat = 62
    public var beanVoucherBalance:CGFloat = 0
    public var monthly:Int = 0
    public var isMonthly:Bool = false
    public var voucherCount:Int = 0
    public var beanVoucherCount:Int = 0
    public var isNewUser:Bool = false
    public var time:CGFloat = 0
    public var voucherSum:Int = 0
    public var isFree:Bool = false
    public var freeTime:CLongLong = 1537431804
    public var isAppstoreAutoMonthly = false
    public var ok = true
    
    public required override init() {}
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
