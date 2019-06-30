//
//  ZSMyService.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2018/10/20.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit
import ZSAPI

class ZSMyService {
    
    func fetchAccount(token:String ,completion:@escaping ZSBaseCallback<ZSAccount>) {
        let api = ZSAPI.account(token: token)
        //        https://api.zhuishushenqi.com/user/account?token=MR7bHBNojupotkWO0IH1QZY0
        zs_get(api.path, parameters: api.parameters) { (json) in
            if let account = ZSAccount.deserialize(from: json) {
                completion(account)
            } else {
                completion(nil)
            }
        }
    }
    
    func fetchCoin(token:String, completion:@escaping ZSBaseCallback<ZSCoin>) {
        //        http://goldcoin.zhuishushenqi.com/account?token=MR7bHBNojupotkWO0IH1QZY0
        let api = ZSAPI.golden(token: token)
        zs_get(api.path, parameters: api.parameters) { (json) in
            let coin = ZSCoin.deserialize(from: json)
            completion(coin)
        }
    }
    
    func fetchDetail(token:String, completion:@escaping ZSBaseCallback<ZSUserDetail>) {
//        https://api.zhuishushenqi.com/user/detail-info?token=MR7bHBNojupotkWO0IH1QZY0
        let api = ZSAPI.userDetail(token: token)
        zs_get(api.path, parameters: api.parameters) { (json) in
            let detail = ZSUserDetail.deserialize(from: json)
            completion(detail)
        }
    }
    
    func fetchUserBind (token:String, completion:@escaping ZSBaseCallback<ZSUserBind>) {
//        https://api.zhuishushenqi.com/user/loginBind?token=MR7bHBNojupotkWO0IH1QZY0
        let api = ZSAPI.userBind(token: token)
        zs_get(api.path, parameters: api.parameters) { (json) in
            let bind = ZSUserBind.deserialize(from: json)
            completion(bind)
        }
    }
    
    func fetchLogout(token:String, completion:@escaping ZSBaseCallback<[String:Any]>) {
//        https://api.zhuishushenqi.com/user/logout
        let api = ZSAPI.logout(token: token)
        zs_post(api.path, parameters: api.parameters) { (json) in
//            let books = [ZSUserBookshelf].deserialize(from: json?["books"] as? [Any]) as? [String:Any]
            completion(json)
        }
    }
    
    func fetchNicknameChange(url:String, param:[String:Any]?, completion:@escaping ZSBaseCallback<[String:Any]>) {
        zs_post(url, parameters: param) { (json) in
            completion(json)
        }
    }
    
    func fetchVoucherList(url:String, param:[String:Any]?, completion:@escaping ZSBaseCallback<[ZSVoucher]>) {
        zs_get(url, parameters: param) { (json) in
            if let vouchers = json?["vouchers"] as? [[String:Any]] {
                if let voucherModels = [ZSVoucher].deserialize(from: vouchers) as? [ZSVoucher] {
                    completion(voucherModels)
                }
            } else {
                completion([])
            }
        }
    }

}
