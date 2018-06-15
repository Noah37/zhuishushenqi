//
//  ThemeTopicModel.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/3/9.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit
import HandyJSON

@objc(ThemeTopicModel)
class ThemeTopicModel: NSObject,HandyJSON {

    var _id:String = ""
    var title:String = ""
    var author:String = ""
    var desc:String = ""
    var gender:String = ""
    var collectorCount:Int = 0
    var cover:String = ""
    var bookCount:Int = 0
    
    required override init() {
        
    }

}
