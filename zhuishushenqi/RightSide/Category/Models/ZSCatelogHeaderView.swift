//
//  ZSCatelogHeaderView.swift
//  zhuishushenqi
//
//  Created by caony on 2019/3/21.
//  Copyright © 2019年 QS. All rights reserved.
//

import Foundation

class ZSCatelogHeaderView: UICollectionReusableView {
    
    var titleLabel:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel.frame = CGRect(x: 20, y: self.bounds.height/2 - 10, width: 100, height: 20)
    }
}
