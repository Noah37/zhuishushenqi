//
//  ZSMineHeaderView.swift
//  zhuishushenqi
//
//  Created by yung on 2019/7/7.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit

typealias ZSMineHeaderHandler = ()->Void

class ZSMineHeaderView: UITableViewHeaderFooterView {
    
    lazy var coinLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor.init(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 10)
        label.text = "书币"
        return label
    }()
    
    lazy var coinCountLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor.init(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var coinCountButton:UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(coinCountAction(btn:)), for: .touchUpInside)
        return button
    }()
    
    lazy var quanLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor.init(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 10)
        label.text = "书券"
        return label
    }()
    
    lazy var quanCountLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor.init(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var quanCountButton:UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(quanAction(btn:)), for: .touchUpInside)
        return button
    }()
    
    var coinHandler:ZSMineHeaderHandler?
    var quanHandler:ZSMineHeaderHandler?

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(coinLabel)
        contentView.addSubview(coinCountLabel)
        contentView.addSubview(coinCountButton)
        contentView.addSubview(quanLabel)
        contentView.addSubview(quanCountLabel)
        contentView.addSubview(quanCountButton)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func coinCountAction(btn:UIButton) {
        coinHandler?()
    }
    
    @objc
    private func quanAction(btn:UIButton) {
        quanHandler?()
    }
    
    func configure(account:ZSAccount?) {
        if let acc = account {
            self.coinCountLabel.text = "\(acc.balance)"
            self.quanCountLabel.text = "\(acc.voucherSum)"
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.coinCountLabel.frame = CGRect(x: 15, y: 15, width: 120, height: 15)
        self.coinLabel.frame = CGRect(x: 15, y: self.coinCountLabel.frame.maxY, width: 120, height: 15)
        self.quanCountLabel.frame = CGRect(x: self.coinCountLabel.frame.maxX, y: 15, width: 120, height: 15)
        self.quanLabel.frame = CGRect(x: self.quanCountLabel.frame.minX, y: self.quanCountLabel.frame.maxY, width: 120, height: 15)
        self.coinCountButton.frame = CGRect(x: 15, y: 15, width: 60, height: 30)
        self.quanCountButton.frame = CGRect(x: self.quanLabel.frame.minX, y: 15, width: 60, height: 30)
    }
}
