//
//  Config.swift
//  zhuishushenqi
//
//  Created by Nory Chao on 16/9/17.
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
let SideVC = SideViewController.shared
let ReaderBg = "ReaderBg"
let FontSize = "FontSize"
let Brightness = "Brightness"
let ReadingProgress = "ReadingProgress"

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

enum ReadeeBgType:Int{
    case white = 0
    case yellow = 1
    case green = 2
}

func getReaderBgColor()->UIImage?{
    var image:UIImage? = UIImage(named: "yellow_mode_bg")
    let bg:Int? = UserDefaults.standard.value(forKey: ReaderBg) as? Int
    if let bgEnum = bg {
        let type = ReadeeBgType(rawValue: bgEnum)
        if let typeee = type{
            switch typeee {
            case ReadeeBgType.white:
                image = UIImage(named: "common_button_white")
                break
            case .yellow:
                image = UIImage(named: "yellow_mode_bg")
                break
            case .green:
                image = UIImage(named: "green_mode_bg")
                break
            }
        }
    }
    return image
}

func getReaderBg()->ReadeeBgType{
    let bg:Int? = UserDefaults.standard.value(forKey: ReaderBg) as? Int
    if let bgEnum = bg {
        let type = ReadeeBgType(rawValue: bgEnum)
        if let typeee = type{
            return typeee
        }
    }
    return .white
}

func setReaderBg(type:ReadeeBgType){
    UserDefaults.standard.set(type.rawValue, forKey: ReaderBg)
}

func getFontSize()->Int{
    let size = UserDefaults.standard.value(forKey: FontSize) as? Int
    return size ?? 20
}

func setFontSize(size:Int){
    UserDefaults.standard.set(size, forKey: FontSize)
}

func setBrightness(value:CGFloat){
    UserDefaults.standard.set(value, forKey: Brightness)
}

func getBrightness()->CGFloat{
    let value = UserDefaults.standard.value(forKey: Brightness) as? CGFloat
    return value ?? 0.5
}

func getProgress(id:String)->NSDictionary{
    let arr:[NSDictionary]? = USER_DEFAULTS.value(forKey: ReadingProgress) as? [NSDictionary]
    guard var opArr = arr else {
        return ["":""]
    }
    for item in 0..<opArr.count {
        if id == (opArr[item]["id"] as? String  ?? "") {
            return opArr[item]
        }
    }
    return ["":""]
}

func updateProgress(dict:NSDictionary){
    let arr:[NSDictionary]? = USER_DEFAULTS.value(forKey: ReadingProgress) as? [NSDictionary]
    guard var opArr = arr else {
        return
    }
    for item in 0..<opArr.count {
        if dict["id"] as? String == opArr[item]["id"] as? String {
            opArr[item] = dict
        }
    }
    USER_DEFAULTS.set(opArr, forKey: ReadingProgress)
}

func isExistShelf(bookDetail:BookDetail?)->Bool{
    let mArr:[BookDetail] = BookShelfInfo.books.bookShelf
    var exist = false
    for item in mArr {
        if item._id == (bookDetail?._id ?? "") {
            exist = true
        }
    }
    return exist
}

enum BookShelfUpdateType {
    case add
    case delete
}

@discardableResult
func isExistBookShelf(bookDetail:BookDetail?)->Bool{
    let mArr:[BookDetail] = BookShelfInfo.books.bookShelf
    var exist = false
    for item in mArr {
        if item._id == (bookDetail?._id ?? "") {
            exist = true
        }
    }
    return exist
}

func updateReadingInfo(bookDetail:BookDetail?){
    var mArr:[BookDetail] = BookShelfInfo.books.bookShelf
    var index = 0
    for item in mArr {
        let model = item
        if item._id == (bookDetail?._id ?? "") {
            model.chapter = bookDetail?.chapter ?? 0
            model.page = bookDetail?.page ?? 0
            model.sourceIndex = bookDetail?.sourceIndex ?? 0
            model.chapters = bookDetail?.chapters
            model.resources = bookDetail?.resources
            mArr[index] = model
            BookShelfInfo.books.bookShelf = mArr
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "BookShelfRefresh")))
        }
        index += 1
    }
}

@discardableResult
func updateBookShelf(bookDetail:BookDetail?,type:BookShelfUpdateType)->Bool{
    var mArr:[BookDetail] = BookShelfInfo.books.bookShelf
    var exist = false
    var index = 0
    for item in mArr {
        if item._id == (bookDetail?._id ?? "") {
            exist = true
        }
        index += 1
    }
    if !exist {
        if let model = bookDetail{
            if type == .add {
                mArr.append(model)
                BookShelfInfo.books.bookShelf = mArr
                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "BookShelfRefresh")))
            }else if type == .delete {
                mArr.remove(at: index - 1)
                BookShelfInfo.books.bookShelf = mArr
                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "BookShelfRefresh")))
            }
        }
    }
    return exist
}



func QSLog<T>(_ message:T,fileName:String = #file,lineName:Int = #line,funcName:String = #function){
    #if DEBUG
        print("QSLog:\((fileName as NSString).lastPathComponent)[\(lineName)]\(funcName):\n\(message)\n")
    #endif
}

