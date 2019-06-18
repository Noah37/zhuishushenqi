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
public let BASEURL = "http://api.zhuishushenqi.com"
public let IMAGE_BASEURL = "http://statics.zhuishushenqi.com"
public let CHAPTERURL = "http://chapter2.zhuishushenqi.com/chapter"
public let BOOKSHELF =  "user/bookshelf"
public let RANKING = "ranking/gender"

// db
public let searchHistory = "searchHistory"
public let dbName = "QS.zhuishushenqi.searchHistory"

//MARK: - 常用frame
public let BOUNDS = UIScreen.main.bounds
public let ScreenWidth = UIScreen.main.bounds.size.width
public let ScreenHeight = UIScreen.main.bounds.size.height
public let SCALE = (ScreenWidth / 320.0)
public let TOP_BAR_Height = 64
public let FOOT_BAR_Height = 49
public let STATEBARHEIGHT = UIApplication.shared.statusBarFrame.height
public let kNavgationBarHeight:CGFloat = (IPHONEX ? 88:64)
public let kTabbarBlankHeight  = (IPHONEX ? 34:0)
public let kQSReaderTopMargin = (IPHONEX ? 30:0)

//区分屏幕
public let IPHONE4 = UIScreen.instancesRespond(to: #selector(getter: RunLoop.currentMode)) ? CGSize(width: 640, height: 960).equalTo((UIScreen.main.currentMode?.size)!) : false
public let IPHONE5 = UIScreen.instancesRespond(to: #selector(getter: RunLoop.currentMode)) ? CGSize(width: 640, height: 1136).equalTo((UIScreen.main.currentMode?.size)!) : false
public let IPHONE6 = UIScreen.instancesRespond(to: #selector(getter: RunLoop.currentMode)) ? CGSize(width: 750, height: 1334).equalTo((UIScreen.main.currentMode?.size)!) : false
public let IPHONE6Plus = UIScreen.instancesRespond(to: #selector(getter: RunLoop.currentMode)) ? CGSize(width: 1242, height: 2208).equalTo((UIScreen.main.currentMode?.size)!) : false
public let IPHONEX = UIScreen.instancesRespond(to: #selector(getter: RunLoop.currentMode)) ? CGSize(width: 1125, height: 2436).height <= (UIScreen.main.currentMode?.size.height)! : false


//根据系统判断 获取iPad的屏幕尺寸

public let IOS9_OR_LATER = (Float(UIDevice.current.systemVersion) >= 9.0)
public let IOS8_OR_LATER = (Float(UIDevice.current.systemVersion) >= 8.0)
public let IOS7_OR_LATER = (Float(UIDevice.current.systemVersion) >= 7.0)
public let USER_DEFAULTS =  UserDefaults.standard
public let KeyWindow = UIApplication.shared.keyWindow
public let ReaderBg = "ReaderBg"
public let FontSize = "FontSize"
public let OriginalBrightness = "OriginalBrightness"
public let Brightness = "Brightness"
public let ReadingProgress = "ReadingProgress"
public let PostLink = "PostLink"

// notification
public let SHOW_RECOMMEND = "ShowRecomend"
public let BOOKSHELF_REFRESH = "BookShelfRefresh"
public let BOOKSHELF_ADD = "BOOKSHELF_ADD"
public let BOOKSHELF_DELETE = "BOOKSHELF_DELETE"

public let RootDisappearNotificationName = "RootDisappearNotificationName"


public func getAttributes(with lineSpave:CGFloat,font:UIFont)->NSDictionary{
    let paraStyle = NSMutableParagraphStyle()
    paraStyle.lineBreakMode = .byCharWrapping
    paraStyle.alignment = .left
    paraStyle.lineSpacing = lineSpave
    paraStyle.hyphenationFactor = 1.0
    paraStyle.firstLineHeadIndent = 0.0
    paraStyle.paragraphSpacingBefore = 0.0
    paraStyle.headIndent = 0
    paraStyle.tailIndent = 0
    let dict = [NSAttributedString.Key.font:font,NSAttributedString.Key.kern:1.5,NSAttributedString.Key.paragraphStyle:paraStyle] as [NSAttributedString.Key : Any]
    return dict as NSDictionary
}

public func attributeText(with lineSpace:CGFloat,text:String,font:UIFont)->NSAttributedString{
    let paraStyle = NSMutableParagraphStyle()
    paraStyle.lineBreakMode = .byCharWrapping
    paraStyle.alignment = .left
    paraStyle.hyphenationFactor = 1.0
    paraStyle.firstLineHeadIndent = 0.0
    paraStyle.paragraphSpacingBefore = 0.0
    paraStyle.headIndent = 0
    paraStyle.tailIndent = 0
    let dict = [NSAttributedString.Key.font:font,NSAttributedString.Key.kern:1.5,NSAttributedString.Key.paragraphStyle:paraStyle] as [NSAttributedString.Key : Any]
    let attributeStr = NSAttributedString(string: text, attributes: dict)
    return attributeStr
}

public func QSLog<T>(_ message:T,fileName:String = #file,lineName:Int = #line,funcName:String = #function){
    #if DEBUG
        print("QSLog:\((fileName as NSString).lastPathComponent)[\(lineName)]\(funcName):\n\(message)\n")
    #endif
}

