//
//  ZSUserBookshelf.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2018/10/21.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit
import HandyJSON

class ZSUserBookshelf: NSObject, HandyJSON {
    
    var id:String = ""
    var updated:String = ""
    var recordUpdated:String = ""
    var modifyTime:String = ""
    var type = 0
    
    required override init() {}

}

//{
//    "id": "583281b48aa389077cec86c3",
//    "updated": "2017-02-28T05:39:36.707Z",
//    "recordUpdated": "2018-09-10T02:24:33.886Z",
//    "modifyTime": "2018-09-10T12:51:05.652Z",
//    "type": 0
//}
