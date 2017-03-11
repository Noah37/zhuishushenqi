//
//  ThemeTopicModel.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2017/3/9.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit

@objc(ThemeTopicModel)
class ThemeTopicModel: NSObject {

    var _id:String = ""
    var title:String = ""
    var author:String = ""
    var desc:String = ""
    var gender:String = ""
    var collectorCount:Int = 0
    var cover:String = ""
    var bookCount:Int = 0
    
    class func modelCustomPropertyMapper() ->NSDictionary{
        return ["_id":"_id","title":"title","author":"author","desc":"desc","gender":"gender","collectorCount":"collectorCount","cover":"cover","bookCount":"bookCount"]
    }

}
