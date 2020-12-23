//
//  ZSThirdLogin.swift
//  zhuishushenqi
//
//  Created by yung on 2018/10/19.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit
import HandyJSON
import AdSupport
import ZSAPI

typealias ZSThirdLoginResultHandler = (_ success:Bool)->Void

enum ThirdLoginType:String {
    case None = "None"
    case WX = "WX"
    case QQ = "QQ"
    case WB = "WB"
    case XM = "XM"
}

typealias ZSLoginSuccess = ()->Void

class ZSThirdLogin: NSObject {
    
    var tencentOAuth:TencentOAuth!
    
    var webService:ZSLoginService = ZSLoginService()
    
    var userInfo:ZSQQLoginResponse?
    
    var wxTokenResp:ZSWXAccessTokenResp?
    
    var wbAuthorizeResp:WBAuthorizeResponse?
    
    var successHandler:ZSLoginSuccess?
    
    var loginResultHandler:ZSThirdLoginResultHandler?
    
    var permissions = ["get_user_info","get_simple_userinfo","add_t"]
    
    let wxAuthScope = "snsapi_userinfo,snsapi_friend,snsapi_contact,snsapi_message"
    
    static let QQAppID = "100497199"
    
    static let WXAppID = "wxaf0fdeed6872dfcf"
    
    static let WXAppSecret = "0464c67bdd87c303c5bfdc5761beb329"
    
    static let WBAppID = "2023668704"
    
    static let WBAppSecret = "26efa7a6a6bed540092c9535bda75db9"
    
    static let WBRedirectURI = "http://ushaqi.com"
    
    static let share = ZSThirdLogin()
    private override init() {
        super.init()
        tencentOAuth = TencentOAuth(appId: ZSThirdLogin.QQAppID, andDelegate: self)
        let (user,token) = ZSThirdLoginStorage.share.localUserInfo()
        self.userInfo = user
        self.wxTokenResp = token
    }
    
    func QQAuth() {
        tencentOAuth.authorize(permissions, inSafari: false)
    }
    
    func WXAuth() {
        WXApi.registerApp(ZSThirdLogin.WXAppID)
        WXApiRequestHandler.share.sendWXAuth(scope: wxAuthScope, state: "YouShaQi")
    }
    
    func WBAuth() {
        let request = WBAuthorizeRequest()
        request.redirectURI = ZSThirdLogin.WBRedirectURI
        request.scope = "all"
        WeiboSDK.send(request)
    }
    
    func login(type:ThirdLoginType) {
        switch type {
        case .QQ:
            // QQ登录
            QQLogin()
            break
        case .WX:
            // 微信登录
            WXLogin()
            break
        case .WB:
            // 微博登录
            WBLogin()
            break
        default:
            break
        }
    }
    
    func refreshWXToken() {
//        https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=APPID&grant_type=refresh_token&refresh_token=REFRESH_TOKEN
        // 一般第一次获取到access_token后直接登录追书d,获取token,后面基本不需要access_token了
        
    }
    
    private func QQLogin() {
        let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        let platform_code = "QQ"
        let platform_token = tencentOAuth.accessToken ?? ""
        let platform_uid = tencentOAuth.openId ?? ""
        let version = "2"
        KeyWindow?.showProgress()
        let loginApi:ZSAPI = ZSAPI.login(idfa: idfa, platform_code: platform_code, platform_token: platform_token, platform_uid: platform_uid, version: version ,tag: "")
        webService.QQLogin(url: loginApi.path, parameter: loginApi.parameters) { (json) in
            KeyWindow?.hideProgress()
            if let user = json {
                // 登录成功
                KeyWindow?.showTip(tip: "登录成功")
                self.userInfo = user
                ZSLogin.share.token = self.userInfo?.token ?? ""
                ZSThirdLoginStorage.share.saveUserInfo(userInfo: user, type: .QQ)
                self.successHandler?()
                self.loginResultHandler?(true)

            } else {
                KeyWindow?.showTip(tip: "登录失败")
                self.userInfo = nil
                self.loginResultHandler?(false)
            }
        }
    }
    
    private func WXLogin() {
        if let resp = self.wxTokenResp {
            let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
            let platform_code = "WeixinNew"
            let platform_token = resp.access_token
            let platform_uid = resp.openid
            let version = "2"
            let tag = "zssq"
            KeyWindow?.showProgress()
            let loginApi = ZSAPI.login(idfa: idfa, platform_code: platform_code, platform_token: platform_token, platform_uid: platform_uid, version: version, tag: tag)
            webService.WXLogin(url: loginApi.path, parameter: loginApi.parameters) { (json) in
                KeyWindow?.hideProgress()
                if let user = json {
                    // 登录成功
                    KeyWindow?.showTip(tip: "登录成功")
                    self.userInfo = user
                    ZSLogin.share.token = self.userInfo?.token ?? ""
                    ZSThirdLoginStorage.share.saveUserInfo(userInfo: user, type: .WX)
                    self.successHandler?()
                    self.loginResultHandler?(true)
                } else {
                    KeyWindow?.showTip(tip: "登录失败")
                    self.userInfo = nil
                    self.loginResultHandler?(false)
                }
            }
        }
    }
    
