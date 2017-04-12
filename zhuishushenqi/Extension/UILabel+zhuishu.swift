//
//  UILabel+zhuishu.swift
//  zhuishushenqi
//
//  Created by Nory Chao on 2017/3/16.
//  Copyright © 2017年 QS. All rights reserved.
//

import Foundation
import UIKit

extension UILabel{
    func qs_setCreateTime(createTime:String,append:String){
        if createTime.lengthOfBytes(using: String.Encoding.utf8) > 18{
            let year = createTime.qs_subStr(to: 4)
            let month = createTime.qs_subStr(start: 5, end: 7)
            let day = createTime.qs_subStr(start: 8, length: 2)
            let hour = createTime.qs_subStr(start: 11, length: 2)
            let mimute = createTime.qs_subStr(start: 14, length: 2)
            let second = createTime.qs_subStr(start: 17, length: 2)
            let beginDate = NSDate.getWithYear(year, month: month, day: day, hour: hour, mimute: mimute, second: second)
            let endDate = Date()
            let formatter = DateIntervalFormatter()
            let out = formatter.timeInfo(from: beginDate!, to: endDate)
            self.text = "\(out)\(append)"
        }
    }
}
