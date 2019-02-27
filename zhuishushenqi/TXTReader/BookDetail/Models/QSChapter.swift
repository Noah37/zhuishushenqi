//
//  QSChapter.swift
//  TXTReader
//
//  Created by Nory Cao on 2017/4/14.
//  Copyright © 2017年 masterY. All rights reserved.
//

import UIKit
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

    var isVip:Bool = false
    // 是否已经解密
    var isDecrypted:Bool = false
    //章节主要内容,下载多章节时，内存会爆掉，所以只在获取章节显示时才去计算
    var content:String = ""
    
    var order:Int = 0
    var currency:Int = 0
    // vip章节
    var cpContent:String = ""
    //所有页面信息
    var pages:[QSPage] = []

    //章节划分，根据attribute划分为很多页，每页的范围只在QSBook中使用
    var ranges:[NSRange] = []

    var curChapter:Int = 0
    
    @discardableResult
    func getPages()->[QSPage]{
        
        if self.ranges.count > 0 && self.ranges[0] != NSMakeRange(0, 0){
            return self.pages
        }
        var isZSSQSource:Bool = false
        if !isDecrypted && isVip {
            let page = QSPage()
            page.isDecrypted = isDecrypted
            page.isVip = isVip
            page.curChapter = curChapter
            page.title = title
            page.totalPages = 1
            page.curPage = 0
            self.pages = [page]
            return [page]
        }
        
        if id == "" {
            if !content.isEmpty {
                let size = QSReaderFrame
                let attributes = QSReaderSetting.shared.attributes()
                self.ranges = QSReaderParse.pageWithAttributes(attrubutes: attributes, constrainedToFrame: size, string: self.content)
            }
        } else {
            isZSSQSource = true
            let size = QSReaderFrame
            let attributes = QSReaderSetting.shared.attributes()
            self.ranges = QSReaderParse.pageWithAttributes(attrubutes: attributes, constrainedToFrame: size, string: self.cpContent)
        }
        
        var pages:[QSPage] = []
        for item in 0..<ranges.count {
            let range:NSRange =  ranges[item]
            let page = QSPage()
            if isZSSQSource {
                page.content = (cpContent as NSString).substring(with: range)
            } else {
                page.content = (content as NSString).substring(with: range)
            }
            page.curPage = item
            page.curChapter = curChapter
            page.totalPages = ranges.count
            page.title = title
            page.isVip = isVip
            page.isDecrypted = isDecrypted
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
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.id = aDecoder.decodeObject(forKey: "id") as! String
        self.link = aDecoder.decodeObject(forKey: "link") as! String
        self.title = aDecoder.decodeObject(forKey: "title") as! String
        self.content = aDecoder.decodeObject(forKey: "content") as! String
        self.pages = aDecoder.decodeObject(forKey: "pages") as! [QSPage]
        self.ranges = aDecoder.decodeObject(forKey: "ranges") as! [NSRange]
        self.curChapter = aDecoder.decodeInteger(forKey: "curChapter")
        self.isDecrypted = aDecoder.decodeBool(forKey: "isDecrypted")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.link, forKey: "link")
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.content, forKey: "content")
        aCoder.encode(self.pages, forKey: "pages")
        aCoder.encode(self.ranges, forKey: "ranges")
        aCoder.encode(self.curChapter, forKey: "curChapter")
        aCoder.encode(self.isDecrypted, forKey: "isDecrypted")
    }
    
    override init() {
        super.init()
        NotificationCenter.qs_addObserver(observer: self, selector: #selector(clear), name: QSReaderPagesClearNotificationKey, object: nil)
    }
}
