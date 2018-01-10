//
//  QSBook.swift
//  TXTReader
//
//  Created by Nory Cao on 2017/4/14.
//  Copyright © 2017年 masterY. All rights reserved.
//

import UIKit

class QSBook: NSObject,NSCoding {
    var chapters:[QSChapter]? {
        didSet{
            //do nothing
        }
    }
    var totalChapters:Int = 0
    var bookID:String = "" //bookID为在追书中的ID
    var bookName:String?
    var resources:[ResourceModel]?//书籍来源，这里面有所有的来源id
    var curRes:Int = 0 //dhqm选择来源
    //约束，这个约束是全局的，只要设置有变化，所有的书籍都随之变化
    var attribute:Attribute = Attribute(fontSize: AppStyle.shared.readFontSize, color: UIColor.black, lineSpace: 5) {
        didSet{
            if let chapterssss = self.chapters {
                self.clear(chapters: chapterssss)
            }
        }
    }
    
    func clear(chapters:[QSChapter]){
        for item in chapters {
            item.pages = []
            item.attribute = self.attribute
            item.ranges = []
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.chapters = aDecoder.decodeObject(forKey: "chapters") as? [QSChapter]
        self.totalChapters = aDecoder.decodeInteger(forKey: "totalChapters")
        self.bookID = aDecoder.decodeObject(forKey: "bookID") as? String ?? ""
        self.bookName = aDecoder.decodeObject(forKey: "bookName") as? String ?? ""
        self.resources = aDecoder.decodeObject(forKey: "resources") as? [ResourceModel]
        self.curRes = aDecoder.decodeInteger(forKey: "curRes")
        self.attribute = (aDecoder.decodeObject(forKey: "attribute") as? Attribute)!
    }
    
    override init() {
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(chapters, forKey: "chapters")
        aCoder.encode(totalChapters, forKey: "totalChapters")
        aCoder.encode(bookID, forKey: "bookID")
        aCoder.encode(bookName, forKey: "bookName")
        aCoder.encode(resources, forKey: "resources")
        aCoder.encode(curRes, forKey: "curRes")
        aCoder.encode(attribute, forKey: "attribute")
    }
    
//    private func setChapter(chapters:[QSChapter]){
//        let font:UIFont = self.attribute[NSFontAttributeName] as! UIFont
//        let attributes = getAttributes(with: 10, font: font)
//        for item in 0..<chapters.count {
//            let chapter = chapters[item]
//            chapter.attribute = attributes
//            if  chapter.content == ""{
//                continue
//            }
//            let size = CGSize(width:UIScreen.main.bounds.size.width - 40,height: UIScreen.main.bounds.size.height - 40)
//            chapter.ranges = self.pageWithAttributes(attrubutes: attributes, constrainedToSize: size, string: chapter.content) as? [String]
//        }
//    }
    
}
