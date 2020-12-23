//
//  AikanParserModel.swift
//  CJReader
//
//  Created by yung on 2019/10/9.
//

import UIKit
import HandyJSON

class ZSAikanParserModel: NSObject, NSCoding, NSCopying, HandyJSON {
    
    
    var errDate:Date?
    var searchUrl:String = ""
    var name:String = ""
    var type:Int64 = 0
    var enabled:Bool = false
    var checked:Bool = false
    var searchEncoding:String = ""
    var host:String = ""
    var contentReplace:String = ""
    var contentRemove:String = ""
    var contentTagReplace:String = ""
    var content:String = ""
    var chapterUrl:String = ""
    var chapterName:String = ""
    var chapters:String = ""
    var chaptersModel:[ZSBookChapter] = []
    var detailBookIcon:String = ""
    var detailChaptersUrl:String = ""
    var bookLastChapterName:String = ""
    var bookUpdateTime:String = ""
    var bookUrl:String = ""
    var bookIcon:String = ""
    var bookDesc:String = ""
    var bookCategory:String = ""
    var bookAuthor:String = ""
    var bookName:String = ""
    var books:String = ""
    var chaptersReverse:Bool = false
    var detailBookDesc:String = ""
    
    var bookType:ZSReaderBookStyle = .online
    
    var update:Bool = false
    var latestChapterName:String = ""

