//
//  Config.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 16/9/17.
//  Copyright © 2016年 QS. All rights reserved.
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
let BASEURL = "http://api.zhuishushenqi.com"
let IMAGE_BASEURL = "http://statics.zhuishushenqi.com"
let CHAPTERURL = "http://chapter2.zhuishushenqi.com/chapter"
let BOOKSHELF =  "user/bookshelf"
let RANKING = "ranking/gender"

// db
let searchHistory = "searchHistory"
let dbName = "QS.zhuishushenqi.searchHistory"

//MARK: - 常用frame
let BOUNDS = UIScreen.main.bounds
let ScreenWidth = UIScreen.main.bounds.size.width
let ScreenHeight = UIScreen.main.bounds.size.height
let SCALE = (ScreenWidth / 320.0)
let TOP_BAR_Height = 64
let FOOT_BAR_Height = 49
let STATEBARHEIGHT = UIApplication.shared.statusBarFrame.height
let kNavgationBarHeight:CGFloat = (IPHONEX ? 88:64)
let kTabbarBlankHeight  = (IPHONEX ? 34:0)
let kQSReaderTopMargin = (IPHONEX ? 30:0)

//区分屏幕
let IPHONE4 = UIScreen.instancesRespond(to: #selector(getter: RunLoop.currentMode)) ? CGSize(width: 640, height: 960).equalTo((UIScreen.main.currentMode?.size)!) : false
let IPHONE5 = UIScreen.instancesRespond(to: #selector(getter: RunLoop.currentMode)) ? CGSize(width: 640, height: 1136).equalTo((UIScreen.main.currentMode?.size)!) : false
let IPHONE6 = UIScreen.instancesRespond(to: #selector(getter: RunLoop.currentMode)) ? CGSize(width: 750, height: 1334).equalTo((UIScreen.main.currentMode?.size)!) : false
let IPHONE6Plus = UIScreen.instancesRespond(to: #selector(getter: RunLoop.currentMode)) ? CGSize(width: 1242, height: 2208).equalTo((UIScreen.main.currentMode?.size)!) : false
let IPHONEX = UIScreen.instancesRespond(to: #selector(getter: RunLoop.currentMode)) ? CGSize(width: 1125, height: 2436).equalTo((UIScreen.main.currentMode?.size)!) : false


//根据系统判断 获取iPad的屏幕尺寸

let IOS9_OR_LATER = (Float(UIDevice.current.systemVersion) >= 9.0)
let IOS8_OR_LATER = (Float(UIDevice.current.systemVersion) >= 8.0)
let IOS7_OR_LATER = (Float(UIDevice.current.systemVersion) >= 7.0)
let APP_DELEGATE = (UIApplication.shared.delegate as! AppDelegate)
let APP_DELEGATEKeyWindow = UIApplication.shared.delegate?.window
let USER_DEFAULTS =  UserDefaults.standard
let KeyWindow = UIApplication.shared.keyWindow
let SideVC = SideViewController.shared
let ReaderBg = "ReaderBg"
let FontSize = "FontSize"
let OriginalBrightness = "OriginalBrightness"
let Brightness = "Brightness"
let ReadingProgress = "ReadingProgress"
let PostLink = "PostLink"

// notification
let SHOW_RECOMMEND = "ShowRecomend"
let BOOKSHELF_REFRESH = "BookShelfRefresh"
let BOOKSHELF_ADD = "BOOKSHELF_ADD"
let BOOKSHELF_DELETE = "BOOKSHELF_DELETE"


func getAttributes(with lineSpave:CGFloat,font:UIFont)->NSDictionary{
    let paraStyle = NSMutableParagraphStyle()
    paraStyle.lineBreakMode = .byCharWrapping
    paraStyle.alignment = .left
    paraStyle.lineSpacing = lineSpave
    paraStyle.hyphenationFactor = 1.0
    paraStyle.firstLineHeadIndent = 0.0
    paraStyle.paragraphSpacingBefore = 0.0
    paraStyle.headIndent = 0
    paraStyle.tailIndent = 0
    let dict = [NSAttributedStringKey.font:font,NSAttributedStringKey.kern:1.5,NSAttributedStringKey.paragraphStyle:paraStyle] as [NSAttributedStringKey : Any]
    return dict as NSDictionary
}

func attributeText(with lineSpace:CGFloat,text:String,font:UIFont)->NSAttributedString{
    let paraStyle = NSMutableParagraphStyle()
    paraStyle.lineBreakMode = .byCharWrapping
    paraStyle.alignment = .left
    paraStyle.hyphenationFactor = 1.0
    paraStyle.firstLineHeadIndent = 0.0
    paraStyle.paragraphSpacingBefore = 0.0
    paraStyle.headIndent = 0
    paraStyle.tailIndent = 0
    let dict = [NSAttributedStringKey.font:font,NSAttributedStringKey.kern:1.5,NSAttributedStringKey.paragraphStyle:paraStyle] as [NSAttributedStringKey : Any]
    let attributeStr = NSAttributedString(string: text, attributes: dict)
    return attributeStr
}

func QSLog<T>(_ message:T,fileName:String = #file,lineName:Int = #line,funcName:String = #function){
    #if DEBUG
        print("QSLog:\((fileName as NSString).lastPathComponent)[\(lineName)]\(funcName):\n\(message)\n")
    #endif
}

