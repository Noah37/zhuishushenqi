//
//  ZSChapterBody.swift
//  zhuishushenqi
//
//  Created by caony on 2018/7/3.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit
import HandyJSON

class ZSChapterBody :NSObject, HandyJSON, NSCoding {
    
    var body:String = ""
    var title:String = ""
    
    var cpContent:String = ""
    
    var images:String = ""
    var created:String = ""
    var updated:String = ""
    var id:String = ""
    
    required override init() {}
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.body, forKey: "body")
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.cpContent, forKey: "cpContent")
        aCoder.encode(self.images, forKey: "images")
        aCoder.encode(self.created, forKey: "created")
        aCoder.encode(self.updated, forKey: "updated")
        aCoder.encode(self.id, forKey: "id")

    }
    
    required init?(coder aDecoder: NSCoder) {
        self.body = aDecoder.decodeObject(forKey: "body") as? String ?? ""
        self.title = aDecoder.decodeObject(forKey: "title") as? String ?? ""
        self.cpContent = aDecoder.decodeObject(forKey: "cpContent") as? String ?? ""
        self.images = aDecoder.decodeObject(forKey: "images") as? String ?? ""
        self.created = aDecoder.decodeObject(forKey: "created") as? String ?? ""
        self.updated = aDecoder.decodeObject(forKey: "updated") as? String ?? ""
        self.id = aDecoder.decodeObject(forKey: "id") as? String ?? ""

    }
}
