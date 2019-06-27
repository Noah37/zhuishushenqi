//
//  ZSVoucher.swift
//  zhuishushenqi
//
//  Created by caony on 2019/1/9.
//  Copyright © 2019年 QS. All rights reserved.
//

import Foundation
import HandyJSON

public class ZSVoucher: NSObject, HandyJSON {
    public var _id = 0
    public var accountId = "57ac9879c12b61e826bd7221"
    public var amount = 21
    public var balance = 21
    public var created = "2018-12-31T18:35:39.000Z"
    public var expired = "2019-02-15T15:59:59.000Z"
    public var from = "连续6签到奖励"
    public var voucherType = 6
    public var extra_1 = 0
    public var extra_2 = ""
    
    public required override init() {}
}