    private func WBLogin() {
        if let resp = self.wbAuthorizeResp {
            let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
            let platform_code = "SinaWeibo"
            let platform_token = resp.accessToken ?? ""
            let platform_uid = resp.userID ?? ""
            let version = "2"
            let tag = "zssq"
            KeyWindow?.showProgress()
            let loginApi = ZSAPI.login(idfa: idfa, platform_code: platform_code, platform_token: platform_token, platform_uid: platform_uid, version: version, tag: tag)
            webService.WBLogin(url: loginApi.path, parameter: loginApi.parameters) { (json) in
                KeyWindow?.hideProgress()
                if let user = json, let _ = json?.token  {
                    // 登录成功
                    KeyWindow?.showTip(tip: "登录成功")
                    self.userInfo = user
                    ZSLogin.share.token = self.userInfo?.token ?? ""
                    ZSThirdLoginStorage.share.saveUserInfo(userInfo: user, type: .WX)
                    self.successHandler?()
                    self.loginResultHandler?(true)
                } else {
                    KeyWindow?.showTip(tip: "登录失败")
                    self.userInfo = nil
                    self.loginResultHandler?(false)
                }
            }
        }
    }
}

extension ZSThirdLogin:WeiboSDKDelegate {
    func didReceiveWeiboRequest(_ request: WBBaseRequest!) {
        
    }
    
    func didReceiveWeiboResponse(_ response: WBBaseResponse!) {
        if let authorize = response as? WBAuthorizeResponse {
            self.wbAuthorizeResp = authorize
            login(type: .WB)
        }
    }
    
}


extension ZSThirdLogin:QQApiInterfaceDelegate {
    func onReq(_ req: QQBaseReq!) {
        
    }
    
    func onResp(_ resp: QQBaseResp!) {
        
    }
    
    func isOnlineResponse(_ response: [AnyHashable : Any]!) {
        
    }
    
}

extension ZSThirdLogin:TencentSessionDelegate {
    func tencentDidLogin() {
        self.login(type: .QQ)
    }
    
    func tencentDidNotLogin(_ cancelled: Bool) {
        if cancelled {
            KeyWindow?.showTip(tip: "用户取消了操作")
        }
    }
    
    func tencentDidNotNetWork() {
        KeyWindow?.showTip(tip: "网络连接失败")
    }
}

class WXApiRequestHandler: NSObject,WXApiDelegate {
    
    static let share = WXApiRequestHandler()
    private override init() {}
    
    @discardableResult
    func sendWXAuthRequestScope(scope:String, state:String, inViewController:UIViewController) -> Bool {
        let req = SendAuthReq()
        req.scope = scope
        req.state = state
        return WXApi.sendAuthReq(req, viewController: inViewController, delegate: self)
    }
    
    @discardableResult
    func sendWXAuth(scope:String,state:String) -> Bool {
        let req = SendAuthReq()
        req.scope = scope
        req.state = state
        return WXApi.send(req)
    }
    
    func onReq(_ req: BaseReq!) {
        
    }
    
    func onResp(_ resp: BaseResp!) {
        if let res = resp as? SendAuthResp {
            print(res)
            if res.errCode == 0 {
                // 获取code成功
                let code = res.code
                let getAccessTokenUrl = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=\(ZSThirdLogin.WXAppID)&secret=\(ZSThirdLogin.WXAppSecret)&code=\(code ?? "")&grant_type=authorization_code"
                zs_get(getAccessTokenUrl, parameters: nil) { (json) in
                    let tokenResp = ZSWXAccessTokenResp.deserialize(from: json)
                    ZSThirdLoginStorage.share.saveWXToken(wxTokenResp: tokenResp)
                    ZSThirdLogin.share.login(type: .WX)
                }
            } else {
                KeyWindow?.showTip(tip: "请求Code出错")
            }
        }
    }
    
}

class ZSThirdLoginStorage: NSObject {
    
    var rawData:[String:Any] = [:]
    var works:[Any] = []
    var educations:[Any] = []
    var level:CLongLong = 0
    var regAt:Double = 0
    var shareCount:CLongLong = 0
    var friendCount:CLongLong = 0
    var followerCount:CLongLong = 0
    var birthday:Date?
    var verifyReason:String = ""
    var verifyType:CLongLong = 0
    var aboutMe:String = ""
    var url:String = ""
    var gender:CLongLong = 0
    var icon:String = ""
    var nickname:String = ""
    var uid:String = ""

