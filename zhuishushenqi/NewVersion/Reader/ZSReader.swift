//
//  ZSReader.swift
//  zhuishushenqi
//
//  Created by caony on 2019/7/9.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit

func cache(value:Int ,for key:String) {
    UserDefaults.standard.set(value, forKey: key)
    UserDefaults.standard.synchronize()
}

func cache(value:CGFloat ,for key:String) {
    UserDefaults.standard.set(value, forKey: key)
    UserDefaults.standard.synchronize()
}

func cache(value:CGRect,for key:String) {
    UserDefaults.standard.set(value, forKey: key)
    UserDefaults.standard.synchronize()
}

func getValue(for key:String) ->Int {
    
    if let value = UserDefaults.standard.value(forKey: key) as? Int {
        return value
    }
    return -1
}

func getValue(for key:String) ->CGFloat {
    
    if let value = UserDefaults.standard.value(forKey: key) as? CGFloat {
        return value
    }
    return -1
}

func getRectValue(for key:String) ->CGRect {
    
    if let value = UserDefaults.standard.value(forKey: key) as? CGRect {
        return value
    }
    return CGRect.zero
}

class ZSReader {
    
    static let share = ZSReader()
    
    var pageStyle:ZSReaderPageStyle = .pageCurl {
        didSet {
            cache(value: pageStyle.rawValue, for: "\(ZSReader.self).\(ZSReaderPageStyle.self)")
            self.didChangePageStyle(pageStyle)
        }
    }
    var contentFrame = CGRect(x: 10, y: STATEBARHEIGHT, width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.height - STATEBARHEIGHT - 30) {
        didSet {
            cache(value: contentFrame, for: "\(ZSReader.self).contentFrame")
            self.didChangeContentFrame(contentFrame)
        }
    }
    var theme:ZSReaderTheme = ZSReaderTheme() {
        didSet {
            self.didChangeTheme(theme)
        }
    }
    var bookStyle:ZSReaderBookStyle = .online {
        didSet {
            cache(value: bookStyle.rawValue, for: "\(ZSReader.self).\(ZSReaderBookStyle.self)")
            self.didChangeBookStyle(bookStyle)
        }
    }
    
    var didChangePageStyle: (ZSReaderPageStyle) ->Void = { _ in }
    var didChangeContentFrame: (CGRect) ->Void = { _ in }
    var didChangeBookStyle: (ZSReaderBookStyle) ->Void = { _ in }
    var didChangeTheme: (ZSReaderTheme) ->Void = { _ in }
    
    private init() {
//        pageStyle = ZSReaderPageStyle.init(rawValue: getValue(for: "\(ZSReader.self).\(ZSReaderPageStyle.self)")) ?? .pageCurl
//        contentFrame = getRectValue(for: "\(ZSReader.self).contentFrame").equalTo(CGRect.zero) ? UIScreen.main.bounds:getRectValue(for: "\(ZSReader.self).contentFrame")
        bookStyle = ZSReaderBookStyle.init(rawValue: getValue(for:
            "\(ZSReader.self).\(ZSReaderBookStyle.self)")) ?? .online
        let pageStyleCacheValue:Int = getValue(for: "\(ZSReader.self).\(ZSReaderPageStyle.self)")
        if pageStyleCacheValue >= 0 {
            pageStyle = ZSReaderPageStyle.init(rawValue: pageStyleCacheValue) ?? .normal
        }
    }
    
    public func attributes() -> [NSAttributedString.Key:Any]{
        
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineSpacing = theme.lineSpace
        
        paragraphStyle.paragraphSpacing = theme.paragraphSpace
        
        let font = UIFont(name: "ArialMT", size: theme.fontSize.size) ?? UIFont.systemFont(ofSize: theme.fontSize.size)
        
        let attributes = [NSAttributedString.Key.font:font,
                          NSAttributedString.Key.paragraphStyle:paragraphStyle] as [NSAttributedString.Key : Any]
        return attributes
    }
}

class ZSReaderTheme {
    var readerStyle:ZSReaderStyle = .white {
        didSet {
            cache(value: readerStyle.rawValue, for: "\(ZSReaderTheme.self).\(ZSReaderStyle.self)")
            self.didChangeReaderStyle(readerStyle)
        }
    }
    var fontSize:ZSReaderFontSize = ZSReaderFontSize() {
        didSet {
            cache(value: fontSize.size, for: "\(ZSReaderTheme.self).\(ZSReaderFontSize.self)")
            self.didChangeFontSize(fontSize)
        }
    }
    var fontStyle:ZSReaderFont = .system {
        didSet {
            cache(value: fontStyle.rawValue, for: "\(ZSReaderTheme.self).\(ZSReaderFont.self)")
            self.didChangeFontStyle(fontStyle)
        }
    }
    var lineSpace:CGFloat = 10 {
        didSet {
            cache(value: lineSpace, for: "\(ZSReaderTheme.self).lineSpace")
            self.didChangeLineSpace(lineSpace)
        }
    }
    var paragraphSpace:CGFloat = 5 {
        didSet {
            cache(value: paragraphSpace, for: "\(ZSReaderTheme.self).paragraphSpace")
            self.didChangeParagraphSpace(paragraphSpace)
        }
    }
    var chinese:ZSReaderChinese = .simple {
        didSet {
            cache(value: chinese.rawValue, for: "\(ZSReaderTheme.self).\(ZSReaderChinese.self)")
            self.didChangeChine(chinese)
        }
    }
    var brightness:ZSReaderBrightness = ZSReaderBrightness() {
        didSet {
            cache(value: CGFloat(brightness.brightness), for: "\(ZSReaderTheme.self).\(ZSReaderBrightness.self)")
            self.didChangeBrightness(brightness)
        }
    }
    
