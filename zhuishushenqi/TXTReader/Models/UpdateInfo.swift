//
//  UpdateInfo.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/3/6.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit
import HandyJSON

@objcMembers
class UpdateInfo: NSObject,NSCoding ,HandyJSON{
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
    
    required override init() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        self._id = aDecoder.decodeObject(forKey: "id") as? String ?? ""
        self.author = aDecoder.decodeObject(forKey: "author") as? String ?? ""
        self.referenceSource = aDecoder.decodeObject(forKey: "referenceSource") as? String ?? ""
        self.updated = aDecoder.decodeObject(forKey: "updated") as? String ?? ""
        self.chaptersCount = aDecoder.decodeObject(forKey: "chaptersCount") as? Int ?? 0
        self.lastChapter = aDecoder.decodeObject(forKey: "lastChapter") as? String ?? ""

    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self._id, forKey: "id")
        aCoder.encode(self.author, forKey: "author")
        aCoder.encode(self.referenceSource, forKey: "referenceSource")
        aCoder.encode(self.updated, forKey: "updated")
        aCoder.encode(self.chaptersCount, forKey: "chaptersCount")
        aCoder.encode(self.lastChapter, forKey: "lastChapter")
        
    }
}
