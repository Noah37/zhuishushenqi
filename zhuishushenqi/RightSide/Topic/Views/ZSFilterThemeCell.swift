//
//  ZSFilterThemeCell.swift
//  zhuishushenqi
//
//  Created by caony on 2019/3/22.
//  Copyright © 2019年 QS. All rights reserved.
//

import Foundation
import UIKit

class ZSFilterThemeCell: UICollectionViewCell {
    
    var titleLabel:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = contentView.bounds
    }
    
    private func setupSubviews() {
        titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.gray
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(titleLabel)
    }
}
