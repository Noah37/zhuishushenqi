//
//  ZSLoginViewController.swift
//  zhuishushenqi
//
//  Created by caony on 2018/10/22.
//  Copyright © 2018 QS. All rights reserved.
//

import UIKit
import SafariServices

typealias ZSLoginVCBackHandler = ()->Void
typealias ZSLoginVCResultHandler = (_ success:Bool)->Void

let LoginSuccess = "LoginSuccess"

class ZSLoginViewController: BaseViewController {
    
    lazy var phoneImageView:UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 100, width: 40, height: 74))
        imageView.image = UIImage(named: "artboard")
        return imageView
    }()
    
    lazy var loginView:ZSLoginView = {
        let loginView = ZSLoginView(frame: CGRect(x: 0, y: self.phoneImageView.frame.maxY + 50, width: self.view.bounds.width, height: 190))
        return loginView
    }()
    
    lazy var thirdLoginView:ZSThirdLoginView = {
        let thirdLoginView = ZSThirdLoginView(frame: CGRect(x: 0, y: self.loginView.frame.maxY, width: self.view.bounds.width, height: 320))
        return thirdLoginView
    }()
    
    var loginVerifyView:ZSLoginVerifyView!
    
    let viewModel = ZSMyViewModel()
    
    var backHandler:ZSLoginVCBackHandler?
    
    var loginResultHandler:ZSLoginVCResultHandler?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.thirdLoginView.thirdLoginHandler = { type in
            self.thirdLogin(type: type)
        }
        self.thirdLoginView.closeHandler = {
            self.closeLoginView()
        }
        self.thirdLoginView.userProtocolHandler = {
            self.userProtocolAction()
        }
        self.loginView.getSMSCodeHandler = {
            self.getSMSCodeVerify()
        }
        self.loginView.loginHandler = {
            self.login()
        }
        self.phoneImageView.centerX = self.view.centerX
        self.view.addSubview(self.phoneImageView)
        self.view.addSubview(self.loginView)
        self.view.addSubview(self.thirdLoginView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)

    }
    
    override func popAction() {
        backHandler?()
        super.popAction()
    }
    
    private func closeLoginView() {
        backHandler?()
        self.dismiss(animated: true, completion: nil)
    }
    
    private func userProtocolAction() {
        if let url = URL(string: "") {
            let safariVC = SFSafariViewController(url: url)
            self.present(safariVC, animated: true, completion: nil)
        }
    }

    private func thirdLogin(type:ThirdLoginType) {
        switch type {
        case .QQ:
            ZSThirdLogin.share.loginResultHandler = { success in
                self.loginResultHandle(success: success, type: .QQ)
            }
            ZSThirdLogin.share.QQAuth()
            break
        case .WX:
            ZSThirdLogin.share.loginResultHandler = { success in
                self.loginResultHandle(success: success, type: .WX)
            }
            ZSThirdLogin.share.WXAuth()
            break
        case .WB:
            ZSThirdLogin.share.loginResultHandler = { success in
                self.loginResultHandle(success: success, type: .WB)
            }
            ZSThirdLogin.share.WBAuth()
            break
        case .XM:
            self.view.showTip(tip: "尚未支持此种登录方式")
            break
        default:
            
            break
        }
    }
    
    private func getSMSCode(param:[String:String]) {
        viewModel.fetchSMSCode(param: param) { (json) in
            if json?["ok"] as? Bool == true {
                // 获取验证码成功,开始计时
                self.loginView.fire()
                self.loginVerifyView.removeFromSuperview()
            } else {
                self.loginVerifyView.removeFromSuperview()
            }
        }
    }
    
    private func getSMSCodeVerify() {
        let mobile = self.loginView.phoneNumber()
        var errorMsg = ""
        if mobile.lengthOfBytes(using: .utf8) == 0 {
            errorMsg = "请输入手机号"
        } else if mobile.lengthOfBytes(using: .utf8) != 11 {
            errorMsg = "手机号输入错误"
        }
        if errorMsg != "" {
            self.view.showTip(tip: errorMsg)
            return
        }
        ZSMobileLogin.share.mobile = mobile
        
        loginVerifyView = ZSLoginVerifyView(frame: self.view.bounds)
        loginVerifyView.resultHandler = { (ret, param) in
            if ret == 0 {
                self.getSMSCode(param: param)
            } else {
                self.view.showTip(tip: "验证失败")
            }
        }
        self.view.addSubview(loginVerifyView)
        let html = ZSMobileLogin.share.startVerifyHTML()
        loginVerifyView.startVerify(str: html)
    }
    
    private func login() {
        let mobile = self.loginView.phoneNumber()
        let smsCode = self.loginView.smsCodeText()
        var errorMsg = ""
        if mobile.lengthOfBytes(using: .utf8) == 0 {
            errorMsg = "请输入手机号"
        } else if mobile.lengthOfBytes(using: .utf8) != 11 {
            errorMsg = "请输入一个正确的手机号"
        } else if smsCode.lengthOfBytes(using: .utf8) == 0 {
            errorMsg = "请输入验证码"
        } else if smsCode.lengthOfBytes(using: .utf8) != 4 {
            errorMsg = "请输入一个正确的验证码"
        }
        if errorMsg != "" {
            self.view.showTip(tip: errorMsg)
            return
        }
        self.view.showProgress()
        viewModel.mobileLogin(mobile: mobile, smsCode: smsCode) { (json) in
            self.view.hideProgress()
            if let user = json {
                if user.ok == true {
                    ZSMobileLogin.share.userInfo = user
                    self.view.showTip(tip: "登录成功")
                    NotificationCenter.qs_postNotification(name: LoginSuccess, obj: nil)
                    ZSLogin.share.token = ZSMobileLogin.share.userInfo?.token ?? ""
                    ZSThirdLoginStorage.share.saveUserInfo(userInfo: user, type: .WX)
                    self.backHandler?()
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.view.showTip(tip: user.code)
                }
            }
        }
    }
    
    private func loginResultHandle(success:Bool,type:ThirdLoginType) {
        
        loginResultHandler?(success)
        if success {
            //
            backHandler?()
            self.dismiss(animated: true, completion: nil)
        } else {
            // 登录失败
            self.view.showTip(tip: "登录失败,请稍后再试")
        }
    }
}
