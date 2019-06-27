//
//  ZSWXAccessTokenResp.swift
//  ZSThirdPartSDK
//
//  Created by caony on 2019/6/22.
//  Copyright © 2019 cj. All rights reserved.
//

import Foundation
import HandyJSON
import ZSExtension
import ZSAppConfig
import ZSAPI

@objc
public enum ThirdLoginType:Int {
    case None = 0
    case WX
    case QQ
    case WB
    case XM
}

@objcMembers
public class ZSRequestHelper: NSObject {
    public static let share = ZSRequestHelper()
    private override init () {}
    
    public func request(_ urlStr: String,parameters: [String:Any]? = nil,_ handler:@escaping ZSBaseCallback<ZSWXAccessTokenResp>) {
        zs_get(urlStr, parameters: parameters) { (json) in
            let tokenResp = ZSWXAccessTokenResp.deserialize(from: json)
            handler(tokenResp)
        }
    }
    
    public func WXLogin(webService:ZSLoginService,
                        idfa:String,
                        platform_code:String,
                        platform_token:String,
                        platform_uid:String,
                        version:String,
                        tag:String,
                        successHandler:@escaping (ZSQQLoginResponse?)->Void,
                        loginResultHandler:@escaping (Bool)->Void) {
        KeyWindow?.showProgress()
        let loginApi:ZSAPI = ZSAPI.login(idfa: idfa, platform_code: platform_code, platform_token: platform_token, platform_uid: platform_uid, version: version ,tag: tag)
        webService.WXLogin(url: loginApi.path, parameter: loginApi.parameters) { (json) in
            KeyWindow?.hideProgress()
            if let user = json {
                // 登录成功
                KeyWindow?.showTip(tip: "登录成功")
                ZSThirdLoginStorage.share.saveUserInfo(userInfo: user, type: .QQ)
                successHandler(user)
                loginResultHandler(true)
                
            } else {
                KeyWindow?.showTip(tip: "登录失败")
                successHandler(nil)
                loginResultHandler(false)
            }
        }
    }
    
    public func WBLogin(webService:ZSLoginService,
                        idfa:String,
                        platform_code:String,
                        platform_token:String,
                        platform_uid:String,
                        version:String,
                        tag:String,
                        successHandler:@escaping (ZSQQLoginResponse?)->Void,
                        loginResultHandler:@escaping (Bool)->Void) {
        KeyWindow?.showProgress()
        let loginApi:ZSAPI = ZSAPI.login(idfa: idfa, platform_code: platform_code, platform_token: platform_token, platform_uid: platform_uid, version: version ,tag: tag)
        webService.WBLogin(url: loginApi.path, parameter: loginApi.parameters) { (json) in
            KeyWindow?.hideProgress()
            if let user = json {
                // 登录成功
                KeyWindow?.showTip(tip: "登录成功")
                ZSThirdLoginStorage.share.saveUserInfo(userInfo: user, type: .QQ)
                successHandler(user)
                loginResultHandler(true)
                
            } else {
                KeyWindow?.showTip(tip: "登录失败")
                successHandler(nil)
                loginResultHandler(false)
            }
        }
    }
    
    public func QQLogin(webService:ZSLoginService,
                        idfa:String,
                        platform_code:String,
                        platform_token:String,
                        platform_uid:String,
                        version:String,
                        tag:String,
                        successHandler:@escaping (ZSQQLoginResponse?)->Void,
                        loginResultHandler:@escaping (Bool)->Void) {
        KeyWindow?.showProgress()
        let loginApi:ZSAPI = ZSAPI.login(idfa: idfa, platform_code: platform_code, platform_token: platform_token, platform_uid: platform_uid, version: version ,tag: tag)
        webService.QQLogin(url: loginApi.path, parameter: loginApi.parameters) { (json) in
            KeyWindow?.hideProgress()
            if let user = json {
                // 登录成功
                KeyWindow?.showTip(tip: "登录成功")
//                ZSLogin.share.token = self.userInfo?.token ?? ""
                ZSThirdLoginStorage.share.saveUserInfo(userInfo: user, type: .QQ)
                successHandler(user)
                loginResultHandler(true)
                
            } else {
                KeyWindow?.showTip(tip: "登录失败")
                successHandler(nil)
                loginResultHandler(false)
            }
        }
    }
}

@objcMembers
open class ZSThirdLoginStorage: NSObject {
    
    public var rawData:[String:Any] = [:]
    public var works:[Any] = []
    public var educations:[Any] = []
    public var level:CLongLong = 0
    public var regAt:Double = 0
    public var shareCount:CLongLong = 0
    public var friendCount:CLongLong = 0
    public var followerCount:CLongLong = 0
    public var birthday:Date?
    public var verifyReason:String = ""
    public var verifyType:CLongLong = 0
    public var aboutMe:String = ""
    public var url:String = ""
    public var gender:CLongLong = 0
    public var icon:String = ""
    public var nickname:String = ""
    public var uid:String = ""
    
    public var credential:SSDKCredential?
    public var data:SSDKQQData?
    public var platformType:CLongLong = 0
    
    // 只作为上次登录方式的记录,如果该登录方式的数据不存在,则应该将该值置为None
    public var lastLoginType:ThirdLoginType = .None
    
