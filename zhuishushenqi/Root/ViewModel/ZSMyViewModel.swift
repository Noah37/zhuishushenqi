//
//  ZSMyViewModel.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2018/10/20.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit

class ZSMyViewModel: NSObject {
    
    let webService = ZSMyService()
    
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
}
