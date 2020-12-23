
//
//  ZSForumPageTitleHeaderView.swift
//  zhuishushenqi
//
//  Created by yung on 2019/8/16.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit

class ZSForumPageTitleHeaderView: UITableViewHeaderFooterView {
    
    lazy var titleLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor.black
        return label
    }()
    
    lazy var totalLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.gray
        return label
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(totalLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.bottom.equalToSuperview()
        }
        
        totalLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-20)
            make.top.bottom.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
        totalLabel.text = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
