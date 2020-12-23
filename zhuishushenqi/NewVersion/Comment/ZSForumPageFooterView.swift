//
//  ZSForumPageFooterView.swift
//  zhuishushenqi
//
//  Created by yung on 2019/8/12.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit

class ZSForumPageFooterView: UITableViewHeaderFooterView {
    
    private lazy var messageImageView:UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "bbs_icon_message_20_20")
        return imageView
    }()
    
    private lazy var messageLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor.darkText
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .left
        label.text = "0条评论"
        return label
    }()
    
    private lazy var sofaImageView:UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "community_noReview_sofa_icon")
        return imageView
    }()
    
    private lazy var sofaLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.text = "赶紧来抢沙发啊~"
        return label
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(messageImageView)
        contentView.addSubview(messageLabel)
        contentView.addSubview(sofaImageView)
        contentView.addSubview(sofaLabel)
        
        messageImageView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(20)
            make.width.height.equalTo(20)
        }
        
        messageLabel.snp.makeConstraints { [unowned self](make) in
            make.left.equalTo(self.messageImageView.snp_right).offset(10)
            make.top.equalToSuperview().offset(20)
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
        
        sofaImageView.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(56)
            make.top.equalToSuperview().offset(60)
            make.centerX.equalToSuperview()
        }
        sofaLabel.snp.makeConstraints { [unowned self](make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(self.sofaImageView.snp_bottom).offset(5)
            make.height.equalTo(20)
            make.bottom.equalToSuperview().offset(-100)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
