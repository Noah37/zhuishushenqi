//
//  ZSReadHistory.swift
//  zhuishushenqi
//
//  Created by yung on 2020/1/6.
//  Copyright © 2020 QS. All rights reserved.
//

import UIKit
import HandyJSON

class ZSReadHistory:NSObject, NSCoding, HandyJSON {
    // 记录当前章节
    var chapter:ZSBookChapter!
    // 记录当前页码
    var page:ZSBookPage! {
        didSet {
            
        }
    }
    
    required override init() {
        
    }
    
    required init?(coder: NSCoder) {
        self.chapter = coder.decodeObject(forKey: "chapter") as? ZSBookChapter
        self.page = coder.decodeObject(forKey: "page") as? ZSBookPage
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.chapter, forKey: "chapter")
        coder.encode(self.page, forKey: "page")
    }
}
