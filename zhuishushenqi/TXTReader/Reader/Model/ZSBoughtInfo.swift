//
//  ZSBoughtInfo.swift
//  zhuishushenqi
//
//  Created by caony on 2018/11/15.
//  Copyright © 2018 QS. All rights reserved.
//

import UIKit
import HandyJSON

class ZSBoughtItem: NSObject, HandyJSON {
    var order:Int = 0
    var key:String = ""
    
    required override init(){}
}

class ZSBoughtInfo: NSObject, HandyJSON {
    var keys:[ZSBoughtItem] = []
    var ok = false
    required override init(){}

}
