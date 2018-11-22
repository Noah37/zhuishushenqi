//
//  ZSReadRecord.swift
//  zhuishushenqi
//
//  Created by caony on 2018/11/20.
//  Copyright © 2018 QS. All rights reserved.
//

import UIKit
import HandyJSON

class ZSReadRecord: NSObject, HandyJSON {
    var tocId:String?
    var tocName:String?
    var title:String?
    var order:Int?
    var wordIndex:Int?
    var updated:String?
    var book:String?
    
    required override init() {}
}
