
//
//  ZSFeelingView.swift
//  zhuishushenqi
//
//  Created by yung on 2018/10/27.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit

class ZSFeelingView: UIView {
    
    var approvalButton:QSToolButton!
    var shareButton:QSToolButton!
    var moreButton:QSToolButton!


    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        approvalButton = QSToolButton(type: .custom)
        approvalButton.setTitle("同感", for: .normal)
        approvalButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        approvalButton.setTitleColor(UIColor.gray, for: .normal)
        approvalButton.setImage(UIImage(named: "forum_like_icon"), for: .normal)
        approvalButton.frame = CGRect(x: 0, y: 0, width: self.bounds.width/3, height: self.bounds.height)
        addSubview(approvalButton)
        
        shareButton = QSToolButton(type: .custom)
        shareButton.setTitle("分享", for: .normal)
        shareButton.setTitleColor(UIColor.gray, for: .normal)
        shareButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        shareButton.setImage(UIImage(named: "forum_share_icon"), for: .normal)
        shareButton.frame = CGRect(x: self.bounds.width/3, y: 0, width: self.bounds.width/3, height: self.bounds.height)
        addSubview(shareButton)
        
        moreButton = QSToolButton(type: .custom)
        moreButton.setTitle("更多", for: .normal)
        moreButton.setTitleColor(UIColor.gray, for: .normal)
        moreButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        moreButton.setImage(UIImage(named: "forum_more_icon"), for: .normal)
        moreButton.frame = CGRect(x: self.bounds.width*2/3, y: 0, width: self.bounds.width/3, height: self.bounds.height)
        addSubview(moreButton)
        
        for index in 0..<2 {
            let horizonalLine = UILabel(frame: CGRect(x: (self.bounds.width/3 - 0.2)*(CGFloat(index) + 1.0), y: 10, width: 0.2, height: self.bounds.height - 20))
            horizonalLine.backgroundColor = UIColor.gray
            horizonalLine.alpha = 0.6
            addSubview(horizonalLine)
        }
    }
}
