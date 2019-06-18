//
//  Date+Extension.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/3/15.
//  Copyright © 2017年 QS. All rights reserved.
//

import Foundation

extension Date{
    public func year()->Int{
        let calendar = Calendar.current
        var dayComponents:DateComponents?
        if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0 {
            dayComponents = calendar.dateComponents([.year], from: self)
        }
        return dayComponents?.year ?? 0
    }
    
    public func month()->Int {
        let calendar = Calendar.current
        var dayComponents:DateComponents?
        if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0 {
            dayComponents = calendar.dateComponents([.month], from: self)
        }
        return dayComponents?.month ?? 0
    }
    
    public func day()->Int {
        let calendar = Calendar.current
        var dayComponents:DateComponents?
        if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0 {
            dayComponents = calendar.dateComponents([.day], from: self)
        }
        return dayComponents?.day ?? 0
    }
    
    public func hour()->Int {
        let calendar = Calendar.current
        var dayComponents:DateComponents?
        if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0 {
            dayComponents = calendar.dateComponents([.hour], from: self)
        }
        return dayComponents?.hour ?? 0
    }
    
    public func minute()->Int {
        let calendar = Calendar.current
        var dayComponents:DateComponents?
        if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0 {
            dayComponents = calendar.dateComponents([.minute], from: self)
        }
        return dayComponents?.minute ?? 0
    }
    
    public func second()->Int {
        let calendar = Calendar.current
        var dayComponents:DateComponents?
        if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0 {
            dayComponents = calendar.dateComponents([.second], from: self)
        }
        return dayComponents?.second ?? 0
    }
    
    public func days(month:Int)->Int{
        var days = 0
        switch month {
            case 1,3,5,7,8,10,12:
                days = 31
                break
            case 2:
                days =  isLeapYear() ? 29:28
                break
            case 4,6,9,11:
                days = 30
                break
            default: break
        }
        return days
    }
    
    public func isLeapYear()->Bool{
        let year = self.year()
        if (year % 4 == 0 && year % 100 != 0) || year % 400 == 0 {
            return true
        }
        return false
    }
    
    public static func timeInterval(from formDate:Date?,to toDate:Date?)->TimeInterval{
        if formDate == nil || toDate == nil {
            return 0
        }
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd hh-mm-ss"
        let beginTime = formDate?.timeIntervalSince1970
        let endTime = toDate?.timeIntervalSince1970
        let resultTime = endTime! - beginTime!
        return resultTime
    }

    
//    + (NSUInteger)daysInMonth:(NSDate *)date month:(NSUInteger)month {
//    switch (month) {
//    case 1: case 3: case 5: case 7: case 8: case 10: case 12:
//    return 31;
//    case 2:
//    return [date isLeapYear] ? 29 : 28;
//    }
//    return 30;
//    }
}
