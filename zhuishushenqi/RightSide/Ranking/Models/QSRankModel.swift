//
//  QSRankModel.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/3/7.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit
import HandyJSON

@objc(QSRankModel)
class QSRankModel: NSObject,HandyJSON {

    var totalRank:String = "" {
        didSet {

        }
    }
    var _id:String = ""
    var title:String = ""
    var collapse:Int = 0
    var cover:String = ""
    var monthRank:String = ""
    var image:String = ""
    
    required override init() {
        super.init()
    }
}
