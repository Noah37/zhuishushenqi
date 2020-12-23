//
//  ZSDynamicHeaderView.swift
//  zhuishushenqi
//
//  Created by yung on 2019/7/6.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit

protocol ZSDynamicHeaderViewDelegate:class {
    func headerView(headerView:ZSDynamicHeaderView, clickIcon:UIButton)
    func headerView(headerView:ZSDynamicHeaderView, clickFocus:UIButton)
    func headerView(headerView:ZSDynamicHeaderView, clickFocusCount:UIButton)
    func headerView(headerView:ZSDynamicHeaderView, clickFans:UIButton)

}

class ZSDynamicHeaderView: UITableViewHeaderFooterView {
    
    lazy var iconView:UIButton = {
        let imageView = UIButton(type: .custom)
        imageView.addTarget(self, action: #selector(iconAction(btn:)), for: .touchUpInside)
        imageView.layer.cornerRadius = 32
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    lazy var focusButton:UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 14
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor.init(red: 0.93, green: 0.28, blue: 0.27, alpha: 1)
        button.setTitle("关注", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(focusAction(btn:)), for: .touchUpInside)
        return button
    }()
    
    lazy var nickNameLabe:UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    lazy var levelLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor.init(red: 0.64, green: 0.64, blue: 0.64, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 9)
        label.textAlignment = .center
        label.layer.cornerRadius = 6.5
        label.layer.borderColor = UIColor.darkGray.cgColor
        label.layer.borderWidth = 0.5
        return label
    }()
    
    lazy var focusLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor.init(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 10)
        label.text = "关注"
        return label
    }()
    
    lazy var focusCountLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor.init(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var focusCountButton:UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(focusCountAction(btn:)), for: .touchUpInside)
        return button
    }()
    
    lazy var fansLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor.init(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 10)
        label.text = "粉丝"
        return label
    }()
    
    lazy var fansCountLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor.init(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var fansCountButton:UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(fansAction(btn:)), for: .touchUpInside)
        return button
    }()
    
    weak var delegate:ZSDynamicHeaderViewDelegate?
    
    var type:UserDynamicType = .dynamic {
        didSet {
            type == .dynamic ? focusButton.setTitle("关注", for: .normal) : focusButton.setTitle("编辑", for: .normal)
        }
    }
    
    var focusState:Bool = false {
        didSet {
            if type == .dynamic {
                focusState ? focusSelected():focusUnSelected()
            }
        }
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.white
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(iconView)
        contentView.addSubview(focusButton)
        contentView.addSubview(nickNameLabe)
        contentView.addSubview(levelLabel)
        contentView.addSubview(focusLabel)
        contentView.addSubview(focusCountLabel)
        contentView.addSubview(focusCountButton)
        contentView.addSubview(fansLabel)
        contentView.addSubview(fansCountLabel)
        contentView.addSubview(fansCountButton)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconView.frame = CGRect(x: 15, y: 34, width: 64, height: 64)
        focusButton.frame = CGRect(x: bounds.width - 60 - 16, y: 30, width: 60, height: 28)
        let nickNameWidth = nickNameLabe.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: 20)).width
        nickNameLabe.frame = CGRect(x: iconView.frame.maxX + 20, y: 32, width: nickNameWidth, height: 20)
        let levelWidth = levelLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: 13)).width + 10
        levelLabel.frame = CGRect(x: nickNameLabe.frame.maxX + 3, y: 35.5, width: levelWidth, height: 13)
        let focusWidth  = focusCountLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: 20)).width
        focusCountLabel.frame = CGRect(x: iconView.frame.maxX + 20, y: nickNameLabe.frame.maxY + 20, width: focusWidth, height: 20)
        focusLabel.frame = CGRect(x: iconView.frame.maxX + 20, y: focusCountLabel.frame.maxY, width: 40, height: 10)
        let focusCountWidth = max(focusCountLabel.frame.maxX - focusCountLabel.frame.minX, focusLabel.frame.maxX - focusLabel.frame.minX)
        focusCountButton.frame = CGRect(x: focusCountLabel.frame.minX, y: focusCountLabel.frame.minY, width: focusCountWidth, height: 30)
        let fansCountWidth = fansCountLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: 20)).width
        fansCountLabel.frame = CGRect(x: focusCountLabel.frame.maxX + 19, y: nickNameLabe.frame.maxY + 20, width: fansCountWidth, height: 20)
        fansLabel.frame = CGRect(x: fansCountLabel.frame.minX, y: fansCountLabel.frame.maxY, width: 40, height: 10)
        let fansCountButtonWidth = max(fansCountLabel.frame.maxX - fansCountLabel.frame.minX, fansLabel.frame.maxX - fansLabel.frame.minX)
        fansCountButton.frame = CGRect(x: fansCountLabel.frame.minX, y: fansCountLabel.frame.minY, width: fansCountButtonWidth, height: 30)

        
    }
    
    func configure(user:ZSDynaicUser?) {
        if let userInfo = user {
            iconView.qs_setAvatarWithURLString(urlString: userInfo.avatar)
            nickNameLabe.text = userInfo.nickname
            levelLabel.text = "lv.\(userInfo.lv)"
            focusCountLabel.text = "\(userInfo.followings)"
            fansCountLabel.text = "\(userInfo.followers)"
        }
    }
    
    private func focusSelected() {
        self.focusButton.setTitle("已关注", for: .normal)
        self.focusButton.setTitleColor(UIColor(red: 0.94, green: 0.94, blue: 0.95, alpha: 1), for: .normal)
        self.focusButton.backgroundColor = UIColor(red: 0.75, green: 0.75, blue: 0.76, alpha: 1)
    }
    
    private func focusUnSelected() {
        self.focusButton.setTitle("关注", for: .normal)
        self.focusButton.setTitleColor(UIColor.white, for: .normal)
        self.focusButton.backgroundColor = UIColor.init(red: 0.93, green: 0.28, blue: 0.27, alpha: 1)
    }
    
    @objc
    func iconAction(btn:UIButton) {
        delegate?.headerView(headerView: self, clickIcon: btn)
    }
    
    @objc
    func focusAction(btn:UIButton) {
        delegate?.headerView(headerView: self, clickFocus: btn)
    }
    
    @objc
    func fansAction(btn:UIButton) {
        delegate?.headerView(headerView: self, clickFans: btn)
    }
    
    @objc
    func focusCountAction(btn:UIButton) {
        delegate?.headerView(headerView: self, clickFocusCount: btn)
    }
}
