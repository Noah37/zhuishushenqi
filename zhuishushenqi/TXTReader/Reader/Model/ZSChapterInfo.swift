//
//  ZSChapterInfo.swift
//  zhuishushenqi
//
//  Created by caony on 2018/7/3.
//  Copyright © 2018年 QS. All rights reserved.
//

import Foundation
import HandyJSON

class ZSChapterInfo:NSObject,HandyJSON,NSCoding {
    
    var chapterCover:String = ""
    var currency:Int = 0
    var isVip:Int = 0
    var link:String = ""
    var order:Int = 0
    var partsize:Int = 0
    var title:String = ""
    var totalpage:Int = 0
    var unreadble:Int = 0
    
    required override init() {}
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.chapterCover = aDecoder.decodeObject(forKey: "chapterCover") as? String ?? ""
        self.currency = aDecoder.decodeInteger(forKey: "currency")
        self.isVip = aDecoder.decodeInteger(forKey: "isVip")
        self.link = aDecoder.decodeObject(forKey: "link") as? String ?? ""
        self.order = aDecoder.decodeInteger(forKey: "order")
        self.partsize = aDecoder.decodeInteger(forKey: "partsize")
        self.title = aDecoder.decodeObject(forKey: "title") as? String ?? ""
        self.totalpage = aDecoder.decodeInteger(forKey: "totalpage")
        self.unreadble = aDecoder.decodeInteger(forKey: "unreadble")

    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.chapterCover, forKey: "chapterCover")
        aCoder.encode(self.currency, forKey: "currency")
        aCoder.encode(self.isVip, forKey: "isVip")
        aCoder.encode(self.link, forKey: "link")
        aCoder.encode(self.order, forKey: "order")
        aCoder.encode(self.partsize, forKey: "partsize")
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.totalpage, forKey: "totalpage")
        aCoder.encode(self.unreadble, forKey: "unreadble")

    }
    
}
