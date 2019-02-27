//
//  ZSReadRecord.swift
//  zhuishushenqi
//
//  Created by caony on 2018/11/20.
//  Copyright © 2018 QS. All rights reserved.
//

import UIKit
import HandyJSON

class ZSReadRecord: NSObject, HandyJSON, NSCoding {
    var tocId:String?
    var tocName:String?
    var title:String?
    var order:Int64?
    var wordIndex:Int64?
    var updated:String?
    var book:String?
    
    required override init() {}
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.tocId, forKey: "tocId")
        aCoder.encode(self.tocName, forKey: "tocName")
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.order, forKey: "order")
        aCoder.encode(self.wordIndex, forKey: "wordIndex")
        aCoder.encode(self.updated, forKey: "updated")
        aCoder.encode(self.book, forKey: "book")

    }
    
    required init?(coder aDecoder: NSCoder) {
        self.tocId = aDecoder.decodeObject(forKey: "tocId") as? String
        self.tocName = aDecoder.decodeObject(forKey: "tocName") as? String
        self.title = aDecoder.decodeObject(forKey: "title") as? String
        self.order = aDecoder.decodeInt64(forKey: "order")
        self.wordIndex = aDecoder.decodeInt64(forKey: "wordIndex")
        self.updated = aDecoder.decodeObject(forKey: "updated") as? String
        self.book = aDecoder.decodeObject(forKey: "book") as? String
    }
}
