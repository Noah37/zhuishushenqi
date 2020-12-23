//
//  ZSNoNetworkView.swift
//  zhuishushenqi
//
//  Created by yung on 2019/7/6.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit

typealias ZSNoNetworkHandler = ()->Void

class ZSNoNetworkView: UIView {
    
    lazy var imageView:UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "no_network_140x128_")
        return imageView
    }()
    
    lazy var loginButton:UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("登录", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor(red: 0.41, green: 0.64, blue: 0.29, alpha: 1)
        button.addTarget(self, action: #selector(loginAction(btn:)), for: .touchUpInside)
        return button
    }()
    
    var loginHandler:ZSNoNetworkHandler?

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(loginButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x: bounds.width/2 - 70, y: 200, width: 140, height: 128)
        loginButton.frame = CGRect(x: bounds.width/2 - 100, y: imageView.frame.maxY + 200, width: 200, height: 40)
    }
    
    @objc
    func loginAction(btn:UIButton) {
        loginHandler?()
    }
}
