//
//  ZSBookInfoHeaderView.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2019/10/28.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit

typealias ZSBookInfoHeaderHandler = ()->Void

class ZSBookInfoHeaderView: UITableViewHeaderFooterView {
    
    var lastTapHandler:ZSBookInfoHeaderHandler?

    lazy var authorLabel:UILabel = {
        let lb = UILabel(frame: .zero)
        lb.textColor = UIColor.red
        lb.font = UIFont.systemFont(ofSize: 15)
        return lb
    }()
    
    lazy var contentLabel:UILabel = {
        let lb = UILabel(frame: .zero)
        lb.textColor = UIColor.gray
        lb.numberOfLines = 0
        lb.font = UIFont.systemFont(ofSize: 13)
        return lb
    }()
    
    lazy var iconView:UIImageView = {
        let lb = UIImageView(frame: .zero)
        return lb
    }()
    
    lazy var lastUpdateTimeBT:UIButton = {
        let lb = UIButton(type: .custom)
        lb.setTitleColor(UIColor.red, for: .normal)
        lb.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        lb.addTarget(self, action: #selector(lastButtonAction(bt:)), for: .touchUpInside)
        return lb
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(authorLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(iconView)
        contentView.addSubview(lastUpdateTimeBT)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.iconView.frame = CGRect(x: 15, y: 15, width: 70, height: 100)
        self.authorLabel.frame = CGRect(x: self.iconView.frame.maxX + 15, y: 15, width: self.contentView.bounds.width - self.iconView.frame.maxX - 30, height: 15)
        self.lastUpdateTimeBT.frame = CGRect(x: 15, y: self.iconView.frame.maxY + 10, width: self.contentView.bounds.width - 30, height: 40)
        let contentSize = self.contentLabel.sizeThatFits(CGSize(width: self.contentView.bounds.width - 30, height: CGFloat.greatestFiniteMagnitude))
        self.contentLabel.frame = CGRect(x: 15, y: self.lastUpdateTimeBT.frame.maxY + 10, width: self.contentView.bounds.width - 30, height:contentSize.height)
    }
    
    @objc
    private func lastButtonAction(bt:UIButton) {
        if lastTapHandler != nil {
            lastTapHandler?()
        }
    }
    
    func configure(model:AikanParserModel) {
        let resource = QSResource(url: URL(string: "\(model.bookIcon)") ?? URL(string: "www.baidu.com")!)
        self.iconView.kf.setImage(with: resource)
        self.authorLabel.text = model.bookAuthor
        self.contentLabel.text = model.bookDesc
    }
}
