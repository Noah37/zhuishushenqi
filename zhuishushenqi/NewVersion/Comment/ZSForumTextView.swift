//
//  ZSForumTextView.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2019/8/19.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit

class ZSForumTextView: UIView, UITextFieldDelegate {
    
    private lazy var topLine:UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor(red: 0.72, green: 0.72, blue: 0.74, alpha: 1.0)
        return view
    }()
    
    private lazy var imageView:UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "chapter_review_send_tip_24x24_")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var textView:UITextField = {
        let view = UITextField(frame: .zero)
        view.font = UIFont.systemFont(ofSize: 11)
        view.placeholder = "请填写您的评论"
        return view
    }()
    
    private lazy var sendButton:UIButton = {
        let view = UIButton(type: .custom)
        view.setTitle("发送", for: .normal)
        view.setTitleColor(UIColor.white, for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        view.backgroundColor = UIColor.red
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        view.isEnabled = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 0.99, green: 0.99, blue: 1, alpha: 1)
        addSubview(topLine)
        addSubview(imageView)
        addSubview(textView)
        addSubview(sendButton)
        
        topLine.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        imageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(26)
            make.left.top.equalTo(13)
        }
        
        sendButton.snp.makeConstraints { (make) in
            make.height.equalTo(28)
            make.width.equalTo(60)
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
        }
        
        textView.snp.makeConstraints { [unowned self](make) in
            make.left.equalTo(self.imageView.snp_right).offset(13)
            make.right.equalTo(self.sendButton.snp_left).offset(-13)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    //MARK: - UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
}
