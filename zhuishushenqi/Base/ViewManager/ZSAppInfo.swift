//
//  ZSAppInfo.swift
//  zhuishushenqi
//
//  Created by caony on 2019/1/22.
//  Copyright © 2019年 QS. All rights reserved.
//

import UIKit

class ZSAppInfo {
    
    static let infoDict = Bundle.main.infoDictionary
    /// App名称
    static let appDisplayName:String = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? ""
    /// bundle id
    static let bundleIdentifier:String = Bundle.main.bundleIdentifier ?? ""
    /// app 版本号
    static let appVersion: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    /// build 版本号
    static let buildVersion: String = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
    /// ios 版本
    static let iOSVersion: String = UIDevice.current.systemVersion
    /// 设备uuid
    static let identifierNumber:String = UIDevice.current.identifierForVendor?.uuidString ?? ""
    /// 设备名称
    static let systemName: String = UIDevice.current.systemName
    /// 设备型号
    static let model: String = UIDevice.current.model
    /// 设备区域化型号
    static let localizedModel: String = UIDevice.current.localizedModel
    
}
