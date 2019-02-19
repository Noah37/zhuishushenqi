//
//  ZSChapterPayView.swift
//  zhuishushenqi
//
//  Created by caony on 2019/2/15.
//  Copyright © 2019年 QS. All rights reserved.
//

import Foundation

class ZSChapterPayView: UIView {
    
    var titleLabel:UILabel!
    var tipLabel:UILabel!
    var payButton:UIButton!
    var leftLineView:UIView!
    var rightLineView:UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.textColor = UIColor.gray
        addSubview(titleLabel)
        
        tipLabel = UILabel(frame: CGRect.zero)
        tipLabel.textAlignment = .center
        tipLabel.font = UIFont.systemFont(ofSize: 13)
        tipLabel.text = "* 本章需购买后阅读 *"
        tipLabel.textColor = UIColor.gray
        addSubview(tipLabel)
        
        payButton = UIButton(type: .custom)
        payButton.setTitle("购买章节", for: .normal)
        payButton.setTitleColor(UIColor.gray, for: .normal)
        payButton.layer.cornerRadius = 5
        payButton.layer.borderWidth = 1
        payButton.layer.borderColor = UIColor.gray.cgColor
        addSubview(payButton)
        
        leftLineView = UIView(frame: CGRect.zero)
        leftLineView.backgroundColor = UIColor.gray
        addSubview(leftLineView)
        
        rightLineView = UIView(frame: CGRect.zero)
        rightLineView.backgroundColor = UIColor.gray
        addSubview(rightLineView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRect(x: 20, y: 200, width: bounds.width - 40, height: 60)
        tipLabel.frame = CGRect(x: 0, y: 0, width: 130, height: 15)
        tipLabel.center = CGPoint(x: bounds.width/2, y: bounds.height/2)
        leftLineView.frame = CGRect(x: 0, y: 0, width: bounds.width/2 - tipLabel.bounds.width/2, height: 1)
        leftLineView.center = CGPoint(x: bounds.width/4 - tipLabel.bounds.width/4, y: tipLabel.centerY)
        rightLineView.frame = CGRect(x: bounds.width/2 + tipLabel.bounds.width/2, y: tipLabel.centerY, width: bounds.width/2 - tipLabel.bounds.width/2, height: 1)
//        rightLineView.center = CGPoint(x:bounds.width + tipLabel.bounds.width +  bounds.width/4 - tipLabel.bounds.width/4, y: tipLabel.centerY)
        payButton.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        payButton.center = CGPoint(x: bounds.width/2, y: tipLabel.frame.maxY + 60)

    }
}
