//
//  QSReaderSetting.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2018/2/6.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit

let QSReaderSettingKey = "QSReaderSettingKey"
let QSReaderPagesClearNotificationKey = "QSReaderPagesClearNotificationKey"
let QSReaderLineSpace:CGFloat = 10
let QSReaderParagraphSpace:CGFloat = 5

// 阅读器的阅读设置，全局设置
@objc enum QSReaderFontStyle:Int {
    case system = 0
    case lantingBalck
    case kaiti
    case weibei
    case yapi
    case pianpianti
    case lishu
    case riwen
}

@objc enum QSReaderPageStyle:Int {
    case curlPage = 0
    case simple = 1
    case scroll = 2
    func description() ->String {
        switch self {
        case .curlPage:
            return "curlPage"
        case .simple:
            return "simple"
        case .scroll:
            return "scroll"
        }
    }
}

// 简体与繁体
@objc enum QSReaderChineseFontStyle:Int {
    case simpleChinese = 0
    case tranditionalChinese
}

@objc enum QSReaderBackgroundStyle:Int {
    case white
    case yellow
    case green
}

// 阅读器屏幕方向，默认竖屏
@objc enum QSReaderOrientation:Int {
    case portrait
    case landscape
}

// MARK: - 此种模式不是全局模式，而是根据书籍的信息来进行的设置，保存到对应的book的model中
// 搜索模式，退出时保存设置
@objc enum QSReaderSearchMode:Int {
    case zhuishu
    case baidu
    case shenma
    case tieba
}

// 阅读器能设置的最小字体
let QSReaderFontSizeMin:NSInteger = 15;
// 阅读器能设置的最大字体
let QSReaderFontSizeMax:NSInteger = 30;

let QSReaderBrightnessMin = 0

let QSReaderBrightnessMax = 1

// 阅读器显示文字区域的frame，要适配新的设备
let QSReaderFrame = CGRect(x: 10, y: STATEBARHEIGHT, width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.height - STATEBARHEIGHT - 30)

@objcMembers
class QSReaderSetting: NSObject {

    var fontSize:NSInteger = QSReaderFontSizeMin { didSet { fontSizeAction() } }
    var fontStyle:QSReaderFontStyle = .system { didSet {  fontStyleAction() } }
    var pageStyle:QSReaderPageStyle = .curlPage { didSet {  pageStyleAction() } }
    var brightness:Float = 1 { didSet { brightnessAction() } }
    var chineseFontStyle:QSReaderChineseFontStyle = .simpleChinese { didSet { chineseFontStyleAction() } }
    var lineSpace:CGFloat = QSReaderLineSpace
    var paragraphSpace:CGFloat = QSReaderParagraphSpace
    
    var background:QSReaderBackgroundStyle = .white { didSet { backgroundStyleAction() } }
    
    static var shared = QSReaderSetting(dict: nil)
    
    public func attributes() -> [NSAttributedStringKey:Any]{
        
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineSpacing = QSReaderLineSpace
        
        paragraphStyle.paragraphSpacing = QSReaderParagraphSpace
        
        let font = readerFont()
        
        let attributes = [NSAttributedStringKey.font:font,
                          NSAttributedStringKey.paragraphStyle:paragraphStyle] as [NSAttributedStringKey : Any]
        return attributes
    }
    
    public func readerFont() -> UIFont{
        
        // 系统字体经常变化，因此固定一个字体
        var font:UIFont = UIFont(name: "ArialMT", size: CGFloat(fontSize))!

        switch fontStyle {
        case .system:
            font = UIFont(name: "ArialMT", size: CGFloat(fontSize))!
            break
        case .lantingBalck:
            font = UIFont(name: "ArialMT", size: CGFloat(fontSize))!
            break
        default:
            font = UIFont(name: "ArialMT", size: CGFloat(fontSize))!
            break
        }
        return font
    }
    
    fileprivate init(dict:Any?) {
        super.init()
        let reader:[String:Any]? = UserDefaults.standard.value(forKey: QSReaderSettingKey) as? [String : Any]
        if let tmp = reader {
            setValuesForKeys(tmp)
        }
    }
    
    fileprivate override init() {
        super.init()
        let reader:[String:Any]? = UserDefaults.standard.value(forKey: QSReaderSettingKey) as? [String : Any]
        if let tmp = reader {
            setValuesForKeys(tmp)
        }
    }
    
    fileprivate func fontSizeAction(){
        if fontSize > QSReaderFontSizeMax {
            QSLog("fontSize:\(fontSize)\n 超出了限制")
            fontSize = QSReaderFontSizeMax
            return
        }
        if fontSize < QSReaderFontSizeMin {
            QSLog("fontSize:\(fontSize)\n 超出了限制")
            fontSize = QSReaderFontSizeMin
            return
        }
        save()
        // 通知chapter重新计算page
        NotificationCenter.qs_postNotification(name: QSReaderPagesClearNotificationKey,obj:nil)
    }
    
    fileprivate func fontStyleAction(){
        save()
    }
    
    fileprivate func pageStyleAction(){
        save()
    }
    
    fileprivate func brightnessAction(){
        save()
    }
    
    fileprivate func backgroundStyleAction(){
        save()
    }
    
    fileprivate func chineseFontStyleAction(){
        save()
    }
    
    fileprivate func save(){
        let reader = fetchProperties()
        UserDefaults.standard.set(reader, forKey: QSReaderSettingKey)
    }
}
