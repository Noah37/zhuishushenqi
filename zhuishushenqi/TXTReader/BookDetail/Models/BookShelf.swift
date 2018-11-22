//
//  BookShelf.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 16/10/5.
//  Copyright © 2016年 QS. All rights reserved.
//

import UIKit
import HandyJSON

@objc(BookShelf)
class BookShelf: NSObject, HandyJSON {
    var _id:String?
    var title:String?
    var author:String?
    var cover:String?
    var allowMonthly:Bool?
    var allowVoucher:Bool?
    var updated:String?
    var chaptersCount:Int?
    var lastChapter:String?
    var referenceSource:String?
    var readRecord:ZSReadRecord?
    var modifyTime:String?
    
    required override init() {}
}

