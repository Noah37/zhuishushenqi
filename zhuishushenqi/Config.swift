//
//  Config.swift
//  zhuishushenqi
//
//  Created by caonongyun on 16/9/17.
//  Copyright © 2016年 CNY. All rights reserved.
//

import Foundation
import UIKit

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}
//MARK:- API
let baseUrl = "http://api.zhuishushenqi.com"
let picBaseUrl = "http://statics.zhuishushenqi.com"
let chapterURL = "http://chapter2.zhuishushenqi.com/chapter"
let bookshelf =  "user/bookshelf"
let ranking = "ranking/gender"


//MARK: - 常用frame
let BOUNDS = UIScreen.main.bounds
let ScreenWidth = UIScreen.main.bounds.size.width
let ScreenHeight = UIScreen.main.bounds.size.height
let SCALE = (ScreenWidth / 320.0)
let TOP_BAR_Height = 64
let FOOT_BAR_Height = 49
let STATEBARHEIGHT = UIApplication.shared.statusBarFrame.height

//区分屏幕
let IPHONE4 = UIScreen.instancesRespond(to: #selector(getter: RunLoop.currentMode)) ? CGSize(width: 640, height: 960).equalTo((UIScreen.main.currentMode?.size)!) : false
let IPHONE5 = UIScreen.instancesRespond(to: #selector(getter: RunLoop.currentMode)) ? CGSize(width: 640, height: 1136).equalTo((UIScreen.main.currentMode?.size)!) : false
let IPHONE6 = UIScreen.instancesRespond(to: #selector(getter: RunLoop.currentMode)) ? CGSize(width: 750, height: 1334).equalTo((UIScreen.main.currentMode?.size)!) : false
let IPHONE6Plus = UIScreen.instancesRespond(to: #selector(getter: RunLoop.currentMode)) ? CGSize(width: 1242, height: 2208).equalTo((UIScreen.main.currentMode?.size)!) : false


//根据系统判断 获取iPad的屏幕尺寸

let IOS9_OR_LATER = (Float(UIDevice.current.systemVersion) >= 9.0)
let IOS8_OR_LATER = (Float(UIDevice.current.systemVersion) >= 8.0)
let IOS7_OR_LATER = (Float(UIDevice.current.systemVersion) >= 7.0)
let APP_DELEGATE = (UIApplication.shared.delegate as! AppDelegate)
let APP_DELEGATEKeyWindow = UIApplication.shared.delegate?.window
let USER_DEFAULTS =  UserDefaults.standard
let KeyWindow = UIApplication.shared.keyWindow

func widthOfString(_ str:String, font:UIFont,height:CGFloat) ->CGFloat
{
    let dict = [NSFontAttributeName:font]
    let sttt:NSString = str as NSString
    let rect:CGRect = sttt.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(height)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: dict, context: nil)
    return rect.size.width
}

func heightOfString(_ str:String, font:UIFont,width:CGFloat) ->CGFloat
{
    let dict = [NSFontAttributeName:font]
    let sttt:NSString = str as NSString
    let rect:CGRect = sttt.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: dict, context: nil)
    return rect.size.height
}

func timeBetween(_ beginDate:Date?,endDate:Date?)->TimeInterval{
    if beginDate == nil || endDate == nil {
        return 0
    }
    let dateFormat = DateFormatter()
    dateFormat.dateFormat = "yyyy-MM-dd hh-mm-ss"
    let beginTime = beginDate?.timeIntervalSince1970
    let endTime = endDate?.timeIntervalSince1970
    let resultTime = endTime! - beginTime!
    return resultTime
}

