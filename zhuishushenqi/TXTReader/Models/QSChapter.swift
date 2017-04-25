//
//  QSChapter.swift
//  TXTReader
//
//  Created by Nory Cao on 2017/4/14.
//  Copyright © 2017年 masterY. All rights reserved.
//

import UIKit
import ObjectMapper


class QSChapter: Mappable ,NSCoding{
    
    var id:String = "" //章节id,用于查询章节信息，vip来源才有，此处忽略
    var link:String = "" //非vip来源没有id，只有link
    var title:String = ""// 章节标题
    var attribute:NSDictionary = [NSFontAttributeName:UIFont.systemFont(ofSize: 20)] {
        didSet{
            
        }
    }

    //章节主要内容
    var content:String = "" {
        didSet{
            if let rangesTmp = ranges {
                self.setPage(ranges: rangesTmp)
            }
        }
    }
    var pages:[QSPage] = []//所有页面信息
    //章节划分，根据attribute划分为很多页，每页的范围只在QSBook中使用
    var ranges:[String]? = [] {
        didSet{
            if let rangesTmp = ranges {
                self.setPage(ranges: rangesTmp)
            }
        }
    }
    var curChapter:Int = 0
    
    private func setPage(ranges:[String]){
        var pages:[QSPage] = []
        for item in 0..<ranges.count {
            let range:NSRange =  NSRangeFromString(ranges[item])
            let page = QSPage()
            page.content = content.qs_subStr(range: range)
            page.curPage = item
            page.attribute = self.attribute
            page.totalPages = ranges.count
            page.title = title
            pages.append(page)
        }
        self.pages = pages
    }
    
    /// This function is where all variable mappings should occur. It is executed by Mapper during the mapping (serialization and deserialization) process.
    func mapping(map: Map) {
        id    <- map["id"]
        link         <- map["link"]
        title <- map["title"]
        attribute      <- map["attribute"]
        content       <- map["content"]
        pages <- map["pages"]
        ranges <- map["pages"]
        curChapter <- map["curChapter"]
        
    }

    
    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as! String
        self.link = aDecoder.decodeObject(forKey: "link") as! String
        self.title = aDecoder.decodeObject(forKey: "title") as! String
        self.attribute = aDecoder.decodeObject(forKey: "attribute") as! NSDictionary
        self.content = aDecoder.decodeObject(forKey: "content") as! String
        self.pages = aDecoder.decodeObject(forKey: "pages") as! [QSPage]
        self.ranges = aDecoder.decodeObject(forKey: "ranges") as! [String]?
        self.curChapter = aDecoder.decodeObject(forKey: "curChapter") as! Int

    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.link, forKey: "link")
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.attribute, forKey: "attribute")
        aCoder.encode(self.content, forKey: "content")
        aCoder.encode(self.pages, forKey: "pages")
        aCoder.encode(self.ranges, forKey: "ranges")
        aCoder.encode(self.curChapter, forKey: "curChapter")

    }
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    //数据持久化，存储到document目录,以章节序号 + id的md5为key
    class func updateLocalModel(localModel:QSChapter,link:String) -> Void {
        let key = "QSTXTReaderKeyAt\(localModel.curChapter)\(link)".md5()
        let jsonString = localModel.toJSON()
        let filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first?.appending("/\(key )")
        NSKeyedArchiver.archiveRootObject(jsonString, toFile: filePath!)
    }
    
    class func localModelWithKey(key:String) ->QSChapter?{
        let localKey = "QSTXTReaderKeyAt\(key)".md5()
        let filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first?.appending("/\(localKey)")
        var model:QSChapter?
        var file:[String:Any]?
        file = NSKeyedUnarchiver.unarchiveObject(withFile: filePath!) as? [String : Any]
        if file != nil {
            model = QSChapter(JSON: file!)
            QSLog(model?.content)
        }
        return model
    }
    
    //去掉章节开头跟结尾的多余的空格，防止产生空白页
    func trim(str:String)->String{
        var spaceStr:String = str
        spaceStr = spaceStr.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return spaceStr
    }
}
