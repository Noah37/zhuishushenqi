//
//  ZSVoucher.swift
//  zhuishushenqi
//
//  Created by caony on 2019/1/9.
//  Copyright © 2019年 QS. All rights reserved.
//

import Foundation
import HandyJSON

class ZSVoucher: NSObject, HandyJSON {
    var _id = 0
    var accountId = "57ac9879c12b61e826bd7221"
    var amount = 21
    var balance = 21
    var created = "2018-12-31T18:35:39.000Z"
    var expired = "2019-02-15T15:59:59.000Z"
    var from = "连续6签到奖励"
    var voucherType = 6
    var extra_1 = 0
    var extra_2 = ""
    
    required override init() {}
}
