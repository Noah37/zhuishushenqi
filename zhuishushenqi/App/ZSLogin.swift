//
//  ZSLogin.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2018/10/20.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit

class ZSLogin: NSObject {
    
    var token:String = ""
    
    var lastLoginType = ZSThirdLoginStorage.share.lastLoginType
    
    static let share = ZSLogin()
    private override init() {
        super.init()
        
        self.token = ZSThirdLogin.share.userInfo?.token ?? ""
    }
    
    func hasLogin() ->Bool {
        if token != "" {
            return true
        }
        return false
    }
    
    func logout() {
        self.token = ""
        ZSThirdLoginStorage.share.resetLocalUserInfo()
        ZSThirdLogin.share.userInfo = nil
        ZSThirdLogin.share.wxTokenResp = nil
    }

}
