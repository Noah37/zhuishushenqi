//
//  ZSBookShelfHeaderView.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2019/6/29.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit
import SnapKit

enum ZSBookShelfHeaderType {
    case none
    case tip
    case message
    case double
}

protocol ZSBookShelfHeaderDelegate:class {
    func headerView(headerView:ZSBookShelfHeaderView, didClickLoginButton:UIButton)
    func headerView(headerView:ZSBookShelfHeaderView, didClickMsgButton:UIButton)
}

class ZSBookShelfHeaderView: UITableViewHeaderFooterView {
    
    private lazy var imageView:UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(named: "bookshelf_top_bg_one_line")
        return imageView
    }()
    
    private lazy var tipButton:UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColor.gray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.titleLabel?.textAlignment = .left
        button.setTitle("小说免费看? 海量福利", for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        button.contentHorizontalAlignment = .left
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var msgButton:UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColor.gray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.titleLabel?.textAlignment = .left
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(msgAction), for: .touchUpInside)
        return button
    }()
    private lazy var loginButton:UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColor.gray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.setTitle("立即登录", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.init(hexString: "#EE4745")
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        return button
    }()
    private lazy var arrowButton:UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColor.gray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.setImage(UIImage(named: "bookshelf_icon_more_10_10_10x10_"), for: .normal)
        button.addTarget(self, action: #selector(msgAction), for: .touchUpInside)
        return button
    }()
    
    var type:ZSBookShelfHeaderType = .double { didSet { change(type: type) } }
    weak var delegate:ZSBookShelfHeaderDelegate?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.white
        layer.masksToBounds = true
        addSubview(imageView)
        imageView.addSubview(tipButton)
        imageView.addSubview(msgButton)
        tipButton.addSubview(loginButton)
        msgButton.addSubview(arrowButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(msg:ZSShelfMessage?) {
        let title = msg?.postMessage()
        if let _ = title?.1 {
            self.type = ZSLogin.share.hasLogin() ? .message:.double
        } else {
            self.type = ZSLogin.share.hasLogin() ? .none:.tip
        }
        msgButton.setTitle(title?.1, for: .normal)
        msgButton.setTitleColor(title?.3, for: .normal)
    }
    
    private func change(type:ZSBookShelfHeaderType) {
        switch type {
        case .tip:
            imageView.image = UIImage(named: "bookshelf_top_bg_one_line")
            break
        case .message:
            imageView.image = UIImage(named: "bookshelf_top_bg_one_line")
            break
        case .double:
            imageView.image = UIImage(named: "bookshelf_top_bg_two_line")
            break
        default:
            break
        }
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    @objc
    private func loginAction() {
        delegate?.headerView(headerView: self, didClickLoginButton: self.loginButton)
    }
    
    @objc
    private func msgAction() {
        delegate?.headerView(headerView: self, didClickMsgButton: self.msgButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        switch type {
        case .tip:
            imageView.frame = CGRect(x: 2, y: 0, width: bounds.width - 4, height: bounds.height)
            tipButton.frame = CGRect(x: 18, y: 20, width: bounds.width - 40, height: bounds.height - 40)
            break
        case .message:
            imageView.frame = CGRect(x: 2, y: 0, width: bounds.width - 4, height: bounds.height)
            msgButton.frame = CGRect(x: 18, y: 20, width: bounds.width - 40, height: bounds.height - 40)
            break
        case .double:
            imageView.frame = CGRect(x: 2, y: 0, width: bounds.width - 4, height: bounds.height)
            msgButton.frame = CGRect(x: 18, y: 20, width: bounds.width - 40, height: imageView.bounds.height/2 - 20)
            tipButton.frame = CGRect(x: 18, y: 0 + imageView.bounds.height/2, width: bounds.width - 40, height: imageView.bounds.height/2 - 20)
            break
        default:
            break
        }
        loginButton.frame = CGRect(x: tipButton.width - 80 - 10, y: tipButton.bounds.height/2 - 15, width: 80, height: 30)
        arrowButton.frame = CGRect(x: msgButton.width - 20 - 10, y: msgButton.bounds.height/2 - 10, width: 20, height: 20)
        msgButton.isHidden = (type != .message && type != .double)
        arrowButton.isHidden = (type != .message && type != .double)
        loginButton.isHidden = ZSLogin.share.hasLogin()
        tipButton.isHidden = ZSLogin.share.hasLogin()
    }
}
