//
//  ThemeManager.swift
//  dlxk
//
//  Created by caony on 2019/11/30.
//  Copyright © 2019 dlxk. All rights reserved.
//

import Foundation
import UIKit

enum ThemeManagerPrefs: String {
    case systemThemeIsOn = "prefKeySystemThemeSwitchOnOff"
    case automaticSwitchIsOn = "prefKeyAutomaticSwitchOnOff"
    case automaticSliderValue = "prefKeyAutomaticSliderValue"
    case themeName = "prefKeyThemeName"
}

protocol Themeable:class {
    func applyTheme()
}

protocol ReaderTheme {
    
    var name:String { get }
    var navigationBar:ReaderNavigationBar { get }
    var bottomBar:ReaderBottomBar { get }
    var bigBottomBar:ReaderBigBottomBar { get }
    var readerBar:ReaderBar { get }
}

class WhiteTheme:ReaderTheme {
    var navigationBar: ReaderNavigationBar { return WhiteReaderNavigationBar() }
    
    var bottomBar: ReaderBottomBar { return ReaderBottomBar() }
    
    var bigBottomBar: ReaderBigBottomBar { return ReaderBigBottomBar() }
    
    var readerBar: ReaderBar { return ReaderBar() }
    
    var name: String { return ThemeName.white.rawValue }
    
}

class DarkTheme:WhiteTheme {
    override var name: String { return ThemeName.dark.rawValue }

}

class ReaderBottomBar {
    
}

class ReaderBigBottomBar {
    
}

enum ThemeName:String {
    case white
    case dark
}

fileprivate func themeFrom(name: String?) -> ReaderTheme {
    guard let name = name, let theme = ThemeName(rawValue: name) else { return WhiteTheme() }
    switch theme {
    case .dark:
        return DarkTheme()
    default:
        return WhiteTheme()
    }
}
