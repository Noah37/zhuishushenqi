//
//  BookDetail.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 16/10/4.
//  Copyright © 2016年 QS. All rights reserved.
//

import UIKit
import HandyJSON

@objc(BookDetail)
class BookDetail: NSObject,NSCoding ,HandyJSON{

    
    var _id:String = ""
    var author:String = ""
    var cover:String = ""
    var creater:String = ""
    var longIntro:String = ""
    var title:String = ""
    var cat:String = ""
    var majorCate:String = ""
    var minorCate:String = ""
    var latelyFollower:String = ""
    var retentionRatio:String = ""
    var serializeWordCount:String = ""//每天更新字数
    var wordCount:String = ""
    var updated:String = ""//更新时间
    var tags:NSArray?
    var postCount:Int = 0
    var copyright:String = ""
    var sourceIndex:Int = 1 //当前选择的源
    
    // 阅读记录,
    var record:QSRecord?
    
    // 废弃
    var chapter:Int = 0 //最后阅读的章节
    var page:Int = 0 //最后阅读的页数
    
    var resources:[ResourceModel]?
    var chapters:[NSDictionary]? // 新的代码完成后去掉
    var chaptersInfo:[ZSChapterInfo]? // 代替chapters
    var isUpdated:Bool = false //是否存在更新,如果存在更新，进入书籍后修改状态
    // book 一直存在，默认初始化，不保存任何章节
    var book:QSBook!

    //更新信息
    var updateInfo:UpdateInfo?
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self._id = aDecoder.decodeObject(forKey: "_id") as? String ?? ""
        self.author = aDecoder.decodeObject(forKey: "author") as? String ?? ""
        self.cover = aDecoder.decodeObject(forKey: "cover") as? String ?? ""
        self.creater = aDecoder.decodeObject(forKey: "creater") as? String ?? ""
        self.longIntro = aDecoder.decodeObject(forKey: "longIntro") as? String ?? ""
        self.title = aDecoder.decodeObject(forKey: "title") as? String ?? ""
        self.cat = aDecoder.decodeObject(forKey: "cat") as? String ?? ""
        self.majorCate = aDecoder.decodeObject(forKey: "majorCate") as? String ?? ""
        self.minorCate = aDecoder.decodeObject(forKey: "minorCate") as? String ?? ""
        self.latelyFollower = aDecoder.decodeObject(forKey: "latelyFollower")  as? String ?? ""
        self.retentionRatio = aDecoder.decodeObject(forKey: "retentionRatio") as? String ?? ""
        self.serializeWordCount = aDecoder.decodeObject(forKey: "serializeWordCount") as? String ?? ""
        self.wordCount = aDecoder.decodeObject(forKey: "wordCount") as? String ?? ""
        self.updated = aDecoder.decodeObject(forKey: "updated") as? String ?? ""
        self.tags = aDecoder.decodeObject(forKey: "tags") as? NSArray
        self.updateInfo = aDecoder.decodeObject(forKey: "updateInfo") as? UpdateInfo
        self.chapter = aDecoder.decodeInteger(forKey:"chapter")
        self.page = aDecoder.decodeInteger(forKey:"page")
        self.sourceIndex = aDecoder.decodeInteger(forKey:"sourceIndex")
        self.resources = aDecoder.decodeObject(forKey: "resources") as? [ResourceModel]
        self.chapters = aDecoder.decodeObject(forKey: "chapters") as? [NSDictionary]
        self.copyright = aDecoder.decodeObject(forKey: "copyright") as? String ?? ""
        self.postCount = aDecoder.decodeInteger(forKey: "postCount")
        self.isUpdated = aDecoder.decodeBool(forKey: "isUpdated")
        self.book = aDecoder.decodeObject(forKey: "book") as? QSBook
        self.record = aDecoder.decodeObject(forKey: "record") as? QSRecord
        self.chaptersInfo = aDecoder.decodeObject(forKey: "chaptersInfo") as? [ZSChapterInfo]
        setupBook()
    }
    
    private func setupBook(){
        if book == nil {
            book = QSBook()
        }
    }
    
    required override init() {
        super.init()
        setupBook()
    }
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self._id, forKey: "_id")
        aCoder.encode(self.author, forKey: "author")
        aCoder.encode(self.cover, forKey: "cover")
        aCoder.encode(self.creater, forKey: "creater")
        aCoder.encode(self.longIntro, forKey: "longIntro")
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.cat, forKey: "cat")
        aCoder.encode(self.majorCate, forKey: "majorCate")
        aCoder.encode(self.minorCate, forKey: "minorCate")
        aCoder.encode(self.latelyFollower, forKey: "latelyFollower")
        aCoder.encode(self.retentionRatio, forKey: "retentionRatio")
        aCoder.encode(self.serializeWordCount, forKey: "serializeWordCount")
        aCoder.encode(self.wordCount, forKey: "wordCount")
        aCoder.encode(self.updated, forKey: "updated")
        aCoder.encode(self.tags, forKey: "tags")
        aCoder.encode(self.updateInfo, forKey: "updateInfo")
        aCoder.encode(self.chapter, forKey: "chapter")
        aCoder.encode(self.page, forKey: "page")
        aCoder.encode(self.sourceIndex, forKey: "sourceIndex")
        aCoder.encode(self.resources, forKey: "resources")
        aCoder.encode(self.chapters, forKey: "chapters")
        aCoder.encode(self.copyright, forKey: "copyright")
        aCoder.encode(self.postCount, forKey: "postCount")
        aCoder.encode(self.isUpdated, forKey: "isUpdated")
        aCoder.encode(self.book, forKey: "book")
        aCoder.encode(self.record, forKey: "record")
        aCoder.encode(self.chaptersInfo,forKey:"chaptersInfo")
    }
}
