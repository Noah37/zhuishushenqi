//
//  PageInfo.swift
//  TXTReader
//
//  Created by Nory Cao on 16/11/24.
//  Copyright © 2016年 QS. All rights reserved.
//

import UIKit

class PageInfo: NSObject,NSCoding {
    //章节信息
    var chapterInfo:ChapterInfo?
    //当前页
    var pageIndex:Int? = 0
    //总页数
    var total:Int? = 1
    
    init(_ chapterInfo:ChapterInfo,pageIndex:Int,total:Int) {
        super.init()
        self.chapterInfo = chapterInfo
        self.pageIndex = pageIndex
        self.total  = total
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.chapterInfo, forKey: "chapterInfo")
        aCoder.encode(self.pageIndex, forKey: "pageIndex")
        aCoder.encode(self.total, forKey: "total")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.chapterInfo = aDecoder.decodeObject(forKey: "chapterInfo") as? ChapterInfo
        self.pageIndex = aDecoder.decodeObject(forKey: "pageIndex") as? Int
        self.total = aDecoder.decodeObject(forKey: "total") as? Int

    }
}
