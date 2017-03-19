//
//  UpdateInfo.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2017/3/6.
//  Copyright © 2017年 XYC. All rights reserved.
//

import UIKit

@objc(UpdateInfo)
class UpdateInfo: NSObject {
//    [{
//    "_id": "51d11e782de6405c45000068",
//    "author": "天蚕土豆",
//    "referenceSource": "sogou",
//    "updated": "2017-03-04T11:34:43.143Z",
//    "chaptersCount": 1456,
//    "lastChapter": "第1495章 镇压"
//    }]
    var _id:String?
    var author:String?
    var referenceSource:String?
    var updated:String?
    var chaptersCount:Int?
    var lastChapter:String?

    class func modelCustomPropertyMapper() ->NSDictionary{
        return ["_id":"_id","author":"author","referenceSource":"referenceSource","updated":"updated","chaptersCount":"chaptersCount","lastChapter":"lastChapter"]
    }
}
