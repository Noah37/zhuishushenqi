//
//  ZSChapterSelectModel.swift
//  zhuishushenqi
//
//  Created by caony on 2018/11/13.
//  Copyright © 2018 QS. All rights reserved.
//
//{
//    "levels": [
//    {
//    "num": 10,
//    "discount": 0.9
//    },
//    {
//    "num": 40,
//    "discount": 0.85
//    },
//    {
//    "num": 100,
//    "discount": 0.75
//    }
//    ],
//    "allowInputChapterNum": true,
//    "allowShowOtherSource": false,
//    "ok": true
//}

import UIKit
import HandyJSON

@objc(ZSChapterSelectItemModel)
class ZSChapterSelectItemModel: NSObject, HandyJSON {
    var num:Int = 0
    var discount:CGFloat = 1.0
    required override init() {}
}

@objc(ZSChapterSelectModel)
class ZSChapterSelectModel: NSObject, HandyJSON {

    var levels:[ZSChapterSelectItemModel] = []
    var allowInputChapterNum:Bool = true
    var allowShowOtherSource:Bool = false
    var ok:Bool = false
    
    required override init() {}
}
