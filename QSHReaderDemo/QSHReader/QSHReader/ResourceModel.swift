//
//  Resource.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/3/6.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit

enum ResourceType {
    case vip //vip源，需登录购买
    case free//免费源，有多个
}

//某一章的源
@objc(ResourceModel)
class ResourceModel: NSObject,NSCoding {
    
//    {"_id": "570769fe326011945ee8612d",
//    "lastChapter": "第1154章 内心的喜悦",
//    "link": "http://book.my716.com/getBooks.aspx?method=chapterList&bookId=634203",
//    "source": "my176",
//    "name": "176小说",
//    "isCharge": false,
//    "chaptersCount": 1151,
//    "updated": "2017-03-06T01:10:48.432Z",
//    "starting": false,
//    "host": "book.my716.com"}
    
    //来源类型
    var sourceType:ResourceType = .free
    
    var _id:String = "" //当前源的id
    var lastChapter = ""
    var link = ""
    var source = "" {
        didSet{
            if source.contains("zhuishuvip") {
                sourceType = .vip
            }
        }
    }
    var name = ""
    var isCharge = false
    var chaptersCount = 0
    var updated = ""
    var starting = false
    var host = ""
    
    required init?(coder aDecoder: NSCoder) {
//        self.sourceType = aDecoder.decodeObject(forKey: "sourceType") as? ResourceType ?? .free
        self._id = aDecoder.decodeObject(forKey: "id") as? String ?? ""
        self.lastChapter = aDecoder.decodeObject(forKey: "lastChapter") as? String ?? ""
        self.link = aDecoder.decodeObject(forKey: "link") as? String ?? ""
        self.source = aDecoder.decodeObject(forKey: "source") as? String ?? ""
        self.name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        self.isCharge = aDecoder.decodeBool(forKey: "isCharge")
        self.chaptersCount = aDecoder.decodeInteger(forKey: "chaptersCount") 
        self.updated = aDecoder.decodeObject(forKey: "updated") as? String ?? ""
        self.starting = aDecoder.decodeBool(forKey: "starting")
        self.host = aDecoder.decodeObject(forKey: "host") as? String ?? ""
    }
    
    func encode(with aCoder: NSCoder) {
//        aCoder.encode(self.sourceType, forKey: "sourceType")
        aCoder.encode(self._id, forKey: "id")
        aCoder.encode(self.lastChapter, forKey: "lastChapter")
        aCoder.encode(self.link, forKey: "link")
        aCoder.encode(self.source, forKey: "source")
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.isCharge, forKey: "isCharge")
        aCoder.encode(self.chaptersCount, forKey: "chaptersCount")
        aCoder.encode(self.updated, forKey: "updated")
        aCoder.encode(self.starting, forKey: "starting")
        aCoder.encode(self.host, forKey: "host")

    }
    
    override init(){
        
    }

    class func modelCustomPropertyMapper() ->NSDictionary{
        return ["_id":"_id",
                "lastChapter":"lastChapter",
                "link":"link",
                "source":"source",
                "name":"name",
                "isCharge":"isCharge",
                "chaptersCount":"chaptersCount",
                "updated":"updated",
                "starting":"starting",
                "host":"host"]
    }
}
