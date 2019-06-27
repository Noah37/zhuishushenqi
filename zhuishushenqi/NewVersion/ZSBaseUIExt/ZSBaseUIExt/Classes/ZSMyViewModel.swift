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
import RxSwift
import ZSExtension
import ZSThirdPartSDK

public class ZSMyViewModel: NSObject, ZSRefreshProtocol {
    
    public var refreshStatus: Variable<ZSRefreshStatus> = Variable(.none)
    
    let webService = ZSMyService()
    
    let loginService = ZSLoginService()
    
    public var account:ZSAccount?
    
    public var coin:ZSCoin?
    
    public var detail:ZSUserDetail?
    
    public var bind:ZSUserBind?
    
    public var useableVoucher:[ZSVoucher] = []
    public var unuseableVoucher:[ZSVoucher] = []
    public var expiredVoucher:[ZSVoucher] = []
    
    public func fetchAccount(token:String ,completion:@escaping ZSBaseCallback<ZSAccount>) {
        webService.fetchAccount(token: token) { (account) in
            self.account = account
            completion(account)
        }
    }

    public func fetchCoin(token:String, completion:@escaping ZSBaseCallback<ZSCoin>) {
        webService.fetchCoin(token: token) { (coin) in
            self.coin = coin
            completion(coin)
        }
    }
    
    public func fetchDetail(token:String, completion:@escaping ZSBaseCallback<ZSUserDetail>) {
        webService.fetchDetail(token: token) { (detail) in
            self.detail = detail
            completion(detail)
        }
    }
    
    public func fetchUserBind (token:String, completion:@escaping ZSBaseCallback<ZSUserBind>) {
        webService.fetchUserBind(token: token) { (bind) in
            self.bind = bind
            completion(bind)
        }
    }
    
    public func fetchLogout(token:String, completion:@escaping ZSBaseCallback<[String:Any]>) {
        webService.fetchLogout(token: token) { (json) in
            completion(json)
        }
    }
    
    public func fetchSMSCode(param:[String:String]?, completion:@escaping ZSBaseCallback<[String:Any]>) {
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
    
    public func mobileLogin(mobile:String, smsCode:String, completion:@escaping ZSBaseCallback<ZSQQLoginResponse>) {
        let version = "2"
        let platform_code = "mobile"
        let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        let api = ZSAPI.mobileLogin(mobile: mobile, idfa: idfa, platform_code: platform_code, smsCode: smsCode, version: version)
        loginService.mobileLgin(urlString: api.path, param: api.parameters) { (json) in
            completion(json)
        }
    }
    
    public func fetchNicknameChange(nickname:String, token:String, completion:@escaping ZSBaseCallback<[String:Any]>) {
        let api = ZSAPI.nicknameChange(nickname: nickname, token: token)
        webService.fetchNicknameChange(url: api.path, param: api.parameters) { (json) in
            completion(json)
        }
    }
    
//    https://api.zhuishushenqi.com/voucher?token=xAk9Ac8k3Jj9Faf11q8mBVPQ&type=useable&start=0&limit=20
    public func fetchVoucher(token:String, type:String, start:Int, limit:Int, completion:@escaping ZSBaseCallback<[ZSVoucher]>) {
        let api = ZSAPI.voucherList(token: token, type: type, start: start, limit: limit)
        webService.fetchVoucherList(url: api.path, param: api.parameters) { (vouchers) in
            if type == "useable" {
                self.useableVoucher = vouchers ?? []
            } else if type == "unuseable" {
                self.unuseableVoucher = vouchers ?? []
            } else {
                self.expiredVoucher = vouchers ?? []
            }
            self.refreshStatus.value = .headerRefreshEnd
            completion(vouchers)
        }
    }
    
    public func fetchMoreVoucher(token:String, type:String, start:Int, limit:Int, completion:@escaping ZSBaseCallback<[ZSVoucher]>) {
        let api = ZSAPI.voucherList(token: token, type: type, start: start, limit: limit)
        webService.fetchVoucherList(url: api.path, param: api.parameters) { (vouchers) in
            if type == "useable" {
                self.useableVoucher.append(contentsOf: vouchers ?? [])
            } else if type == "unuseable" {
                self.unuseableVoucher.append(contentsOf: vouchers ?? [])
            } else {
                self.expiredVoucher.append(contentsOf: vouchers ?? [])
            }
            self.refreshStatus.value = .footerRefreshEnd
            completion(vouchers)
        }
    }
    
}