    public let ThirdLoginQQUserFilePathKey = "ThirdLoginQQUserFilePathKey"
    public let ThirdLoginWXTokenFilePathKey = "ThirdLoginWXTokenFilePathKey"
    public let ThirdLoginLastLoginTypeKey = "ThirdLoginLastLoginTypeKey"
    
    public static let share = ZSThirdLoginStorage()
    private override init() {
        super.init()
        
        let lastTypeObj = UserDefaults.standard.integer(forKey: ThirdLoginLastLoginTypeKey.md5())
        self.lastLoginType = ThirdLoginType(rawValue: lastTypeObj ) ?? .None
    }
    
    public func canHandle(pasteData:[String:Any]) -> Bool {
        if pasteData.allKeys().count > 0 {
            if pasteData.allKeys()[0].contains("tencent") {
                return true
            }
        }
        return false
    }
    
    public func handle(pasteData:[String:Data]) {
        for (key,value) in pasteData {
            if key.contains("tencent") {
                if let obj = NSKeyedUnarchiver.unarchiveObject(with: value) as? [String:Any] {
                    self.rawData = obj
                    self.data = SSDKQQData.deserialize(from: obj)
                    print(self.rawData)
                }
            }
        }
        
    }
    
    public func saveWXToken(wxTokenResp:ZSWXAccessTokenResp?) {
        if let resp = wxTokenResp {
            let TokenFilePath = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(ThirdLoginWXTokenFilePathKey.md5())"
            NSKeyedArchiver.archiveRootObject(resp, toFile: TokenFilePath)
        }
    }
    
    public func localUserInfo() -> ZSResponseModel {
        let filePath = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(ThirdLoginQQUserFilePathKey.md5())"
        let TokenFilePath = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(ThirdLoginWXTokenFilePathKey.md5())"
        let user = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? ZSQQLoginResponse
        let token = NSKeyedUnarchiver.unarchiveObject(withFile: TokenFilePath) as? ZSWXAccessTokenResp
        let respModel = ZSResponseModel()
        respModel.qqResp = user
        respModel.wxResp = token
        return respModel
    }
    
    public func resetLocalUserInfo() {
        let filePath = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(ThirdLoginQQUserFilePathKey.md5())"
        let TokenFilePath = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(ThirdLoginWXTokenFilePathKey.md5())"
        try? FileManager.default.removeItem(atPath: filePath)
        try? FileManager.default.removeItem(atPath: TokenFilePath)
    }
    
    public func saveUserInfo(userInfo:ZSQQLoginResponse, type:ThirdLoginType) {
        let filePath = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(ThirdLoginQQUserFilePathKey.md5())"
        NSKeyedArchiver.archiveRootObject(userInfo, toFile: filePath)
        
        switch type {
        case .QQ:
            UserDefaults.standard.setValue(ThirdLoginType.QQ.rawValue, forKey: ThirdLoginLastLoginTypeKey.md5())
            UserDefaults.standard.synchronize()
            break
        case .WX:
            // 要自己保存微信登录成功拿到的token信息
//            saveWXToken(wxTokenResp: ZSThirdLogin.share.wxTokenResp)
            UserDefaults.standard.setValue(ThirdLoginType.WX.rawValue, forKey: ThirdLoginLastLoginTypeKey.md5())
            UserDefaults.standard.synchronize()
            break
        case .WB:
            
            break
            
        case .None:
            break
        default:
            break
        }
    }
}

@objcMembers
public class ZSResponseModel: NSObject {
    public var qqResp:ZSQQLoginResponse?
    public var wxResp:ZSWXAccessTokenResp?
}

@objcMembers
public class SSDKCredential: NSObject {
    public var expirationDate:Date?
    public var openId:String = ""
    public var available:Bool = false
    public var rawData:[String:Any] = [:]
    public var expired:String = ""
    public var secret:String = ""
    public var token:String = ""
    public var uid:String = ""
    
}

@objcMembers
public class SSDKQQData: NSObject,HandyJSON {
    public var pf:String = ""
    public var pfkey:String = ""
    public var access_token:String = ""
    public var passDataResp:[Any] = []
    public var pay_token:String = ""
    public var msg:String = ""
    public var user_cancelled:Bool = false
    public var ret:Int = 0
    public var encrytoken:String = ""
    public var expires_in:TimeInterval = 7776000
    
    public required override init() {}
}

@objcMembers
public class ZSWXAccessTokenResp: NSObject ,HandyJSON, NSCoding{
    public var openid:String = ""
    public var scope:String = ""
    public var expires_in:Float = 0
    public var access_token:String = ""
    public var unionid:String = ""
    public var refresh_token:String = ""

    public required override init() {}

    public required init?(coder aDecoder: NSCoder) {
        aDecoder.decodeObject(forKey: "openid")
        aDecoder.decodeObject(forKey: "scope")
        aDecoder.decodeObject(forKey: "expires_in")
        aDecoder.decodeObject(forKey: "access_token")
        aDecoder.decodeObject(forKey: "unionid")
        aDecoder.decodeObject(forKey: "refresh_token")
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.openid, forKey: "openid")
        aCoder.encode(self.scope, forKey: "scope")
        aCoder.encode(self.expires_in, forKey: "expires_in")
        aCoder.encode(self.access_token, forKey: "access_token")
        aCoder.encode(self.unionid, forKey: "unionid")
        aCoder.encode(self.refresh_token, forKey: "refresh_token")
    }

}
