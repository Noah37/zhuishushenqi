//
//  ZSBookChapter.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2020/1/5.
//  Copyright © 2020 QS. All rights reserved.
//

import UIKit

class ZSBookChapter:NSObject, NSCoding {
    
    static let defaultContent = "正在获数据，请稍候..."

    var chapterUrl:String = ""
    var chapterName:String = ""
    var chapterContent:String = "" { didSet { calPages() } }
    // 当前数组中的序号,与书籍中对应的序号可能有出入
    var chapterIndex:Int = 0
    
    // 每页的范围
    var ranges:[NSRange] = []
    
    var pages:[ZSBookPage] = []
    
    override init() {
        
    }
    
    // 不存在则不是当前chapter
    func getNextPage(page:ZSBookPage) ->ZSBookPage? {
        if (page.pageIndex + 1) < self.pages.count {
            return self.pages[page.pageIndex + 1]
        }
        return nil
    }
    
    func getLastPage(page:ZSBookPage) ->ZSBookPage? {
        if page.pageIndex - 1 >= 0 {
            return self.pages[page.pageIndex - 1]
        }
        return nil
    }
    
    func contentNil() ->Bool {
        return pages.count == 0 ||
        chapterContent.length == 0 ||
        chapterContent == ZSBookChapter.defaultContent
    }
    
    func calPages() {
        var content = chapterContent
        if content.length == 0 {
            content = ZSBookChapter.defaultContent
        }
        var size = ZSReader.share.contentFrame
        var top:CGFloat = 0
        let bottom:CGFloat = 30
        let orientation = UIApplication.shared.statusBarOrientation
        if orientation.isPortrait && IPHONEX {
            top = 30
        }
        top += 30
        size = CGRect(x: size.origin.x, y: top, width: size.width, height: UIScreen.main.bounds.height - top - bottom)
        let attributes = ZSReader.share.attributes()
        self.ranges = QSReaderParse.pageWithAttributes(attrubutes: attributes, constrainedToFrame: size, string: self.chapterContent)
        var pages:[ZSBookPage] = []
        for item in 0..<ranges.count {
            let range:NSRange =  ranges[item]
            let page = ZSBookPage()
            page.content = (chapterContent as NSString).substring(with: range)
            page.chapterIndex = chapterIndex
            page.chapterName = chapterName
            page.chapterUrl = chapterUrl
            page.pageIndex = item
            page.totalPages = ranges.count
            pages.append(page)
        }
        self.pages = pages
    }
    
    required init?(coder: NSCoder) {
        self.chapterUrl = coder.decodeObject(forKey: "chapterUrl") as? String ?? ""
        self.chapterName = coder.decodeObject(forKey: "chapterName") as? String ?? ""
        self.chapterContent = coder.decodeObject(forKey: "chapterContent") as? String ?? ""
        self.chapterIndex = coder.decodeInteger(forKey: "chapterIndex")
        self.ranges = coder.decodeObject(forKey: "ranges") as? [NSRange] ?? []
        self.pages = coder.decodeObject(forKey: "pages") as? [ZSBookPage] ?? []
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.chapterUrl, forKey: "chapterUrl")
        coder.encode(self.chapterName, forKey: "chapterName")
        coder.encode(self.chapterContent, forKey: "chapterContent")
        coder.encode(self.chapterIndex, forKey: "chapterIndex")
        coder.encode(self.ranges, forKey: "ranges")
        coder.encode(self.pages, forKey: "pages")
    }
}

class ZSBookPage:NSObject, NSCoding {
    
    var content:String = ""
    var chapterName:String = ""
    var chapterUrl:String = ""
    var chapterIndex:Int = 0
    var pageIndex:Int = 0
    var totalPages:Int = 0
    
    override init() {
        
    }
    
    required init?(coder: NSCoder) {
        self.chapterUrl = coder.decodeObject(forKey: "chapterUrl") as? String ?? ""
        self.chapterName = coder.decodeObject(forKey: "chapterName") as? String ?? ""
        self.content = coder.decodeObject(forKey: "content") as? String ?? ""
        self.chapterIndex = coder.decodeInteger(forKey: "chapterIndex")
        self.pageIndex = coder.decodeInteger(forKey: "pageIndex")
        self.totalPages = coder.decodeInteger(forKey: "totalPages")
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.chapterUrl, forKey: "chapterUrl")
        coder.encode(self.chapterName, forKey: "chapterName")
        coder.encode(self.content, forKey: "content")
        coder.encode(self.chapterIndex, forKey: "chapterIndex")
        coder.encode(self.pageIndex, forKey: "pageIndex")
        coder.encode(self.totalPages, forKey: "totalPages")

    }
}
