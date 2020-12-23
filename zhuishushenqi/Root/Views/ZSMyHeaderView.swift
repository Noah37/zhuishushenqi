//
//  ZSMyHeaderView.swift
//  zhuishushenqi
//
//  Created by yung on 2018/10/20.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit

typealias ZSMyHeaderHandler = ()->Void

class ZSMyHeaderView: UITableViewHeaderFooterView, UIGestureRecognizerDelegate {
    
    var account:ZSAccount? {
        didSet {
            self.bookCoinView.valueLabel.text = "\(account?.iosBalance ?? 0)"
            self.bookBarginView.valueLabel.text = "\( account?.voucherBalance ?? 0)"
        }
    }
    
    var coin:ZSCoin? {
        didSet {
            self.goldCoinView.valueLabel.text = "\(coin?.info?.gold ?? 0)"
            self.leftCoinView.valueLabel.text = "\(coin?.info?.balance ?? "")"
        }
    }
    
    var userInfo:ZSQQLoginResponse? {
        didSet {

            self.iconView.qs_setAvatarWithURLString(urlString: userInfo?.user?.avatar ?? "")
            self.nicknameLabel.text = userInfo?.user?.nickname
            self.IDValueLabel.text = userInfo?.user?._id
        }
    }
    
    var handler:ZSMyHeaderHandler?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.isUserInteractionEnabled = true
        self.contentView.isUserInteractionEnabled = true
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func setupSubviews() {
        
        self.topView.addSubview(self.iconView)
        self.topView.addSubview(self.nicknameLabel)
        self.contentView.addSubview(self.topView)
        self.topView.addSubview(self.topLine)
     
        self.bookCoinView.titleLabel.text = "书币"
        self.bookCoinView.valueLabel.text = "0"
        self.bookBarginView.titleLabel.text = "书券"
        self.bookBarginView.valueLabel.text = "62"
        self.goldCoinView.titleLabel.text = "金币"
        self.goldCoinView.valueLabel.text = "100"
        self.leftCoinView.titleLabel.text = "¥零钱"
        self.leftCoinView.valueLabel.text = "¥0.00"
        
        self.centerView.addSubview(self.bookCoinView)
        self.centerView.addSubview(self.bookBarginView)
        self.centerView.addSubview(self.goldCoinView)
        self.centerView.addSubview(self.leftCoinView)
        self.centerView.addSubview(self.centerLine)
        self.centerView.addSubview(self.topHoriLine)
        self.centerView.addSubview(self.centerHoriLine)
        self.centerView.addSubview(self.bottomHoriLine)
        self.contentView.addSubview(self.centerView)
        
        self.contentView.addSubview(self.bottomView)
        self.bottomView.addSubview(self.IDLabel)
        self.bottomView.addSubview(self.IDValueLabel)
        self.bottomView.addSubview(self.copyButton)
        self.bottomView.addSubview(self.bottomLine)
        
        self.copyButton.addTarget(self, action: #selector(copyAction(sender:)), for: .touchUpInside)
//        let tap = UIGestureRecognizer(target: self, action: #selector(tapAction(tap:)))
//        self.topView.addGestureRecognizer(tap)
        self.topView.addTarget(self, action: #selector(tapAction(tap:)), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundView?.isUserInteractionEnabled = true
        self.topView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 100)
        self.centerView.frame = CGRect(x: 0, y: self.topView.frame.maxY, width: self.bounds.width, height: 100)
        self.bottomView.frame = CGRect(x: 0, y: self.centerView.frame.maxY, width: self.bounds.width, height: 60)
        self.topLine.frame = CGRect(x: 0, y: self.topView.bounds.height - 0.2, width: self.bounds.width, height: 0.2)
        
        self.iconView.frame = CGRect(x: 20, y: self.topView.frame.height/2 - 25, width: 50, height: 50)
        self.nicknameLabel.frame = CGRect(x: self.iconView.frame.maxX + 10, y: self.topView.bounds.height/2 - 15, width: 200, height: 30)
        self.bookCoinView.frame = CGRect(x: 0, y: 0, width: self.bounds.width/4, height: self.centerView.frame.height)
        self.bookBarginView.frame = CGRect(x: self.bounds.width/4, y: 0, width: self.bounds.width/4, height: self.centerView.frame.height)
        self.goldCoinView.frame = CGRect(x: self.bounds.width/2, y: 0, width: self.bounds.width/4, height: self.centerView.frame.height)
        self.leftCoinView.frame = CGRect(x: self.bounds.width*3/4, y: 0, width: self.bounds.width/4, height: self.centerView.frame.height)
        self.centerLine.frame = CGRect(x: 0, y: self.centerView.bounds.height - 0.2, width: self.bounds.width, height: 0.2)
        self.topHoriLine.frame = CGRect(x: self.bounds.width/4, y: 100/3, width: 0.2, height: 100/3)
        self.centerHoriLine.frame = CGRect(x: self.bounds.width/2, y: 100/3, width: 0.2, height: 100/3)
        self.bottomHoriLine.frame = CGRect(x: self.bounds.width*3/4, y: 100/3, width: 0.2, height: 100/3)

        
        self.IDLabel.frame = CGRect(x: 20, y: 15, width: 30, height: 30)
        self.copyButton.frame = CGRect(x: self.bounds.width - 80, y: 15, width: 60, height: 30)
        self.IDValueLabel.frame = CGRect(x: self.IDLabel.frame.maxX + 20, y: self.bottomView.frame.height/2 - 15, width: self.bounds.width - (self.IDLabel.frame.maxX + 20 + self.copyButton.frame.width + 20 + 20), height: 30)
        self.bottomLine.frame = CGRect(x: 0, y: self.bottomView.bounds.height - 0.2, width: self.bounds.width, height: 0.2)
    }
    
    //MARK: - action
    @objc
    func copyAction(sender:UIButton) {
        UIPasteboard.general.string = self.IDValueLabel.text
        KeyWindow?.showTip(tip: "ID已复制到您的剪切板")
    }
    
    @objc
    func tapAction(tap:UITapGestureRecognizer) {
        handler?()
    }
    
    //MARK: - getter
    lazy var topLine:UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: self.topView.bounds.height - 1, width: self.bounds.width, height: 1))
        label.backgroundColor = UIColor.gray
        label.alpha = 0.2
        return label
    }()
    
    lazy var centerLine:UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: self.centerView.bounds.height - 1, width: self.bounds.width, height: 1))
        label.backgroundColor = UIColor.gray
        label.alpha = 0.2
        return label
    }()
    
    lazy var bottomLine:UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: self.bottomView.bounds.height - 1, width: self.bounds.width, height: 1))
        label.backgroundColor = UIColor.gray
        label.alpha = 0.2
        return label
    }()
    
    lazy var topHoriLine:UILabel = {
        let label = UILabel(frame: CGRect(x: self.bounds.width/4, y: 100/3, width: 0.2, height: 100/3))
        label.backgroundColor = UIColor.gray
        label.alpha = 0.2
        return label
    }()
    
    lazy var centerHoriLine:UILabel = {
        let label = UILabel(frame: CGRect(x: self.bounds.width/2, y: 100/3, width: 0.2, height: 100/3))
        label.backgroundColor = UIColor.gray
        label.alpha = 0.2
        return label
    }()
    
    lazy var bottomHoriLine:UILabel = {
        let label = UILabel(frame: CGRect(x: self.bounds.width*3/4, y: 100/3, width: 0.2, height: 100/3))
        label.backgroundColor = UIColor.gray
        label.alpha = 0.2
        return label
    }()
    
    lazy var copyButton:UIButton = {
        let btn = UIButton(type: .custom)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.frame = CGRect(x: self.bounds.width - 60, y: 15, width: 60, height: 26)
        btn.setTitle("复制ID", for: .normal)
        btn.setTitleColor(UIColor.darkGray, for: .normal)
        btn.layer.cornerRadius = 5
        btn.layer.borderColor = UIColor.gray.cgColor
        btn.layer.borderWidth = 0.5
        return btn
    }()
    
    lazy var IDValueLabel:UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.black
        label.textAlignment = .left
        return label
    }()
    
    lazy var IDLabel:UILabel = {
        let label = UILabel(frame: CGRect(x: 20, y: 15, width: 30, height: 30))
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.backgroundColor = UIColor.orange
        label.text = "ID"
        label.layer.cornerRadius = 15
        label.layer.masksToBounds = true
        return label
    }()
    
    lazy var bookCoinView:ZSMyHeaderItemView = {
        let view = ZSMyHeaderItemView(frame: CGRect.zero)
        view.backgroundColor = UIColor.white
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var bookBarginView:ZSMyHeaderItemView = {
        let view = ZSMyHeaderItemView(frame: CGRect.zero)
        view.backgroundColor = UIColor.white
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var goldCoinView:ZSMyHeaderItemView = {
        let view = ZSMyHeaderItemView(frame: CGRect.zero)
        view.backgroundColor = UIColor.white
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var leftCoinView:ZSMyHeaderItemView = {
        let view = ZSMyHeaderItemView(frame: CGRect.zero)
        view.backgroundColor = UIColor.white
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var iconView:UIImageView = {
        let imageView = UIImageView(frame: CGRect.zero)
        imageView.frame = CGRect(x: 20, y: 30, width: 50, height: 50)
        imageView.layer.cornerRadius = 25
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var nicknameLabel:UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.black
        label.textAlignment = .left
        return label
    }()
    
    lazy var topView:UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 100))
        view.backgroundColor = UIColor.white
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var centerView:UIView = {
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = UIColor.white
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var bottomView:UIView = {
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = UIColor.white
        view.isUserInteractionEnabled = true
        return view
    }()
}

class ZSMyHeaderItemView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        self.addSubview(self.valueLabel)
        self.addSubview(self.titleLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel.frame = CGRect(x: 0, y: 50, width: self.bounds.width, height: 15)
        self.valueLabel.frame = CGRect(x: 0, y: 35, width: self.bounds.width, height: 15)
    }
    
    lazy var titleLabel:UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor.gray
        label.textAlignment = .center
        return label
    }()
    
    lazy var valueLabel:UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor.black
        label.textAlignment = .center
        return label
    }()
}