    init() {
        fontSize = ZSReaderFontSize()
    }
    
    var didChangeReaderStyle: (ZSReaderStyle) ->Void = { _ in }
    var didChangeFontSize: (ZSReaderFontSize) ->Void = { _ in }
    var didChangeFontStyle: (ZSReaderFont) ->Void = { _ in }
    var didChangeLineSpace: (CGFloat) ->Void = { _ in }
    var didChangeParagraphSpace: (CGFloat) ->Void = { _ in }
    var didChangeChine: (ZSReaderChinese) ->Void = { _ in }
    var didChangeBrightness: (ZSReaderBrightness) ->Void = { _ in }
    
}

enum ZSReaderBookStyle:Int {
    case online
    case local
}

struct ZSReaderFontSize {
    var size:CGFloat = 15
    var enableBigger:Bool = true
    var enableSmaller:Bool = false
    
    init() {
        let pageStyleCacheValue:CGFloat = getValue(for: "\(ZSReaderTheme.self).\(ZSReaderFontSize.self)")
        if pageStyleCacheValue >= 15 {
            size = pageStyleCacheValue
        }
        enableSmaller = size > 15 ? true:false
        enableBigger = size < 30 ? true:false
    }
    
    mutating func bigger() {
        if !enableBigger {
           return
        }
        size += 1
        enableSmaller = size > 15 ? true:false
        enableBigger = size < 30 ? true:false
    }
    
    mutating func smaller() {
        if !enableSmaller {
            return
        }
        size -= 1
        enableSmaller = size > 15 ? true:false
        enableBigger = size < 30 ? true:false
    }
}

struct ZSReaderBrightness {
    var brightness:Float = 1.0
    var enableBigger:Bool = false
    var enableSmaller:Bool = true
    var minValue:Float = 0.0
    var maxValue:Float = 0.8
    
    init() {
        enableSmaller = brightness > minValue ? true:false
        enableBigger = brightness < maxValue ? true:false
    }
    
    mutating func bigger() {
        if !enableBigger {
            return
        }
        brightness += 0.1
        enableSmaller = brightness > minValue ? true:false
        enableBigger = brightness < maxValue ? true:false
    }
    
    mutating func smaller() {
        if !enableSmaller {
            return
        }
        brightness -= 0.1
        enableSmaller = brightness > minValue ? true:false
        enableBigger = brightness < maxValue ? true:false
    }
}

enum ZSReaderChinese:Int {
    case simple
    case traditional
}

enum ZSReaderStyle:Int {
    case white
    case yellow
    case green
//    case blackgreen
    case pink
    case sheepskin
    case violet
    case water
    case weekGreen
    case weekPink
    case coffee
    case night
    
    var isNightMode:Bool {
        return self == .night
    }
    
    static let count: Int = {
        var max: Int = 0
        while let _ = ZSReaderStyle(rawValue: max) { max += 1 }
        return max
    }()
    
    var backgroundImage:UIImage {
        switch self {
        case .yellow:
            return #imageLiteral(resourceName: "yellow_mode_bg")
        case .white:
            return #imageLiteral(resourceName: "white_mode_bg")
        case .green:
            return #imageLiteral(resourceName: "green_mode_bg")
//        case .blackgreen:
//            return #imageLiteral(resourceName: "new_nav_night_normal")
        case .pink:
            return #imageLiteral(resourceName: "violet_mode_bg")
        case .sheepskin:
            return #imageLiteral(resourceName: "beijing")
        case .violet:
            return #imageLiteral(resourceName: "violet_mode_bg")
        case .water:
            return #imageLiteral(resourceName: "sheepskin_mode_bg")
        case .weekPink:
            return #imageLiteral(resourceName: "violet_mode_bg")
        case .weekGreen:
            return #imageLiteral(resourceName: "violet_mode_bg")
        case .coffee:
            return #imageLiteral(resourceName: "pf_header_bg")
        case .night:
            return #imageLiteral(resourceName: "blackGreen_mode_bg")
        default:
            return #imageLiteral(resourceName: "violet_mode_bg")
        }
    }
    
    var textColor:UIColor {
        switch self {
        case .yellow,.white,.green:
            return UIColor.black
        case .coffee:
            return UIColor.white
        default:
            return UIColor.black
        }
    }
    
    var batteryColor:UIColor {
        switch self {
        case .yellow,.white,.green:
            return UIColor.darkGray
        case .coffee:
            return UIColor.white
        default:
            return UIColor.darkGray
        }
    }
    
    var borderColor:UIColor {
        switch self {
        case .white:
            return UIColor.black
        default:
            return UIColor.black
        }
    }
    
    var current:ReaderTheme {
        switch self {
        case .white:
            return WhiteTheme()
        default:
            return WhiteTheme()
        }
    }
}

enum ZSReaderFont:Int {
    case system
    case lantingBalck
    case kaiti
    case weibei
    case yapi
    case pianpianti
    case lishu
    case riwen
    
    var fontPath:String? {
        switch self {
        case .system:
            return nil
        default:
            return nil
        }
        return nil
    }
}

enum ZSReaderPageStyle:Int {
    case normal
    case pageCurl
    case vertical
    case horizonal
    
    var styleName:String {
        switch self {
        case .normal:
            return "无"
        case .pageCurl:
            return "仿真翻页"
        case .vertical:
            return "上下滚屏"
        case .horizonal:
            return "左右平移"
        default:
            return "无"
        }
    }
    
    static let count: Int = {
        var max: Int = 0
        while let _ = ZSReaderPageStyle(rawValue: max) { max += 1 }
        return max
    }()
    
    var pageViewControler:BaseViewController? {
        switch self {
        case .pageCurl:
            
            break
        default:
            return nil
        }
        return nil
    }
}
