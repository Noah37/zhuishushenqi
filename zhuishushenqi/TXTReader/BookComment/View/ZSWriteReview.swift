//
//  ZSWriteReview.swift
//  zhuishushenqi
//
//  Created by yung on 2018/11/7.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit

typealias ZSWriteReviewHandler = (_ text:String)->Void

class ZSWriteReview: UIView {

    var text:String = ""
    var closeButton:UIButton!
    var postButton:UIButton!
    var titleLabel:UILabel!
    var textView:UITextView!
    var backgroundView:UIView!
    var containerView:UIView!
    
    var postHandler:ZSWriteReviewHandler?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        backgroundView = UIView(frame: UIScreen.main.bounds)
        backgroundView.backgroundColor = UIColor(white: 0.2, alpha: 0.6)
        addSubview(backgroundView)
        
        containerView = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - 210, width: UIScreen.main.bounds.width, height: 210))
        containerView.backgroundColor = UIColor.black
        addSubview(containerView)
        
        closeButton = UIButton(type: .custom)
        closeButton.frame = CGRect(x: 20, y: 20, width: 50, height: 30)
        closeButton.setImage(UIImage(named: "forum_comment_cancel"), for: .normal)
        closeButton.setImage(UIImage(named: "forum_comment_cancel_selected"), for: .highlighted)

        closeButton.addTarget(self, action: #selector(closeAction(btn:)), for: .touchUpInside)
        containerView.addSubview(closeButton)
        
        postButton = UIButton(type: .custom)
        postButton.frame = CGRect(x: UIScreen.main.bounds.width - 70, y: 20, width: 50, height: 30)
        postButton.setImage(UIImage(named: "forum_comment_confirm_selected"), for: .normal)
        postButton.setImage(UIImage(named: "forum_comment_confirm_unable"), for: .disabled)
        postButton.addTarget(self, action: #selector(postAction(btn:)), for: .touchUpInside)
        postButton.isEnabled = false
        containerView.addSubview(postButton)
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: 20, width: UIScreen.main.bounds.width, height: 30))
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.text = "写评论"
        titleLabel.textColor = UIColor.white
        containerView.addSubview(titleLabel)
        
        textView = UITextView(frame: CGRect(x: 20, y: 70, width: UIScreen.main.bounds.width - 40, height: 120))
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.textColor = UIColor.black
        textView.layer.cornerRadius = 5
        textView.layer.masksToBounds = true
        textView.delegate = self
        containerView.addSubview(textView)
        
        NotificationCenter.qs_addObserver(observer: self, selector: #selector(keyboardWillShow(noti:)), name: UIWindow.keyboardWillShowNotification.rawValue, object: nil)
        NotificationCenter.qs_addObserver(observer: self, selector: #selector(keyboardWillHide(noti:)), name: UIWindow.keyboardWillHideNotification.rawValue, object: nil)
        
        textView.becomeFirstResponder()

    }

    @objc
    private func closeAction(btn:UIButton) {
        textView.resignFirstResponder()
        self.removeFromSuperview()
    }
    
    @objc
    private func postAction(btn:UIButton) {
        textView.resignFirstResponder()
        removeFromSuperview()
        postHandler?(textView.text)
    }
    
    @objc
    private func keyboardWillShow(noti:Notification) {
        if let rectValue = noti.userInfo?[UIWindow.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = rectValue.size.height
            UIView.animate(withDuration: 0.25) {
                self.containerView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 210 - keyboardHeight, width: UIScreen.main.bounds.width, height: 210)
            }
        }
    }
    
    @objc
    private func keyboardWillHide(noti:Notification) {
        if let _ = noti.userInfo?[UIWindow.keyboardFrameEndUserInfoKey] as? CGRect {
            UIView.animate(withDuration: 0.25) {
                self.containerView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 210 , width: UIScreen.main.bounds.width, height: 210)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        textView.resignFirstResponder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension ZSWriteReview:UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text != "" {
            postButton.isEnabled = true
        } else {
            postButton.isEnabled = false
        }
    }
}
