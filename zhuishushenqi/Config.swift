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
    case update
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
    DispatchQueue.global().async {
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
}

func bookShelfRefresh(model:BookDetail,arr:[BookDetail])->[BookDetail]{
    var models = arr
    var index = 0
    for item in arr {
        if item._id == model._id {
            models.remove(at: index)
        }
        index += 1
    }
    return models
}

//发通知删除时需要重新请求数据，反应慢，书架删除时应该直接删除而不重新请求
@discardableResult
func updateBookShelf(bookDetail:BookDetail?,type:BookShelfUpdateType,refresh:Bool){
    DispatchQueue.global().async {
        
        var mArr:[BookDetail] = BookShelfInfo.books.bookShelf
        var index = 0
        var existIndex = -1
        for item in mArr {
            if item._id == (bookDetail?._id ?? "") {
                existIndex = index
            }
            index += 1
        }
        if let model = bookDetail{
            if type == .add {
                if existIndex == -1 {
                    mArr.append(model)
                    BookShelfInfo.books.bookShelf = mArr
                    if refresh {
                        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "BookShelfRefresh")))
                    }
                }
            }else if type == .delete {
                if  existIndex != -1 {
                    mArr.remove(at: existIndex)
                    BookShelfInfo.books.bookShelf = mArr
                    if refresh {
                        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "BookShelfRefresh")))
                    }
                }
            }else if type == .update {
                if existIndex != -1 {
                    mArr[existIndex] = model
                    BookShelfInfo.books.bookShelf = mArr
                    if refresh {
                        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "BookShelfRefresh")))
                    }
                }
            }
        }
    }
}

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
    let dict = [NSFontAttributeName:font,NSKernAttributeName:1.5,NSParagraphStyleAttributeName:paraStyle] as [String : Any]
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
    let dict = [NSFontAttributeName:font,NSKernAttributeName:1.5,NSParagraphStyleAttributeName:paraStyle] as [String : Any]
    let attributeStr = NSAttributedString(string: text, attributes: dict)
    return attributeStr
}

//-(void)setLabelSpace:(UILabel*)label withValue:(NSString*)str withFont:(UIFont*)font {
//    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
//    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
//    paraStyle.alignment = NSTextAlignmentLeft;
//    paraStyle.lineSpacing = UILABEL_LINE_SPACE; //设置行间距
//    paraStyle.hyphenationFactor = 1.0;
//    paraStyle.firstLineHeadIndent = 0.0;
//    paraStyle.paragraphSpacingBefore = 0.0;
//    paraStyle.headIndent = 0;
//    paraStyle.tailIndent = 0;
//    //设置字间距 NSKernAttributeName:@1.5f
//    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
//    };
//    
//    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
//    label.attributedText = attributeStr;
//}
//
////计算UILabel的高度(带有行间距的情况)
//-(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width {
//    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
//    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
//    paraStyle.alignment = NSTextAlignmentLeft;
//    paraStyle.lineSpacing = UILABEL_LINE_SPACE;
//    paraStyle.hyphenationFactor = 1.0;
//    paraStyle.firstLineHeadIndent = 0.0;
//    paraStyle.paragraphSpacingBefore = 0.0;
//    paraStyle.headIndent = 0;
//    paraStyle.tailIndent = 0;
//    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
//    };
//    
//    CGSize size = [str boundingRectWithSize:CGSizeMake(width, HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
//    return size.height;
//}



func QSLog<T>(_ message:T,fileName:String = #file,lineName:Int = #line,funcName:String = #function){
    #if DEBUG
        print("QSLog:\((fileName as NSString).lastPathComponent)[\(lineName)]\(funcName):\n\(message)\n")
    #endif
}

