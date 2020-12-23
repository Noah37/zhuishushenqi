//
//  ZSLogin.swift
//  zhuishushenqi
//
//  Created by yung on 2018/10/20.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit
import ZSAPI

class ZSLogin {
    
    var token:String = ""
    
    var lastLoginType = ZSThirdLoginStorage.share.lastLoginType
    
    var mobileLogin:Bool = false
    
    // 登录用户的关注与被关注者
    var followings:[ZSFollowings]?
    var followers:[ZSFollowings]?
    
    static let share = ZSLogin()
    private init() {
        if let token =  ZSThirdLogin.share.userInfo?.token {
            self.token = token
        } else if let token = ZSMobileLogin.share.userInfo?.token {
            self.mobileLogin = true
            self.token = token
        }
        if self.token.count > 0 {
            fetchFollowings()
            fetchFollowers()
        }
    }
    
    func hasLogin() ->Bool {
        if token != "" {
            return true
        }
        return false
    }
    
    func userInfo() ->ZSQQLoginResponse? {
        if let userInfo = ZSThirdLogin.share.userInfo {
            return userInfo
        } else if let userInfo = ZSMobileLogin.share.userInfo {
            return userInfo
        }
        return nil
    }
    
    func logout() {
        self.token = ""
        ZSThirdLoginStorage.share.resetLocalUserInfo()
        ZSThirdLogin.share.userInfo = nil
        ZSThirdLogin.share.wxTokenResp = nil
    }

    func login() {
        
    }
    
    
    func fetchFollowings() {
        let api = ZSAPI.userFollowings("\(self.userInfo()?.user?._id ?? "")")
        zs_get(api.path) { (json) in
            guard let followings = json?["followings"] as? [Any] else {
                return
            }
            if let followingModels = [ZSFollowings].deserialize(from: followings) as? [ZSFollowings] {
                self.followings = followingModels
            }
        }
    }
    
    func fetchFollowers() {
        let api = ZSAPI.userFollowers("\(self.userInfo()?.user?._id ?? "")")
        zs_get(api.path) { (json) in
            guard let followers = json?["followers"] as? [Any] else {
                return
            }
            if let followingModels = [ZSFollowings].deserialize(from: followers) as? [ZSFollowings] {
                self.followers = followingModels
            }
        }
    }
}
