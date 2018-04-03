//
//  QSChapter.swift
//  TXTReader
//
//  Created by Nory Cao on 2017/4/14.
//  Copyright © 2017年 masterY. All rights reserved.
//

import UIKit
import ObjectMapper
/*
 *  章节信息保存到NSDictionary中，key为link或者id
 *  value为QSChapter模型，不需要持久化，每次内存释放则释放
 */
/*
 {
 
 "http://book.my716.com/getBooks.aspx?method=content&bookId=191699&chapterFile=U_191699_201711081601557155_5451_1.txt":QSChapter
 }
 
 */

class QSChapter: NSObject ,NSCoding{
    
    var id:String = "" //章节id,用于查询章节信息，vip来源才有，此处忽略
    var link:String = "" //非vip来源没有id，只有link
    var title:String = ""// 章节标题

    //章节主要内容,下载多章节时，内存会爆掉，所以只在获取章节显示时才去计算
    var content:String = ""
    //所有页面信息
    var pages:[QSPage] = [QSPage()]

    //章节划分，根据attribute划分为很多页，每页的范围只在QSBook中使用
    var ranges:[NSRange] = []

    var curChapter:Int = 0
    
    func getPages()->[QSPage]{
        
        if self.ranges.count > 0 && self.ranges[0] != NSMakeRange(0, 0){
            return self.pages
        }
        if !content.isEmpty {
            let size = QSReaderFrame
            let attributes = QSReaderSetting.shared.attributes()
            self.ranges = QSReaderParse.pageWithAttributes(attrubutes: attributes, constrainedToFrame: size, string: self.content)
        }
        
        var pages:[QSPage] = []
        for item in 0..<ranges.count {
            let range:NSRange =  ranges[item]
            let page = QSPage()
            page.content = content.qs_subStr(range: range)
            page.curPage = item
            page.totalPages = ranges.count
            page.title = title
            pages.append(page)
        }
        if pages.count == 0 {
            let page = QSPage()
            pages.append(page)
        }
        self.pages = pages
        return pages
    }
    
    @objc private func clear(){
        //设置约束，清空pages跟ranges信息
        self.pages = []
        self.ranges = []
    }
    
    /// This function is where all variable mappings should occur. It is executed by Mapper during the mapping (serialization and deserialization) process.
    func mapping(map: Map) {
        id    <- map["id"]
        link         <- map["link"]
        title <- map["title"]
        content       <- map["content"]
        pages <- map["pages"]
        ranges <- map["pages"]
        curChapter <- map["curChapter"]
        
    }

    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.id = aDecoder.decodeObject(forKey: "id") as! String
        self.link = aDecoder.decodeObject(forKey: "link") as! String
        self.title = aDecoder.decodeObject(forKey: "title") as! String
        self.content = aDecoder.decodeObject(forKey: "content") as! String
        self.pages = aDecoder.decodeObject(forKey: "pages") as! [QSPage]
        self.ranges = aDecoder.decodeObject(forKey: "ranges") as! [NSRange]
        self.curChapter = aDecoder.decodeInteger(forKey: "curChapter")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.link, forKey: "link")
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.content, forKey: "content")
        aCoder.encode(self.pages, forKey: "pages")
        aCoder.encode(self.ranges, forKey: "ranges")
        aCoder.encode(self.curChapter, forKey: "curChapter")

    }
    
    override init() {
        super.init()
        NotificationCenter.qs_addObserver(observer: self, selector: #selector(clear), name: QSReaderPagesClearNotificationKey, object: nil)
    }
    
    required init?(map: Map) {
        
    }
}
