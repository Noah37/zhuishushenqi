//
//  BookShelf.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 16/10/5.
//  Copyright © 2016年 QS. All rights reserved.
//

import UIKit
import HandyJSON

@objc(BookShelf)
class BookShelf: NSObject, HandyJSON, NSCoding {
    
    var _id:String?
    var title:String?
    var author:String?
    var cover:String?
    var allowMonthly:String?
    var allowVoucher:String?
    var updated:String?
    var chaptersCount:String?
    var lastChapter:String?
    var referenceSource:String?
    var readRecord:ZSReadRecord?
    var modifyTime:String?
    var created:String?
    var contentType:String?
    var superscript:String?
    var sizetype:String?
    
    required override init() {}
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self._id, forKey: "_id")
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.author, forKey: "author")
        aCoder.encode(self.cover, forKey: "cover")
        aCoder.encode(self.allowMonthly, forKey: "allowMonthly")
        aCoder.encode(self.allowVoucher, forKey: "allowVoucher")
        aCoder.encode(self.updated, forKey: "updated")
        aCoder.encode(self.chaptersCount, forKey: "chaptersCount")
        aCoder.encode(self.lastChapter, forKey: "lastChapter")
        aCoder.encode(self.referenceSource, forKey: "referenceSource")
        aCoder.encode(self.readRecord, forKey: "readRecord")
        aCoder.encode(self.modifyTime, forKey: "modifyTime")
        aCoder.encode(self.created, forKey: "created")
        aCoder.encode(self.contentType, forKey: "contentType")
        aCoder.encode(self.superscript, forKey: "superscript")
        aCoder.encode(self.sizetype, forKey: "sizetype")

    }
    
    required init?(coder aDecoder: NSCoder) {
        self._id = aDecoder.decodeObject(forKey: "_id") as? String
        self.title = aDecoder.decodeObject(forKey: "title") as? String
        self.author = aDecoder.decodeObject(forKey: "author") as? String
        self.cover = aDecoder.decodeObject(forKey: "cover") as? String
        self.allowMonthly = aDecoder.decodeObject(forKey: "allowMonthly") as? String
        self.allowVoucher = aDecoder.decodeObject(forKey: "allowVoucher") as? String
        self.updated = aDecoder.decodeObject(forKey: "updated") as? String
        self.chaptersCount = aDecoder.decodeObject(forKey: "chaptersCount") as? String
        self.lastChapter = aDecoder.decodeObject(forKey: "lastChapter") as? String
        self.referenceSource = aDecoder.decodeObject(forKey: "referenceSource") as? String
        self.readRecord = aDecoder.decodeObject(forKey: "readRecord") as? ZSReadRecord
        self.modifyTime = aDecoder.decodeObject(forKey: "modifyTime") as? String
        self.created = aDecoder.decodeObject(forKey: "created") as? String
        self.contentType = aDecoder.decodeObject(forKey: "contentType") as? String
        self.superscript = aDecoder.decodeObject(forKey: "superscript") as? String
        self.sizetype = aDecoder.decodeObject(forKey: "sizetype") as? String

    }
}

//"_id": "5acf0f7c2eb0ad0dfb729d92",
//"author": "毒心萝卜",
//"cover": "/agent/http%3A%2F%2Fimg.1391.com%2Fapi%2Fv1%2Fbookcenter%2Fcover%2F1%2F2273645%2F2273645_5aa9d3087b88488286117e98d885c22a.jpg%2F",
//"title": "业界大忽悠",
//"buytype": 0,
//"allowMonthly": false,
//"allowVoucher": true,
//"hasCp": true,
//"referenceSource": "default",
//"updated": "2018-10-20T10:11:01.000Z",
//"chaptersCount": 266,
//"lastChapter": "第266章 挑选功法",
//"created": "2018-11-25T07:27:14.819Z",
//"_le": false,
//"contentType": "txt",
//"superscript": "",
//"sizetype": -1,
//"_mm": false,
//"readRecord": {
//    "tocId": "5acf0f7c2eb0ad0dfb729d94",
//    "tocName": "zhuishuvip",
//    "title": "第229章 广告代言",
//    "order": 228,
//    "wordIndex": 252,
//    "updated": "2018-11-28T01:46:42.585Z",
//    "book": "5acf0f7c2eb0ad0dfb729d92"
//},
//"advertRead": true,
//"_gg": false,
//"expired": 0,
//"_ss": false,
//"modifyTime": "2018-12-01T05:38:25.084Z"

