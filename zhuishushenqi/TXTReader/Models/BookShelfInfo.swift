//
//  BokShelfInfo.swift
//  zhuishushenqi
//
//  Created by Nory Chao on 2017/3/6.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit


class BookShelfInfo: NSObject {
    
    static let books = BookShelfInfo()
    private override init() {
        
    }
    
    let bookShelfInfo = "bookShelfInfo"
    //Local store BookDetail models array when you add persue update
    var bookShelf:NSArray {
        get{
//            XYCBaseModel.model(withModleClass: BookShelf.self, withJsArray: BOOKSHELF as [AnyObject]) as? [BookShelf]
            var data:NSArray? = []
            if let dict:Data = UserDefaults.standard.value(forKey: bookShelfInfo) as? Data {
                let unarchiver = NSKeyedUnarchiver.unarchiveObject(with: dict)
                data =  (unarchiver as AnyObject).object(forKey: bookShelfInfo) as? NSArray
            }
            return data ?? []
        }
        set{
            let dict = [bookShelfInfo:newValue]
            let archiverData = NSKeyedArchiver.archivedData(withRootObject: dict)
            UserDefaults.standard.set(archiverData, forKey: bookShelfInfo)
        }
    }
    
}
