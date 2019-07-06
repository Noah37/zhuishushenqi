//
//  ZSMobileLogin.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2018/10/24.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit

@objcMembers
public class ZSMobileLogin: NSObject {
    
    public let tencentCaptChaAppID = "2061491951"
    
    public var mobile:String = ""
    
    public var userInfo:ZSQQLoginResponse?
    
    public let MobileLoginQQUserFilePathKey = "MobileLoginQQUserFilePathKey"
    public let MobileLoginLastLoginTypeKey = "MobileLoginLastLoginTypeKey"
    
    public static let share = ZSMobileLogin()
    private override init() {
        super.init()
        
        let user = self.localUserInfo()
        self.userInfo = user
    }
    
    public func startVerifyHTML() ->String {
        let sdkOpts = ["sdkOpts":["height":140,"width":140]]
        let data = try! JSONSerialization.data(withJSONObject: sdkOpts, options: .prettyPrinted)
        if let string = String(data: data, encoding: .utf8) {
            if let percentString = string.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
                let radom = self.getRandomSeq()
                let jsString = "<!DOCTYPE html> <html lang=\"zh_cn\"> <head> <title></title> <meta charset=\"UTF-8\"> <meta name=\"renderer\" content=\"webkit\"> <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"> <meta name=\"format-detection\" content=\"address=no; email=no\"> <script src=\"https://ssl.captcha.qq.com/TCaptcha.js?v=\(radom)\" type=\"text/javascript\"></script> </head> <body> <div style=\"display: none\"><iframe id=\"tcaptcha_callback_iframe\"></iframe></div> <script type=\"text/javascript\"> (function(){ function getSDKJsonString(json) { var jsonString = encodeURIComponent(JSON.stringify(json)); return jsonString; }; window.SDKTCaptchaVerifyCallback = function (retJson) { if (retJson){ SDKTCaptchaCommonCallback(\"tcwebscheme://callback?retJson=\"+getSDKJsonString(retJson)); } }; window.SDKTCaptchaReadyCallback = function (retJson) { if (retJson && retJson.sdkView && retJson.sdkView.width && retJson.sdkView.height && parseInt(retJson.sdkView.width) >0 && parseInt(retJson.sdkView.height) >0 ){ SDKTCaptchaCommonCallback(\"tcwebscheme://readyCallback?retJson=\"+getSDKJsonString(retJson)); } }; window.onerror = function (msg, url, line, col, error) { if (window.TencentCaptcha == null) { SDKTCaptchaCommonCallback(\"tcwebscheme://jserrorCallback?retJson=\"+encodeURIComponent(msg)); } }; var SDKTCaptchaCommonCallback= function (url) { document.getElementById(\"tcaptcha_callback_iframe\").src = url; }; var sdkOptions = JSON.parse(decodeURIComponent(\"\(percentString)\")); sdkOptions[\"ready\"] = window.SDKTCaptchaReadyCallback; window.onload = function () { new TencentCaptcha(\"\(ZSMobileLogin.share.tencentCaptChaAppID)\", SDKTCaptchaVerifyCallback, sdkOptions).show(); }; })(); </script></body></html>"
                return jsString
            }
            
        }
        return ""
    }
    
    public func fetchSMSCode() {
        
    }
    
    public func getRandomSeq() ->String {
        
        let v2 = arc4random()
        var v3:CLongLong = 0
        if v2 != 0 {
            v3 = CLongLong(v2)
        } else {
            v3 = 1
        }
        let v4 = Date()
        let v6 = v4.timeIntervalSince1970
        let v7 = v6 * 1000.0
        let result = String(format: "%llu_%ld", v7,v3)
        return result
    }
    
    public func saveUserInfo(userInfo:ZSQQLoginResponse) {
        let filePath = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(MobileLoginQQUserFilePathKey.md5())"
        NSKeyedArchiver.archiveRootObject(userInfo, toFile: filePath)
        UserDefaults.standard.setValue("mobile", forKey: MobileLoginLastLoginTypeKey.md5() ?? "")
        UserDefaults.standard.synchronize()
    }
    
    public func localUserInfo() -> ZSQQLoginResponse? {
        let filePath = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(MobileLoginQQUserFilePathKey.md5())"
        let user = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? ZSQQLoginResponse
        return user
    }

    public func resetLocalUserInfo() {
        let filePath = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(MobileLoginQQUserFilePathKey.md5())"
        try? FileManager.default.removeItem(atPath: filePath)
    }
    
}
