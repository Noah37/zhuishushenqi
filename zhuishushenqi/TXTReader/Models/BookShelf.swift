//
//  BookShelf.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 16/10/5.
//  Copyright © 2016年 QS. All rights reserved.
//

import UIKit

@objc(BookShelf)
class BookShelf: NSObject {
    var _id:String?
    var title:String?
    var author:String?
    var cover:String?
    var allowMonthly:Bool?
    var allowVoucher:Bool?
    var updated:String?
    var chaptersCount:NSNumber?
    var lastChapter:String?
    
    class func modelCustomPropertyMapper() ->NSDictionary{
        return ["_id":"_id","title":"title","author":"author","cover":"cover","allowMonthly":"allowMonthly","allowVoucher":"allowVoucher","updated":"updated","chaptersCount":"chaptersCount","lastChapter":"lastChapter"]
    }
}
