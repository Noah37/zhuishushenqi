//
//  AppStyle.swift
//  zhuishushenqi
//
//  Created by yung on 2017/8/8.
//  Copyright © 2017年 QS. All rights reserved.
//

import Foundation

let nightKey = "light.key"
let fontSizeKey = "fontSize.key"
let animationStyleKey = "animationStyle.key"

struct AppStyle {
    
    static var shared = AppStyle()
    
    var readFontSize:Int {
        set {
            UserDefaults.standard.set(newValue, forKey: fontSizeKey)
        }
        get {
            let size = UserDefaults.standard.integer(forKey: fontSizeKey)
            if size == 0 {
                return 20;
            }
            return size
        }
    }
    
    var reader:Reader = AppStyle.getReader() {
        didSet{
            AppStyle.setReader(reader)
        }
    }
    
    var theme:AppTheme = UserDefaults.standard.bool(forKey: nightKey) ? .night : .day {
        didSet{
            UserDefaults.standard.set(theme == .night, forKey: nightKey)
        }
    }
    
    var animationStyle:ZSReaderAnimationStyle = ZSReaderAnimationStyle(rawValue: UserDefaults.standard.integer(forKey: animationStyleKey)) ?? .none {
        didSet {
            UserDefaults.standard.set(animationStyle.rawValue, forKey: animationStyleKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    private init(){}
    
    static func getReader()->Reader{
        let value = UserDefaults.standard.integer(forKey: readerKey)
        switch value {
        case 1:
            return .yellow
        case 2:
            return .green
        default:
            return .white
        }
    }
    
    static func setReader(_ reader:Reader){
        var value = 0
        switch reader {
        case .yellow:
            value = 1
        case .green:
            value = 2
        default:
            value = 0
        }
        UserDefaults.standard.set(value, forKey: readerKey)
    }

}