    var credential:SSDKCredential?
    var data:SSDKQQData?
    var platformType:CLongLong = 0
    
    // 只作为上次登录方式的记录,如果该登录方式的数据不存在,则应该将该值置为None
    var lastLoginType:ThirdLoginType = .None
    
    let ThirdLoginQQUserFilePathKey = "ThirdLoginQQUserFilePathKey"
    let ThirdLoginWXTokenFilePathKey = "ThirdLoginWXTokenFilePathKey"
    let ThirdLoginLastLoginTypeKey = "ThirdLoginLastLoginTypeKey"
    
    static let share = ZSThirdLoginStorage()
    private override init() {
        super.init()
        
        let lastTypeObj = UserDefaults.standard.string(forKey: ThirdLoginLastLoginTypeKey.md5())
        self.lastLoginType = ThirdLoginType(rawValue: lastTypeObj ?? "") ?? .None
    }
    
    func canHandle(pasteData:[String:Any]) -> Bool {
        if pasteData.allKeys().count > 0 {
            if pasteData.allKeys()[0].contains("tencent") {
                return true
            }
        }
        return false
    }
    
    func handle(pasteData:[String:Data]) {
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
    
    func saveWXToken(wxTokenResp:ZSWXAccessTokenResp?) {
        if let resp = wxTokenResp {
            let TokenFilePath = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(ThirdLoginWXTokenFilePathKey.md5())"
            NSKeyedArchiver.archiveRootObject(resp, toFile: TokenFilePath)
        }
    }
    
    func localUserInfo() -> (ZSQQLoginResponse?,ZSWXAccessTokenResp?) {
        let filePath = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(ThirdLoginQQUserFilePathKey.md5())"
        let TokenFilePath = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(ThirdLoginWXTokenFilePathKey.md5())"
        let user = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? ZSQQLoginResponse
        let token = NSKeyedUnarchiver.unarchiveObject(withFile: TokenFilePath) as? ZSWXAccessTokenResp
        return (user,token)
    }
    
    func resetLocalUserInfo() {
        let filePath = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(ThirdLoginQQUserFilePathKey.md5())"
        let TokenFilePath = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(ThirdLoginWXTokenFilePathKey.md5())"
        try? FileManager.default.removeItem(atPath: filePath)
        try? FileManager.default.removeItem(atPath: TokenFilePath)
    }
    
    func saveUserInfo(userInfo:ZSQQLoginResponse, type:ThirdLoginType) {
        let filePath = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(ThirdLoginQQUserFilePathKey.md5())"
        NSKeyedArchiver.archiveRootObject(userInfo, toFile: filePath)
        
        switch type {
        case .QQ:
            UserDefaults.standard.setValue(ThirdLoginType.QQ.rawValue, forKey: ThirdLoginLastLoginTypeKey.md5())
            UserDefaults.standard.synchronize()
            break
        case .WX:
            // 要自己保存微信登录成功拿到的token信息
            saveWXToken(wxTokenResp: ZSThirdLogin.share.wxTokenResp)
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

class SSDKCredential {
    var expirationDate:Date?
    var openId:String = ""
    var available:Bool = false
    var rawData:[String:Any] = [:]
    var expired:String = ""
    var secret:String = ""
    var token:String = ""
    var uid:String = ""

}

class SSDKQQData:HandyJSON {
    var pf:String = ""
    var pfkey:String = ""
    var access_token:String = ""
    var passDataResp:[Any] = []
    var pay_token:String = ""
    var msg:String = ""
    var user_cancelled:Bool = false
    var ret:Int = 0
    var encrytoken:String = ""
    var expires_in:TimeInterval = 7776000
    
    required init() {}
}

class ZSWXAccessTokenResp: HandyJSON, NSCoding{
    var openid:String = ""
    var scope:String = ""
    var expires_in:Float = 0
    var access_token:String = ""
    var unionid:String = ""
    var refresh_token:String = ""
    
    required init() {}
    
    required init?(coder aDecoder: NSCoder) {
        aDecoder.decodeObject(forKey: "openid")
        aDecoder.decodeObject(forKey: "scope")
        aDecoder.decodeObject(forKey: "expires_in")
        aDecoder.decodeObject(forKey: "access_token")
        aDecoder.decodeObject(forKey: "unionid")
        aDecoder.decodeObject(forKey: "refresh_token")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.openid, forKey: "openid")
        aCoder.encode(self.scope, forKey: "scope")
        aCoder.encode(self.expires_in, forKey: "expires_in")
        aCoder.encode(self.access_token, forKey: "access_token")
        aCoder.encode(self.unionid, forKey: "unionid")
        aCoder.encode(self.refresh_token, forKey: "refresh_token")
    }

}

