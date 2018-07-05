//
//  ZSChapterInfo.swift
//  zhuishushenqi
//
//  Created by caony on 2018/7/3.
//  Copyright © 2018年 QS. All rights reserved.
//

import Foundation
import HandyJSON

class ZSChapterInfo:HandyJSON,NSCoding {
    
    var chapterCover:String = ""
    var currency:Int = 0
    var isVip:Int = 0
    var link:String = ""
    var order:Int = 0
    var partsize:Int = 0
    var title:String = ""
    var totalpage:Int = 0
    var unreadble:Int = 0
    
    required init() {}
    
    required init?(coder aDecoder: NSCoder) {
        aDecoder.decodeObject(forKey: "chapterCover")
        aDecoder.decodeInteger(forKey: "currency")
        aDecoder.decodeInteger(forKey: "isVip")
        aDecoder.decodeObject(forKey: "link")
        aDecoder.decodeInteger(forKey: "order")
        aDecoder.decodeInteger(forKey: "partsize")
        aDecoder.decodeObject(forKey: "title")
        aDecoder.decodeInteger(forKey: "totalpage")
        aDecoder.decodeInteger(forKey: "unreadble")

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
