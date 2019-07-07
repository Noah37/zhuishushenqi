//
//  ZSDiscoverNavigationBar.swift
//  zhuishushenqi
//
//  Created by caony on 2019/7/2.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit

protocol ZSDiscoverNavigationBarDelegate:class {
    func nav(nav:ZSDiscoverNavigationBar, didClickSearch:UIButton)
}

class ZSDiscoverNavigationBar: UIView {
    
    lazy var titleLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "发现"
        return label
    }()
    
    lazy var searchButton:UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("搜索", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.clear
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setImage(UIImage(named: "bookshelf_icon_seach_34_34"), for: .normal)
        button.addTarget(self, action: #selector(loginAction(btn:)), for: .touchUpInside)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 15
        return button
    }()
    
    weak var delegate:ZSDiscoverNavigationBarDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(searchButton)
        self.backgroundColor = UIColor.init(hexString: "#A70A0B")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRect(x: 20, y: kNavgationBarHeight - 44, width: 80, height: 44)
        searchButton.frame = CGRect(x: bounds.width - 80, y: kNavgationBarHeight - 44, width: 70, height: 44)
    }
    
    @objc
    private func loginAction(btn:UIButton) {
        delegate?.nav(nav: self, didClickSearch: btn)
    }
}
