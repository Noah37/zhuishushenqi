//
//  ZSCatelogCell.swift
//  zhuishushenqi
//
//  Created by caony on 2019/3/19.
//  Copyright © 2019年 QS. All rights reserved.
//

import Foundation

class ZSCatelogCell: UICollectionViewCell {
    
    var titleLabel:UILabel!
    var descLabel:UILabel!
    var leftImageView:UIImageView!
    var rightImageView:UIImageView!
    var centerImageView:UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame = CGRect(x: 0, y: self.bounds.size.height/2 - 35/2, width: self.bounds.size.width/2, height: 15)
        descLabel.frame = CGRect(x: 0, y: titleLabel.frame.maxY + 5, width: self.bounds.size.width/2, height: 15)
        leftImageView.frame = CGRect(x: titleLabel.frame.maxX + 20, y: self.bounds.height - 80, width: 44 , height: 60)
        centerImageView.frame = CGRect(x: leftImageView.frame.minX + 10, y: leftImageView.frame.minY - 10, width: 50, height: 70)
        rightImageView.frame = CGRect(x: centerImageView.frame.minX + 20, y: centerImageView.frame.minY + 20, width: 40, height: 50)
        if !self.leftImageView.frame.equalTo(CGRect.zero) {
            leftImageView.addShadow(cornerRadius: 4)
        }
        centerImageView.addShadow(cornerRadius: 4)
        rightImageView.addShadow(cornerRadius: 4)
    }
    
    func updateCell(_ model:ZSCatelogItem) {
        titleLabel.text = model.name
        descLabel.text = "\(model.bookCount)"
        leftImageView.qs_setBookCoverWithURLString(urlString: model.bookCover[safe: 0] ?? "")
        centerImageView.qs_setBookCoverWithURLString(urlString: model.bookCover[safe: 1] ?? "")
        rightImageView.qs_setBookCoverWithURLString(urlString: model.bookCover[safe: 2] ?? "")

    }
    
    private func setupSubview() {
        titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.gray
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        contentView.addSubview(titleLabel)
        
        descLabel = UILabel(frame: CGRect.zero)
        descLabel.textAlignment = .center
        descLabel.textColor = UIColor.darkGray
        descLabel.font = UIFont.systemFont(ofSize: 11)
        contentView.addSubview(descLabel)
        
        leftImageView = UIImageView(frame: CGRect.zero)
        leftImageView.backgroundColor = UIColor.red
        contentView.addSubview(leftImageView)
        
        rightImageView = UIImageView(frame: CGRect.zero)
        rightImageView.backgroundColor = UIColor.orange
        contentView.addSubview(rightImageView)
        
        centerImageView = UIImageView(frame: CGRect.zero)
        centerImageView.backgroundColor = UIColor.cyan
        contentView.addSubview(centerImageView)
    }
}
