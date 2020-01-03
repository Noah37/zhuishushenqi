//
//  ZSSearchHotwords.swift
//  zhuishushenqi
//
//  Created by caony on 2019/10/22.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit
import HandyJSON

struct ZSSearchHotwords:HandyJSON, Equatable {
    
    var word:String = ""
    var times:Int = 0
    var isNew:Bool = false
    var soaring:Int = 0
    var frame:CGRect = CGRect.zero

    init() {
        
    }
}
