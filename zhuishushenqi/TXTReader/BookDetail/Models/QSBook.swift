//
//  QSBook.swift
//  TXTReader
//
//  Created by Nory Cao on 2017/4/14.
//  Copyright © 2017年 masterY. All rights reserved.
//

import UIKit
import ObjectMapper

/*
    暂时不需要这个类，考虑废弃掉
 */

class QSBook: NSObject,NSCoding {
    // 只在内存中使用，释放后不保存
    
    var localChapters:[QSChapter] = []
    var chapters:[QSChapter] = []
    
    var totalChapters:Int = 1
    var bookID:String = "" //bookID为在追书中的ID
    var bookName:String = ""
    var resources:[ResourceModel]?//书籍来源，这里面有所有的来源id
    var curRes:Int = 0 //dhqm选择来源
    
    required init?(coder aDecoder: NSCoder) {
        self.localChapters = aDecoder.decodeObject(forKey: "localChapters") as? [QSChapter] ?? []
        self.chapters = aDecoder.decodeObject(forKey: "chapters") as! [QSChapter]
        self.totalChapters = aDecoder.decodeInteger(forKey: "totalChapters")
        self.bookID = aDecoder.decodeObject(forKey: "bookID") as? String ?? ""
        self.bookName = aDecoder.decodeObject(forKey: "bookName") as? String ?? ""
        self.resources = aDecoder.decodeObject(forKey: "resources") as? [ResourceModel]
        self.curRes = aDecoder.decodeInteger(forKey: "curRes")
    }
    
    override init() {
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(localChapters, forKey: "localChapters")
        aCoder.encode(chapters, forKey: "chapters")
        aCoder.encode(totalChapters, forKey: "totalChapters")
        aCoder.encode(bookID, forKey: "bookID")
        aCoder.encode(bookName, forKey: "bookName")
        aCoder.encode(resources, forKey: "resources")
        aCoder.encode(curRes, forKey: "curRes")
    }
}
