//
//  Config.swift
//  zhuishushenqi
//
//  Created by caonongyun on 16/9/17.
//  Copyright © 2016年 CNY. All rights reserved.
//

import Foundation

//MARK: - 常用frame
let BOUNDS = UIScreen.mainScreen().bounds
let ScreenWidth = UIScreen.mainScreen().bounds.size.width
let ScreenHeight = UIScreen.mainScreen().bounds.size.height
let SCALE = (ScreenWidth / 320.0)
let TOP_BAR_Height = 64
let FOOT_BAR_Height = 49
let STATEBARHEIGHT = CGRectGetHeight(UIApplication.sharedApplication().statusBarFrame)

//区分屏幕
let IPHONE4 = UIScreen.instancesRespondToSelector(Selector("currentMode")) ? CGSizeEqualToSize(CGSizeMake(640, 960), (UIScreen.mainScreen().currentMode?.size)!) : false
let IPHONE5 = UIScreen.instancesRespondToSelector(Selector("currentMode")) ? CGSizeEqualToSize(CGSizeMake(640, 1136), (UIScreen.mainScreen().currentMode?.size)!) : false
let IPHONE6 = UIScreen.instancesRespondToSelector(Selector("currentMode")) ? CGSizeEqualToSize(CGSizeMake(750, 1334), (UIScreen.mainScreen().currentMode?.size)!) : false
let IPHONE6Plus = UIScreen.instancesRespondToSelector(Selector("currentMode")) ? CGSizeEqualToSize(CGSizeMake(1242, 2208), (UIScreen.mainScreen().currentMode?.size)!) : false


//根据系统判断 获取iPad的屏幕尺寸

let IOS9_OR_LATER = (Float(UIDevice.currentDevice().systemVersion) >= 9.0)
let IOS8_OR_LATER = (Float(UIDevice.currentDevice().systemVersion) >= 8.0)
let IOS7_OR_LATER = (Float(UIDevice.currentDevice().systemVersion) >= 7.0)
let APP_DELEGATE = (UIApplication.sharedApplication().delegate as! AppDelegate)
let APP_DELEGATEKeyWindow = UIApplication.sharedApplication().delegate?.window
let USER_DEFAULTS =  NSUserDefaults.standardUserDefaults()
let KeyWindow = UIApplication.sharedApplication().keyWindow

func widthOfString(str:String, font:UIFont,height:CGFloat) ->CGFloat
{
    let dict = [NSFontAttributeName:font]
    let sttt:NSString = str
    let rect:CGRect = sttt.boundingRectWithSize(CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(height)), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: dict, context: nil)
    return rect.size.width
}

func heightOfString(str:String, font:UIFont,width:CGFloat) ->CGFloat
{
    let dict = [NSFontAttributeName:font]
    let sttt:NSString = str
    let rect:CGRect = sttt.boundingRectWithSize(CGSize(width: width, height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: dict, context: nil)
    return rect.size.height
}

func timeBetween(beginDate:NSDate?,endDate:NSDate?)->NSTimeInterval{
    if beginDate == nil || endDate == nil {
        return 0
    }
    let dateFormat = NSDateFormatter()
    dateFormat.dateFormat = "yyyy-MM-dd hh-mm-ss"
    let beginTime = beginDate?.timeIntervalSince1970
    let endTime = endDate?.timeIntervalSince1970
    let resultTime = endTime! - beginTime!
    return resultTime
}

