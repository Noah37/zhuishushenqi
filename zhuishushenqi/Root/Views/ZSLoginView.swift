//
//  ZSLoginView.swift
//  zhuishushenqi
//
//  Created by caony on 2018/10/22.
//  Copyright © 2018 QS. All rights reserved.
//

import UIKit

typealias ZSLoginHandler = ()->Void

class ZSLoginView: UIView {
    
    private var phoneNumTextField:UITextField!
    private var verifyNumTextField:UITextField!
    private var loginButon:UIButton!
    private var genCaptchaButton:UIButton!
    
    var loginHandler:ZSLoginHandler?
    var getSMSCodeHandler:ZSLoginHandler?
    
    private var timer:Timer!
    
    private var secondsCount = 60

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        timer = Timer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        phoneNumTextField = ZSLoginTextField(frame: CGRect(x: 40, y: 20, width: self.bounds.width - 80, height: 40))
        phoneNumTextField.placeholder = "请输入手机号"
        phoneNumTextField.textColor = UIColor.black
        phoneNumTextField.font = UIFont.systemFont(ofSize: 13)
        phoneNumTextField.layer.cornerRadius = 20
        phoneNumTextField.backgroundColor = UIColor(white: 0.8, alpha: 0.4)
        phoneNumTextField.layer.masksToBounds = true
        phoneNumTextField.keyboardType = .numberPad
        addSubview(phoneNumTextField)
        
        verifyNumTextField = ZSLoginTextField(frame: CGRect(x: 40, y: self.phoneNumTextField.frame.maxY + 20, width: self.bounds.width - 80, height: 40))
        verifyNumTextField.placeholder = "请输入验证码"
        verifyNumTextField.textColor = UIColor.black
        verifyNumTextField.font = UIFont.systemFont(ofSize: 13)
        verifyNumTextField.layer.cornerRadius = 20
        verifyNumTextField.backgroundColor = UIColor(white: 0.8, alpha: 0.4)
        verifyNumTextField.layer.masksToBounds = true
        verifyNumTextField.keyboardType = .numberPad
        addSubview(verifyNumTextField)

        loginButon = UIButton(type: .custom)
        loginButon.frame = CGRect(x: 40, y: verifyNumTextField.frame.maxY + 30, width: self.bounds.width - 80, height: 40)
        loginButon.layer.cornerRadius = 20
        loginButon.layer.masksToBounds = true
        loginButon.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.7)
        loginButon.setTitle("手机快捷登录", for: .normal)
        loginButon.setTitleColor(UIColor.white, for: .normal)
        loginButon.addTarget(self, action: #selector(loginAction(btn:)), for: .touchUpInside)
        addSubview(loginButon)

        genCaptchaButton = UIButton(type: .custom)
        genCaptchaButton.setTitle("获取验证码", for: .normal)
        genCaptchaButton.setTitleColor(UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.7), for: .normal)
        genCaptchaButton.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        genCaptchaButton.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        genCaptchaButton.addTarget(self, action: #selector(getSMSCode(btn:)), for: .touchUpInside)
        verifyNumTextField.rightViewMode = .always
        verifyNumTextField.rightView = genCaptchaButton
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    @objc
    private func getSMSCode(btn:UIButton) {
        phoneNumTextField.resignFirstResponder()
        verifyNumTextField.resignFirstResponder()
        getSMSCodeHandler?()
    }
    
    @objc
    private func loginAction(btn:UIButton) {
        loginHandler?()
    }
    
    @objc
    func timerAction() {
        if secondsCount <= 0 {
            timer.invalidate()
            self.genCaptchaButton.isEnabled = true
            self.genCaptchaButton.setTitle("获取验证码", for: .normal)
        } else {
            self.genCaptchaButton.isEnabled = false
            let title = "\(secondsCount)秒后重新获取"
            let width = title.qs_width(UIFont.systemFont(ofSize: 11), height: 30)
            self.genCaptchaButton.setTitle(title, for: .normal)
            self.genCaptchaButton.width = width
        }
        self.genCaptchaButton.sizeToFit()
        secondsCount -= 1
    }
    
    func fire() {
        RunLoop.current.add(timer, forMode: .common)
    }
    
    func getSecondsLeft() ->Int {
        return self.secondsCount
    }
    
    func phoneNumber() ->String {
        return phoneNumTextField.text ?? ""
    }
    
    func smsCodeText() ->String {
        return verifyNumTextField.text ?? ""
    }
}


class ZSLoginTextField: UITextField {
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 20, y: bounds.origin.y, width: bounds.size.width - 40, height: bounds.size.height)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 20, y: bounds.origin.y, width: bounds.size.width - 40, height: bounds.size.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 20, y: bounds.origin.y, width: bounds.size.width - 40, height: bounds.size.height)
    }
}