    required override init() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.errDate = aDecoder.decodeObject(forKey: "errDate") as? Date
        self.searchUrl = aDecoder.decodeObject(forKey: "searchUrl") as! String
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.type = aDecoder.decodeInt64(forKey: "type")
        self.enabled = aDecoder.decodeBool(forKey: "enabled")
        self.checked = aDecoder.decodeBool(forKey: "checked")
        self.searchEncoding = aDecoder.decodeObject(forKey: "searchEncoding") as! String
        self.host = aDecoder.decodeObject(forKey: "host") as! String
        self.contentReplace = aDecoder.decodeObject(forKey: "contentReplace") as! String
        self.contentRemove = aDecoder.decodeObject(forKey: "contentRemove") as! String
        self.contentTagReplace = aDecoder.decodeObject(forKey: "contentTagReplace") as? String ?? ""
        self.content = aDecoder.decodeObject(forKey: "content") as! String
        self.chapterUrl = aDecoder.decodeObject(forKey: "chapterUrl") as! String
        self.chapterName = aDecoder.decodeObject(forKey: "chapterName") as! String
        self.chapters = aDecoder.decodeObject(forKey: "chapters") as! String
        self.detailBookIcon = aDecoder.decodeObject(forKey: "detailBookIcon") as! String
        self.detailChaptersUrl = aDecoder.decodeObject(forKey: "detailChaptersUrl") as! String
        self.bookLastChapterName = aDecoder.decodeObject(forKey: "bookLastChapterName") as! String
        self.detailBookDesc = aDecoder.decodeObject(forKey: "detailBookDesc") as! String
        self.bookUpdateTime = aDecoder.decodeObject(forKey: "bookUpdateTime") as! String
        self.bookUrl = aDecoder.decodeObject(forKey: "bookUrl") as! String
        self.bookIcon = aDecoder.decodeObject(forKey: "bookIcon") as! String
        self.bookDesc = aDecoder.decodeObject(forKey: "bookDesc") as! String
        self.bookCategory = aDecoder.decodeObject(forKey: "bookCategory") as! String
        self.bookAuthor = aDecoder.decodeObject(forKey: "bookAuthor") as! String
        self.bookName = aDecoder.decodeObject(forKey: "bookName") as! String
        self.books = aDecoder.decodeObject(forKey: "books") as! String
        self.chaptersReverse = aDecoder.decodeBool(forKey: "chaptersReverse")
        self.chaptersModel = aDecoder.decodeObject(forKey: "chaptersModel") as? [ZSBookChapter] ?? []
        self.bookType = ZSReaderBookStyle(rawValue: aDecoder.decodeInteger(forKey: "bookType")) ?? ZSReaderBookStyle.online
        self.update = aDecoder.decodeBool(forKey: "update")
        self.latestChapterName = aDecoder.decodeObject(forKey: "latestChapterName") as? String ?? ""

    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.errDate, forKey: "errDate")
        aCoder.encode(self.searchUrl, forKey: "searchUrl")
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.type, forKey: "type")
        aCoder.encode(self.enabled, forKey: "enabled")
        aCoder.encode(self.checked, forKey: "checked")
        aCoder.encode(self.searchEncoding, forKey: "searchEncoding")
        aCoder.encode(self.host, forKey: "host")
        aCoder.encode(self.contentReplace, forKey: "contentReplace")
        aCoder.encode(self.contentRemove, forKey: "contentRemove")
        aCoder.encode(self.contentTagReplace, forKey: "contentTagReplace")
        aCoder.encode(self.content, forKey: "content")
        aCoder.encode(self.chapterUrl, forKey: "chapterUrl")
        aCoder.encode(self.chapterName, forKey: "chapterName")
        aCoder.encode(self.chapters, forKey: "chapters")
        aCoder.encode(self.detailBookIcon, forKey: "detailBookIcon")
        aCoder.encode(self.detailChaptersUrl, forKey: "detailChaptersUrl")
        aCoder.encode(self.bookLastChapterName, forKey: "bookLastChapterName")
        aCoder.encode(self.bookUpdateTime, forKey: "bookUpdateTime")
        aCoder.encode(self.bookUrl, forKey: "bookUrl")
        aCoder.encode(self.bookIcon, forKey: "bookIcon")
        aCoder.encode(self.bookDesc, forKey: "bookDesc")
        aCoder.encode(self.bookCategory, forKey: "bookCategory")
        aCoder.encode(self.bookAuthor, forKey: "bookAuthor")
        aCoder.encode(self.bookName, forKey: "bookName")
        aCoder.encode(self.books, forKey: "books")
        aCoder.encode(self.chaptersReverse, forKey: "chaptersReverse")
        aCoder.encode(self.chaptersModel, forKey: "chaptersModel")
        aCoder.encode(self.detailBookDesc, forKey: "detailBookDesc")
        aCoder.encode(self.bookType.rawValue, forKey: "bookType")
        aCoder.encode(self.update, forKey: "update")
        aCoder.encode(self.latestChapterName, forKey: "latestChapterName")

    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copyModel = ZSAikanParserModel()
        copyModel.errDate = self.errDate
        copyModel.searchUrl = self.searchUrl
        copyModel.name = self.name
        copyModel.type = self.type
        copyModel.enabled = self.enabled
        copyModel.checked = self.checked
        copyModel.searchEncoding = self.searchEncoding
        copyModel.host = self.host
        copyModel.contentReplace = self.contentReplace
        copyModel.contentRemove = self.contentRemove
        copyModel.contentTagReplace = self.contentTagReplace
        copyModel.content = self.content
        copyModel.chapterUrl = self.chapterUrl
        copyModel.chapterName = self.chapterName
        copyModel.chapters = self.chapters
        copyModel.detailBookIcon = self.detailBookIcon
        copyModel.detailChaptersUrl = self.detailChaptersUrl
        copyModel.bookLastChapterName = self.bookLastChapterName
        copyModel.bookUpdateTime = self.bookUpdateTime
        copyModel.bookUrl = self.bookUrl
        copyModel.bookIcon = self.bookIcon
        copyModel.bookDesc = self.bookDesc
        copyModel.bookCategory = self.bookCategory
        copyModel.bookAuthor = self.bookAuthor
        copyModel.bookName = self.bookName
        copyModel.books = self.books
        copyModel.chaptersReverse = self.chaptersReverse
        copyModel.chaptersModel = self.chaptersModel
        copyModel.detailBookDesc = self.detailBookDesc
        copyModel.bookType = self.bookType
        copyModel.update = self.update
        copyModel.latestChapterName = self.latestChapterName
        return copyModel
    }
    
    func transformShelf() ->ZSShelfModel {
        let shelfModel = ZSShelfModel()
        shelfModel.icon = self.bookIcon.length > 0 ? self.bookIcon:self.detailBookIcon
        shelfModel.bookName = self.bookName
        shelfModel.author = self.bookAuthor
        shelfModel.bookUrl = self.bookUrl
        shelfModel.bookType = self.bookType
        shelfModel.update = self.update
        shelfModel.latestChapterName = self.latestChapterName
        return shelfModel
    }
    
    func updateShelf(shelf:ZSShelfModel) ->ZSShelfModel {
//        shelf.icon = self.bookIcon.length > 0 ? self.bookIcon:self.detailBookIcon
//        shelf.bookName = self.bookName
//        shelf.author = self.bookAuthor
//        shelf.bookUrl = self.bookUrl
//        shelf.bookType = self.bookType
        shelf.update = self.update
        shelf.latestChapterName = self.latestChapterName
        return shelf
    }
}
