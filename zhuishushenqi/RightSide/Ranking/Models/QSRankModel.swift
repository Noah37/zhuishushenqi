//
//  QSRankModel.swift
//  zhuishushenqi
//
//  Created by Nory Chao on 2017/3/7.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit

@objc(QSRankModel)
class QSRankModel: NSObject {

    var totalRank:String = ""
    var _id:String = ""
    var title:String = ""
    var collapse:Int = 0
    var cover:String = ""
    var monthRank:String = ""
    var image:String = ""
    
    class func modelCustomPropertyMapper() ->NSDictionary{
        return ["totalRank":"totalRank","_id":"_id","title":"title","collapse":"collapse","cover":"cover","monthRank":"monthRank"]
    }

}
