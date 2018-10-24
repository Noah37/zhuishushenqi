//
//  ZSThirdLoginView.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2018/10/23.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit

typealias ZSThirdLoginHandler = (_ type:ThirdLoginType)->Void
typealias ZSThirdLoginCloseHandler = ()->Void

class ZSThirdLoginView: UIView {
    
    var leftLineLabel:UILabel!
    var rightLineLabel:UILabel!
    var loginTypeLabel:UILabel!
    var qqLoginButton:UIButton!
    var wxLoginButton:UIButton!
    var wbLoginButton:UIButton!
    var xmLoginButton:UIButton!
    var userProtocolButton:UIButton!
    var closeButton:UIButton!
    
    var thirdLoginHandler:ZSThirdLoginHandler?
    var closeHandler:ZSThirdLoginCloseHandler?
    var userProtocolHandler:ZSThirdLoginCloseHandler?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        leftLineLabel = UILabel(frame: CGRect(x: 40, y: 115, width: 100, height: 0.5))
        leftLineLabel.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.7)
        addSubview(leftLineLabel)

        rightLineLabel = UILabel(frame: CGRect(x: self.bounds.width - 140, y: 115, width: 100, height: 0.5))
        rightLineLabel.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.7)
        addSubview(rightLineLabel)
        
        loginTypeLabel = UILabel(frame: CGRect(x: 0, y: 100, width: 200, height: 30))
        loginTypeLabel.text = "选择登录方式"
        loginTypeLabel.textColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.7)
        loginTypeLabel.font = UIFont.systemFont(ofSize: 11)
        loginTypeLabel.textAlignment = .center
        loginTypeLabel.centerX = self.centerX
        addSubview(loginTypeLabel)
        
        let buttonWidth:CGFloat = 40
        let buttonHeight:CGFloat = 40
        let marginSpace:CGFloat = 40
        let marginTopSpace:CGFloat = 20

        let centerSpace = (self.bounds.width - marginSpace*2 - 4*buttonWidth)/3
        
        qqLoginButton = UIButton(type: .custom)

        qqLoginButton.frame = CGRect(x: marginSpace, y: self.loginTypeLabel.frame.maxY + marginTopSpace, width: buttonWidth, height: buttonHeight)
        qqLoginButton.setImage(UIImage(named: "nl_qq"), for: .normal)
        qqLoginButton.addTarget(self, action: #selector(qqLoginAction(btn:)), for: .touchUpInside)
        addSubview(qqLoginButton)

        
        wxLoginButton = UIButton(type: .custom)
        wxLoginButton.frame = CGRect(x: marginSpace + buttonWidth + centerSpace, y: self.loginTypeLabel.frame.maxY + marginTopSpace, width: buttonWidth, height: buttonHeight)
        wxLoginButton.setImage(UIImage(named: "nl_wechat"), for: .normal)
        wxLoginButton.addTarget(self, action: #selector(wxLoginAction(btn:)), for: .touchUpInside)
        addSubview(wxLoginButton)

        
        wbLoginButton = UIButton(type: .custom)
        wbLoginButton.frame = CGRect(x: marginSpace + buttonWidth*2 + centerSpace*2, y: self.loginTypeLabel.frame.maxY + marginTopSpace, width: buttonWidth, height: buttonHeight)
        wbLoginButton.setImage(UIImage(named: "nl_weibo"), for: .normal)
        wbLoginButton.addTarget(self, action: #selector(wbLoginAction(btn:)), for: .touchUpInside)
        addSubview(wbLoginButton)

        
        xmLoginButton = UIButton(type: .custom)
        xmLoginButton.frame = CGRect(x: marginSpace + buttonWidth*3 + centerSpace*3, y: self.loginTypeLabel.frame.maxY + marginTopSpace, width: buttonWidth, height: buttonHeight)
        xmLoginButton.setImage(UIImage(named: "nl_xiaomi"), for: .normal)
        xmLoginButton.addTarget(self, action: #selector(xmLoginAction(btn:)), for: .touchUpInside)
        addSubview(xmLoginButton)
        
        userProtocolButton = UIButton(type: .custom)
        userProtocolButton.frame = CGRect(x: 0, y: xmLoginButton.frame.maxY + marginTopSpace, width: self.bounds.width, height: 30)
        userProtocolButton.centerX = self.centerX
        userProtocolButton.setTitle("点击登录即代表同意追书神器《用户协议》", for: .normal)
        userProtocolButton.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        userProtocolButton.setTitleColor(UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.7), for: .normal)
        userProtocolButton.addTarget(self, action: #selector(userProtocolLoginAction(btn:)), for: .touchUpInside)
        addSubview(userProtocolButton)
        
        closeButton = UIButton(type: .custom)
        closeButton.frame = CGRect(x: 0, y: self.userProtocolButton.frame.maxY + 40, width: 60, height: 30)
        closeButton.setTitle("关闭>", for: .normal)
        closeButton.setTitleColor(UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.7), for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        closeButton.centerX = self.centerX
        closeButton.addTarget(self, action: #selector(closeLoginAction(btn:)), for: .touchUpInside)
        addSubview(closeButton)

    }
    
    @objc
    private func qqLoginAction(btn:UIButton) {
        thirdLoginHandler?(ThirdLoginType.QQ)
    }
    
    @objc
    private func wxLoginAction(btn:UIButton) {
        thirdLoginHandler?(ThirdLoginType.WX)
    }
    
    @objc
    private func wbLoginAction(btn:UIButton) {
        thirdLoginHandler?(ThirdLoginType.WB)
    }
    
    @objc
    private func xmLoginAction(btn:UIButton) {
        thirdLoginHandler?(ThirdLoginType.XM)

    }
    
    @objc
    private func closeLoginAction(btn:UIButton) {
        closeHandler?()
    }
    
    @objc
    private func userProtocolLoginAction(btn:UIButton) {
        userProtocolHandler?()
    }

}
