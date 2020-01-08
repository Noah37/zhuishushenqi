//
//  ZSReaderTopbar.swift
//  zhuishushenqi
//
//  Created by caony on 2020/1/8.
//  Copyright © 2020 QS. All rights reserved.
//

import UIKit

protocol ZSReaderTopbarDelegate:class {
    func topBar(topBar:ZSReaderTopbar, clickBack:UIButton)
}

class ZSReaderTopbar: UIView {
    
    weak var delegate:ZSReaderTopbarDelegate?
    
    lazy var backButton:UIButton = {
        let bt = UIButton(type: .custom)
        bt.setTitle("返回", for: .normal)
        bt.setTitleColor(UIColor.white, for: .normal)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        bt.setImage(UIImage(named: "bg_back_white"), for: .normal)
        bt.addTarget(self, action: #selector(backAction(bt:)), for: .touchUpInside)
        return bt
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backButton)
        backgroundColor = UIColor.black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let statusHeight = UIApplication.shared.statusBarFrame.height
        backButton.frame = CGRect(x: 10, y: statusHeight + 5, width: 60, height: 30)
    }
    
    @objc
    private func backAction(bt:UIButton) {
        delegate?.topBar(topBar: self, clickBack: bt)
    }
}
