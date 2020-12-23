//
//  ZSForumToolBar.swift
//  zhuishushenqi
//
//  Created by yung on 2019/8/12.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit

protocol ZSForumToolBarDelegate:class {
    func toolBar(toolBar:ZSForumToolBar, clickLikeButton:UIButton)
    func toolBar(toolBar:ZSForumToolBar, clickShareButton:UIButton)
    func toolBar(toolBar:ZSForumToolBar, clickMoreButton:UIButton)

}

class ZSForumToolBar: UIView {
    
    weak var delegate:ZSForumToolBarDelegate?

    lazy var likeButton:UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "bbs_icon_like02_26_26"), for: .normal)
        button.addTarget(self, action: #selector(likeAction(btn:)), for: .touchUpInside)
        return button
    }()
    
    lazy var shareButton:UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "bbs_icon_share_26_26_26x26_"), for: .normal)
        button.addTarget(self, action: #selector(shareAction(btn:)), for: .touchUpInside)
        return button
    }()
    
    lazy var moreButton:UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "bbs_icon_more_big_26_26"), for: .normal)
        button.addTarget(self, action: #selector(moreAction(btn:)), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(likeButton)
        addSubview(shareButton)
        addSubview(moreButton)
        likeButton.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(52)
            make.height.equalTo(52)
        }
        shareButton.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(52)
            make.height.equalTo(52)
            make.centerX.equalToSuperview()
        }
        moreButton.snp.makeConstraints { (make) in
            make.right.top.bottom.equalToSuperview()
            make.width.equalTo(52)
            make.height.equalTo(52)
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

    }
    
    @objc
    private func likeAction(btn:UIButton) {
        delegate?.toolBar(toolBar: self, clickLikeButton: btn)
    }
    
    @objc
    private func shareAction(btn:UIButton) {
        delegate?.toolBar(toolBar: self, clickShareButton: btn)
    }
    
    @objc
    private func moreAction(btn:UIButton) {
        delegate?.toolBar(toolBar: self, clickMoreButton: btn)
    }
}
