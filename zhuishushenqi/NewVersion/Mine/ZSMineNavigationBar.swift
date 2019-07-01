//
//  ZSMineNavigationBar.swift
//  zhuishushenqi
//
//  Created by caony on 2019/7/1.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit

enum MineNavigationBarType {
    case logout
    case login
}

protocol ZSMineNavigationBarDelegate:class {
    func navigationBar(navigationBar:ZSMineNavigationBar, didClickLogin:UIButton)
    func navigationBar(navigationBar:ZSMineNavigationBar, didClickIcon:UIButton)

}

class ZSMineNavigationBar: UIView {
    
    private lazy var titleLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 17)
        label.text = "未登录"
        return label
    }()
    
    private lazy var loginButton:UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("点击登录", for: .normal)
        button.setTitleColor(UIColor.init(hexString: "#A70A0B"), for: .normal)
        button.backgroundColor = UIColor.white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.addTarget(self, action: #selector(loginAction(btn:)), for: .touchUpInside)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 15
        return button
    }()
    
    private lazy var iconButton:UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(userAction(btn:)), for: .touchUpInside)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 20
        return button
    }()
    
    var type:MineNavigationBarType = .logout { didSet { changeType(type: type) } }
    
    weak var delegate:ZSMineNavigationBarDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(loginButton)
        addSubview(iconButton)
        self.backgroundColor = UIColor.init(hexString: "#A70A0B")
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let statusHeight = UIApplication.shared.statusBarFrame.height
        titleLabel.frame = CGRect(x: 20, y: statusHeight, width: 100, height: 44)
        loginButton.frame = CGRect(x: bounds.width - 120, y: statusHeight + 7, width: 100, height: 30)
        iconButton.frame = CGRect(x: bounds.width - 60, y: statusHeight + 2, width: 40, height: 40)
    }
    
    private func changeType(type:MineNavigationBarType) {
        switch type {
        case .logout:
            titleLabel.text = "未登录"
            break
        default:
            break
        }
        loginButton.isHidden = type == .login
        iconButton.isHidden = type == .logout
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func loginState(state:MineNavigationBarType, title:String?, icon:String?) {
        type = state
        if state == .login {
            titleLabel.text = title
            let resource = QSResource(url: URL(string: "\(IMAGE_BASEURL)\(icon ?? "")") ?? URL(string: "www.baidu.com")!)
            iconButton.kf.setImage(with: resource, for: .normal)
        }
    }
    
    @objc
    private func loginAction(btn:UIButton) {
        delegate?.navigationBar(navigationBar: self, didClickLogin: btn)
    }
    
    @objc
    private func userAction(btn:UIButton) {
        delegate?.navigationBar(navigationBar: self, didClickIcon: btn)
    }
}
