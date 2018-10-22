//
//  ZSLoginView.swift
//  zhuishushenqi
//
//  Created by caony on 2018/10/22.
//  Copyright © 2018 QS. All rights reserved.
//

import UIKit

class ZSLoginView: UIView {
    
    var phoneNumTextField:UITextField!
    var verifyNumTextField:UITextField!
    var loginButon:UIButton!
    var genCaptchaButton:UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        phoneNumTextField = UITextField(frame: CGRect(x: 40, y: 20, width: self.bounds.width - 80, height: 40))
        phoneNumTextField.placeholder = "请输入手机号"
        phoneNumTextField.textColor = UIColor.black
        phoneNumTextField.font = UIFont.systemFont(ofSize: 13)
        phoneNumTextField.layer.cornerRadius = 20
        phoneNumTextField.backgroundColor = UIColor(white: 0.3, alpha: 0.4)
        phoneNumTextField.layer.masksToBounds = true
        addSubview(phoneNumTextField)
        
        verifyNumTextField = UITextField(frame: CGRect(x: 40, y: 20, width: self.bounds.width - 80, height: 40))
        verifyNumTextField.placeholder = "请输入验证码"
        verifyNumTextField.textColor = UIColor.black
        verifyNumTextField.font = UIFont.systemFont(ofSize: 13)
        verifyNumTextField.layer.cornerRadius = 20
        verifyNumTextField.backgroundColor = UIColor(white: 0.3, alpha: 0.4)
        verifyNumTextField.layer.masksToBounds = true
        addSubview(verifyNumTextField)

        
        loginButon = UIButton(type: .custom)
        loginButon.frame = CGRect(x: 40, y: verifyNumTextField.frame.maxY + 30, width: self.bounds.width - 80, height: 40)
        loginButon.layer.cornerRadius = 20
        loginButon.layer.masksToBounds = true
        loginButon.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.6)
        loginButon.setTitle("手机快捷登录", for: .normal)
        loginButon.setTitleColor(UIColor.white, for: .normal)
        addSubview(loginButon)

        genCaptchaButton = UIButton(type: .custom)
        genCaptchaButton.setTitle("获取验证码", for: .normal)
        genCaptchaButton.setTitleColor(UIColor.red, for: .normal)
        genCaptchaButton.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        genCaptchaButton.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        verifyNumTextField.rightView = genCaptchaButton
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
}
