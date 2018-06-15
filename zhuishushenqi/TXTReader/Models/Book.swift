//
//  Book.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 16/10/4.
//  Copyright © 2016年 QS. All rights reserved.
//

import UIKit
import HandyJSON

@objc(Book)
class Book: NSObject,HandyJSON {

    var author:String?
    var title:String?
    var cat:String?
    var majorCate:String = ""
    var shortIntro:String?
    var retentionRatio:CGFloat = 0
    var latelyFollower:CGFloat = 0
    var cover:String?
    var _id:String?
    
    required override init() {
        
    }
}
