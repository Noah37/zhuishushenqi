//
//  QSBookList.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2017/4/21.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit

@objc(QSBookList)
class QSBookList: NSObject {
    
    var id:String = ""
    var title:String = ""
    var author:String = ""
    var desc:String = ""
    var bookCount:Int = 0
    var cover:String = ""
    var collectorCount:Int = 0
    
    
    class func modelCustomPropertyMapper() ->NSDictionary{
        return ["author":"author",
                "title":"title","desc":"desc","bookCount":"bookCount","collectorCount":"collectorCount","cover":"cover","id":"id"]
    }
}
