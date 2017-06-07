//
//  QSChapter.swift
//  TXTReader
//
//  Created by Nory Cao on 2017/4/14.
//  Copyright © 2017年 masterY. All rights reserved.
//

import UIKit
import ObjectMapper

class QSChapter: NSObject ,NSCoding{
//=======
//class QSChapter: Mappable ,NSCoding{
//>>>>>>> 876a9ee6afa162f4fb71eff5fa02f2e0dbe52ae2
    
    var id:String = "" //章节id,用于查询章节信息，vip来源才有，此处忽略
    var link:String = "" //非vip来源没有id，只有link
    var title:String = ""// 章节标题
    var attribute:NSDictionary = [NSFontAttributeName:UIFont.systemFont(ofSize: 20)] {
        didSet{
            //设置约束，清空pages跟ranges信息
            self.pages = []
            self.ranges = []
        }
    }

    //章节主要内容,下载多章节时，内存会爆掉，所以只在获取章节显示时才去计算
    var content:String = ""
    //所有页面信息
    var pages:[QSPage]?
//        {
//        get{
//            let size = CGSize(width:UIScreen.main.bounds.size.width - 40,height: UIScreen.main.bounds.size.height - 40)
//            self.ranges = self.pageWithAttributes(attrubutes: attribute, constrainedToSize: size, string: self.content) 
//            return getPage(ranges: ranges)
//        }
//        set{
//            self.pages = newValue
//        }
//    }
    //章节划分，根据attribute划分为很多页，每页的范围只在QSBook中使用
    var ranges:[String] = []

    var curChapter:Int = 0
    
    func getPages()->[QSPage]{
        if let pages = self.pages {
            if pages.count > 0{
                return pages
            }
        }
        let size = CGSize(width:UIScreen.main.bounds.size.width - 40,height: UIScreen.main.bounds.size.height - 40)
        self.ranges = self.pageWithAttributes(attrubutes: attribute, constrainedToSize: size, string: self.content)
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
        return pages
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
        super.init()
        self.id = aDecoder.decodeObject(forKey: "id") as! String
        self.link = aDecoder.decodeObject(forKey: "link") as! String
        self.title = aDecoder.decodeObject(forKey: "title") as! String
        self.attribute = aDecoder.decodeObject(forKey: "attribute") as! NSDictionary
        self.content = aDecoder.decodeObject(forKey: "content") as! String
        self.pages = aDecoder.decodeObject(forKey: "pages") as? [QSPage]
        self.ranges = aDecoder.decodeObject(forKey: "ranges") as! [String]
        self.curChapter = aDecoder.decodeInteger(forKey: "curChapter")
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
    
    override init() {
    }
    
    required init?(map: Map) {
        
    }
    
    //去掉章节开头跟结尾的多余的空格，防止产生空白页
    func trim(str:String)->String{
        var spaceStr:String = str
        spaceStr = spaceStr.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return spaceStr
    }
    
    //耗时操作，只在显示章节时才去计算,计算完成将会缓存，在改变约束，或者换源时重置
    private func pageWithAttributes(attrubutes:NSDictionary,constrainedToSize size:CGSize,string:String)->[String]{
        var resultRange:[String] = []
        let rect = CGRect(x:0,y: 0,width: size.width,height: size.height)
        let attributedString = NSAttributedString(string:string , attributes: attrubutes as? [String : AnyObject])
        let date = NSDate()
        var rangeIndex = 0
        repeat{
            let length = min(750, attributedString.length - rangeIndex)
            let childString = attributedString.attributedSubstring(from: NSMakeRange(rangeIndex, length))
            let childFramesetter = CTFramesetterCreateWithAttributedString(childString)
            let bezierPath = UIBezierPath(rect: rect)
            let frame = CTFramesetterCreateFrame(childFramesetter, CFRangeMake(0, 0), bezierPath.cgPath, nil)
            let range = CTFrameGetVisibleStringRange(frame)
            let r:NSRange = NSMakeRange(rangeIndex, range.length)
            if r.length > 0 {
                resultRange.append(NSStringFromRange(r))
            }
            rangeIndex += r.length
            
        }while (rangeIndex < attributedString.length  && Int(attributedString.length) > 0 )
        let millionSecond = NSDate().timeIntervalSince(date as Date)
        QSLog("耗时：\(millionSecond)")
        
        return resultRange
    }
}
