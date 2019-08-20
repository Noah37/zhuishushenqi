//
//  ZSForumTextView.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2019/8/19.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit

class ZSForumTextView: UIView {
    
    private lazy var topLine:UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.darkGray
        return view
    }()
    
    private lazy var imageView:UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "chapter_review_send_tip_24x24_")
        return imageView
    }()
    
    private lazy var textView:UITextView = {
        let view = UITextView(frame: .zero)
        view.font = UIFont.systemFont(ofSize: 11)
        return view
    }()
    
    private lazy var sendButton:UIButton = {
        let view = UIButton(type: .custom)
        view.setTitle("发送", for: .normal)
        view.setTitleColor(UIColor.white, for: .normal)
        view.backgroundColor = UIColor.red
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(topLine)
        addSubview(imageView)
        addSubview(textView)
        addSubview(sendButton)
        
        topLine.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        imageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(24)
            make.left.top.equalTo(18)
        }
        
        sendButton.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
        }
        
        textView.snp.makeConstraints { [unowned self](make) in
            make.left.equalTo(self.imageView.snp_right).offset(20)
            make.right.equalTo(self.sendButton.snp_left).offset(-20)
            make.top.equalTo(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
