//
//  ZSReadHistory.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2020/1/6.
//  Copyright © 2020 QS. All rights reserved.
//

import UIKit

class ZSReadHistory:NSObject, NSCoding {
    // 记录当前章节
    var chapter:ZSBookChapter!
    // 记录当前页码
    var page:ZSBookPage! {
        didSet {
            
        }
    }
    
    override init() {
        
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
