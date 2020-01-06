//
//  ZSBookChapter.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2020/1/5.
//  Copyright © 2020 QS. All rights reserved.
//

import UIKit

class ZSBookChapter:NSObject, NSCoding {

    var chapterUrl:String = ""
    var chapterName:String = ""
    var chapterContent:String = "" { didSet { calPages() } }
    // 当前数组中的序号,与书籍中对应的序号可能有出入
    var chapterIndex:Int = 0
    
    // 每页的范围
    var ranges:[NSRange] = []
    
    var reader = ZSReader()
    
    override init() {
        
    }
    
    private func calPages() {
        if chapterContent.length == 0 {
            return
        }
        reader.didChangeContentFrame = { frame in
            
        }
        reader.didChangeTheme = { theme in
            
        }
        let size = reader.contentFrame
        let attributes = QSReaderSetting.shared.attributes()
        self.ranges = QSReaderParse.pageWithAttributes(attrubutes: attributes, constrainedToFrame: size, string: self.chapterContent)
    }
    
    required init?(coder: NSCoder) {
        self.chapterUrl = coder.decodeObject(forKey: "chapterUrl") as? String ?? ""
        self.chapterName = coder.decodeObject(forKey: "chapterName") as? String ?? ""
        self.chapterContent = coder.decodeObject(forKey: "chapterContent") as? String ?? ""
        self.chapterIndex = coder.decodeInteger(forKey: "chapterIndex")
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.chapterUrl, forKey: "chapterUrl")
        coder.encode(self.chapterName, forKey: "chapterName")
        coder.encode(self.chapterContent, forKey: "chapterContent")
        coder.encode(self.chapterIndex, forKey: "chapterIndex")
    }
}

class ZSBookPage:NSObject, NSCoding {
    
    var content:String = ""
    var chapterName:String = ""
    var chapterUrl:String = ""
    var chapterIndex:Int = 0
    var pageIndex:Int = 0
    
    override init() {
        
    }
    
    required init?(coder: NSCoder) {
        self.chapterUrl = coder.decodeObject(forKey: "chapterUrl") as? String ?? ""
        self.chapterName = coder.decodeObject(forKey: "chapterName") as? String ?? ""
        self.content = coder.decodeObject(forKey: "content") as? String ?? ""
        self.chapterIndex = coder.decodeInteger(forKey: "chapterIndex")
        self.pageIndex = coder.decodeInteger(forKey: "pageIndex")
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.chapterUrl, forKey: "chapterUrl")
        coder.encode(self.chapterName, forKey: "chapterName")
        coder.encode(self.content, forKey: "content")
        coder.encode(self.chapterIndex, forKey: "chapterIndex")
        coder.encode(self.pageIndex, forKey: "pageIndex")
    }
}
