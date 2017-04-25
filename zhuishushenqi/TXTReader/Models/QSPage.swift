//
//  QSPage.swift
//  TXTReader
//
//  Created by Nory Cao on 2017/4/14.
//  Copyright © 2017年 masterY. All rights reserved.
//

import UIKit
import ObjectMapper

class QSPage: NSObject ,NSCoding{
    var content:String? //当前页显示的文字
//    var range:NSRange? //当前页所处范围
    var curPage:Int = 0 //当前页数
    var attribute:NSDictionary = [NSFontAttributeName:UIFont.systemFont(ofSize: 20)]
    var totalPages:Int = 0
    var title:String?
    
    required init?(coder aDecoder: NSCoder) {
        self.content = aDecoder.decodeObject(forKey: "content") as? String
        self.curPage = aDecoder.decodeInteger(forKey: "curPage")
        self.attribute = aDecoder.decodeObject(forKey: "attribute") as! NSDictionary
        self.totalPages = aDecoder.decodeInteger(forKey: "totalPages")
        self.title = aDecoder.decodeObject(forKey: "title") as? String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.content, forKey: "content")
        aCoder.encode(self.curPage, forKey: "curPage")
        aCoder.encode(self.attribute, forKey: "attribute")
        aCoder.encode(self.totalPages, forKey: "totalPages")
        aCoder.encode(self.title, forKey: "title")

    }
    
    override init() {
        
    }
    
    required init?(map: Map) {
        
    }

}
