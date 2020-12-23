//
//  QSBookList.swift
//  zhuishushenqi
//
//  Created by yung on 2017/4/21.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit
import HandyJSON

@objc(QSBookList)
class QSBookList: NSObject ,HandyJSON{
    
    var id:String = ""
    var title:String = ""
    var author:String = ""
    var desc:String = ""
    var bookCount:Int = 0
    var cover:String = ""
    var collectorCount:Int = 0
    
    required override init() {
        
    }
}
