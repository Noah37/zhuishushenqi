//
//  ZSConfigUtil.swift
//  zhuishushenqi
//
//  Created by yung on 2019/6/30.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit
//import YYCategories
import AdSupport

class ZSConfigUtil: NSObject {
    
    static func publisherId() ->String {
        let shortCode = versionShortCode()
        let data = shortCode.data(using: .utf8)
        let base64 = data?.base64EncodedString(options: Data.Base64EncodingOptions.init(rawValue: 0))
        return base64?.md5() ?? ""
    }
    
    static func versionShortCode() ->String {
        let bundle = Bundle.main
        let info = bundle.infoDictionary
        if let shortCode = info?["CFBundleShortVersionString"] as? String {
            return shortCode
        }
        return ""
    }
    
    static func channel() ->String {
        return "App Store"
    }
    
    static func appName() ->String {
        return ""
    }
    
    static func platformString() ->String {
        return UIDevice.current.machineModelName ?? UIDevice.current.model
    }
    
    static func uniquelIdfa() ->String {
        let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        return idfa
    }

}
