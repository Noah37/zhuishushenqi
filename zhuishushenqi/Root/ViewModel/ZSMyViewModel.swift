//
//  ZSMyViewModel.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2018/10/20.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit
import AdSupport
import ZSAPI

class ZSMyViewModel: NSObject {
    
    let webService = ZSMyService()
    
    let loginService = ZSLoginService()
    
    var account:ZSAccount?
    
    var coin:ZSCoin?
    
    var detail:ZSUserDetail?
    
    var bind:ZSUserBind?
    
    func fetchAccount(token:String ,completion:@escaping ZSBaseCallback<ZSAccount>) {
        webService.fetchAccount(token: token) { (account) in
            self.account = account
            completion(account)
        }
    }

    func fetchCoin(token:String, completion:@escaping ZSBaseCallback<ZSCoin>) {
        webService.fetchCoin(token: token) { (coin) in
            self.coin = coin
            completion(coin)
        }
    }
    
    func fetchDetail(token:String, completion:@escaping ZSBaseCallback<ZSUserDetail>) {
        webService.fetchDetail(token: token) { (detail) in
            self.detail = detail
            completion(detail)
        }
    }
    
    func fetchUserBind (token:String, completion:@escaping ZSBaseCallback<ZSUserBind>) {
        webService.fetchUserBind(token: token) { (bind) in
            self.bind = bind
            completion(bind)
        }
    }
    
    func fetchLogout(token:String, completion:@escaping ZSBaseCallback<[String:Any]>) {
        webService.fetchLogout(token: token) { (json) in
            completion(json)
        }
    }
    
    func fetchSMSCode(param:[String:String]?, completion:@escaping ZSBaseCallback<[String:Any]>) {
        let mobile = param?["mobile"] ?? ""
        let randstr = param?["Randstr"] ?? ""
        let ticket = param?["Ticket"] ?? ""
        let captchaType = param?["captchaType"] ?? ""
        let type = param?["type"] ?? ""
        let api = ZSAPI.SMSCode(mobile: mobile, Randstr: randstr, Ticket: ticket, captchaType: captchaType, type: type)
        loginService.fetchSMSCode(url: api.path, parameter: api.parameters) { (json) in
            completion(json)
        }
    }
    
    func mobileLogin(mobile:String, smsCode:String, completion:@escaping ZSBaseCallback<ZSQQLoginResponse>) {
        let version = "2"
        let platform_code = "mobile"
        let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        let api = ZSAPI.mobileLogin(mobile: mobile, idfa: idfa, platform_code: platform_code, smsCode: smsCode, version: version)
        loginService.mobileLgin(urlString: api.path, param: api.parameters) { (json) in
            completion(json)
        }
    }
    
    func fetchNicknameChange(nickname:String, token:String, completion:@escaping ZSBaseCallback<[String:Any]>) {
        let api = ZSAPI.nicknameChange(nickname: nickname, token: token)
        webService.fetchNicknameChange(url: api.path, param: api.parameters) { (json) in
            completion(json)
        }
    }
}
