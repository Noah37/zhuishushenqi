//
//  ZSDatabase.swift
//  zhuishushenqi
//
//  Created by caony on 2018/11/6.
//  Copyright © 2018 QS. All rights reserved.
//

import UIKit
import SQLite

struct ZSDatabase {

    var db:Connection!
    
    init() {
        connectDatabase()
    }
    
    // 与数据库建立连接
    mutating func connectDatabase(filePath: String = "/Documents") -> Void {
        
        let sqlFilePath = NSHomeDirectory() + filePath + "/db.sqlite3"
        
        do { // 与数据库建立连接
            db = try Connection(sqlFilePath)
            print("与数据库建立连接 成功")
        } catch {
            print("与数据库建立连接 失败：\(error)")
        }
    }
    
    //MARK: - 书架信息记录需要基本信息表,阅读记录(record)
    let TABLE_LAMP = Table("bookshelf") // 表名称
    let TABLE_LAMP_ID = Expression<Int64>("lamp_id") // 列表项及项类型
    let TABLE_LAMP_BOOKNAME = Expression<String>("bookName")
    let TABLE_LAMP_BOOKID = Expression<String>("bookId")
    let TABLE_LAMP_COVER = Expression<String>("cover")
    let TABLE_LAMP_AUTHOR = Expression<String>("author")
    let TABLE_LAMP_LAST_CHAPTER = Expression<String>("lastChapter")
    let TABLE_LAMP_LAST_UPDATE_TIME = Expression<String>("lastUpdateTime")
    let TABLE_LAMP_LAST_HAVE_UPDATE = Expression<Bool>("haveUpdate")
    let TABLE_LAMP_LAST_UPDATED = Expression<String>("updated")
    let TABLE_LAMP_LAST_CHAPTER_COUNT = Expression<Int64>("lastChapterCount")
    let TABLE_LAMP_LAST_VISIT_TIME = Expression<Float64>("lastVisitTime")
    let TABLE_LAMP_REFERENCE_SOURCE = Expression<String>("referenceSource")
    let TABLE_LAMP_TOPIC_COUNT = Expression<Int64>("topicCount")
    
    func createBookshelf() {

        do {
            try db.run(TABLE_LAMP.create(temporary: false, ifNotExists: true, withoutRowid: false, block: { (table) in
                table.column(TABLE_LAMP_ID, primaryKey: .autoincrement) // 主键自加且不为空
                table.column(TABLE_LAMP_BOOKNAME)
                table.column(TABLE_LAMP_BOOKID, unique:true)
                table.column(TABLE_LAMP_COVER)
                table.column(TABLE_LAMP_AUTHOR)
                table.column(TABLE_LAMP_LAST_CHAPTER)
                table.column(TABLE_LAMP_LAST_UPDATE_TIME)
                table.column(TABLE_LAMP_LAST_HAVE_UPDATE)
                table.column(TABLE_LAMP_LAST_UPDATED)
                table.column(TABLE_LAMP_LAST_CHAPTER_COUNT)
                table.column(TABLE_LAMP_LAST_VISIT_TIME)
                table.column(TABLE_LAMP_REFERENCE_SOURCE)
                table.column(TABLE_LAMP_TOPIC_COUNT)
            }))
            print("创建表 bookshelf 成功")
        } catch {
            print("创建表 bookshelf 失败：\(error)")
        }
    }
    
    func queryBookshelf() ->[BookDetail] {
        var books:[BookDetail] = []
        for item in (try! db.prepare(TABLE_LAMP)) {
            let book = BookDetail()
            let updateInfo = BookShelf()
            updateInfo.lastChapter = item[TABLE_LAMP_LAST_CHAPTER]
            updateInfo.updated = item[TABLE_LAMP_LAST_UPDATE_TIME]
            book.title = item[TABLE_LAMP_BOOKNAME]
            book._id = item[TABLE_LAMP_BOOKID]
            book.cover = item[TABLE_LAMP_COVER]
            book.author = item[TABLE_LAMP_AUTHOR]
            book.updated = item[TABLE_LAMP_LAST_UPDATE_TIME]
            book.isUpdated = item[TABLE_LAMP_LAST_HAVE_UPDATE]
            book.updateInfo = updateInfo
            books.append(book)
        }
        
        return books
    }
    
    func updateInfo(updateInfo:UpdateInfo) {
        let item = TABLE_LAMP.filter(TABLE_LAMP_BOOKID == (updateInfo._id ?? ""))
        
        do {
            if try db.run(item.update(TABLE_LAMP_LAST_CHAPTER <- (updateInfo.lastChapter ?? ""), TABLE_LAMP_LAST_UPDATE_TIME <- (updateInfo.updated ?? ""))) > 0 {
                print("书籍\(String(describing: updateInfo._id)) 更新成功")
            } else {
                print("书籍\(String(describing: updateInfo._id)) 更新失败")
            }
        } catch {
            print("书籍\(String(describing: updateInfo._id)) 更新失败")
        }
    }
    
    func insertBookshelf(book:BookDetail) ->Bool {
//        2016-08-22T12:05:34.501Z
        var result = false
        let timeInterval = Date().timeIntervalSince1970
        let insert = TABLE_LAMP.insert(TABLE_LAMP_BOOKNAME <- book.title,TABLE_LAMP_BOOKID <- book._id, TABLE_LAMP_COVER <- book.cover, TABLE_LAMP_AUTHOR <- book.author, TABLE_LAMP_LAST_CHAPTER <- (book.updateInfo?.lastChapter ?? ""), TABLE_LAMP_LAST_UPDATE_TIME <- (book.updateInfo?.updated ?? ""), TABLE_LAMP_LAST_HAVE_UPDATE <- book.isUpdated,TABLE_LAMP_LAST_UPDATED <- (book.updateInfo?.updated ?? ""),TABLE_LAMP_LAST_CHAPTER_COUNT <- (Int64(book.chaptersInfo?.count ?? 0)),TABLE_LAMP_LAST_VISIT_TIME <- timeInterval,TABLE_LAMP_REFERENCE_SOURCE <- book.record?.source?.name ?? "",TABLE_LAMP_TOPIC_COUNT <- 0)
        do {
            let rowID = try db.run(insert)
            print("插入数据成功:\(rowID)")
            result = true
        } catch {
            print("插入数据失败\(error)")
        }
        return result
    }

}
