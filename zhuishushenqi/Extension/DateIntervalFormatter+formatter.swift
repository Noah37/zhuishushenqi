//
//  DateIntervalFormatter+formatter.swift
//  zhuishushenqi
//
//  Created by Nory Chao on 2017/3/15.
//  Copyright © 2017年 QS. All rights reserved.
//

import Foundation

extension DateIntervalFormatter{
    func formatter(begin:Date?,end:Date?)->TimeInterval{
        if begin == nil || end == nil {
            return 0
        }
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd hh-mm-ss"
        let beginTime = begin?.timeIntervalSince1970
        let endTime = end?.timeIntervalSince1970
        if let beginTimeInterval = beginTime,let endTimeInterval = endTime{
            let minus = endTimeInterval - beginTimeInterval
            return minus
        }
        return 0
    }
    
    //Just something
    func timeInfo(from:Date,to:Date)->String{
        let year = to.year() - from.year()
        let month = to.month() - from.month()
        let day = to.day() - from.day()
        var retTime = 1.0
        let timeInterval = formatter(begin: from, end: to)
        if timeInterval < 3600.0 { //小于一小时
            retTime = timeInterval / 60.0
            retTime = retTime <= 0.0 ? 1.0 : retTime
            return String(format: "%.0f分钟前",retTime)
        }else if timeInterval < 3600*24 { //小于一天，也就是今天
            retTime = timeInterval / 3600.0
            retTime = retTime <= 0.0 ? 1.0 : retTime
            return String(format: "%.0f小时前",retTime)
        }else if abs(year) == 0 && abs(month) <= 1 || abs(year) == 1 && to.month() == 1 && from.month() == 12{
            // 第一个条件是同年，且相隔时间在一个月内
            // 第二个条件是隔年，对于隔年，只能是去年12月与今年1月这种情况
            var retDay = 0
            if year == 0 {//同年
                if month == 0 {//同月
                    retDay = day
                }
            }
            if retDay <= 0{
                // 获取发布日期中，该月有多少天
                let totalDays =  from.days(month: from.month())
                // 当前天数 + （发布日期月中的总天数-发布日期月中发布日，即等于距离今天的天数）
                retDay = to.day() + totalDays - from.day()
                
            }
            return String(format: "%d天前",abs(retDay))
        }else {
            if abs(year) <= 1 {
                if year == 0 {//同年
                    return String(format: "%d个月前",
                                  (month))
                } else {//跨年计算月份
                    return String(format: "%d个月前",12 - from.month() + to.month())
                }
            }
            if month < 0 { //未满一年不计算
                return String(format: "%d年前",abs(year) - 1)
            }
            return String(format: "%d年前",abs(year))
        }
    }
    
    
}
