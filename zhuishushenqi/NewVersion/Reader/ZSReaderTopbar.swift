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
    func topBar(topBar:ZSReaderTopbar, clickListen:UIButton)
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
    
    lazy var titleLabel:UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.textColor = UIColor.white
        view.font = UIFont.systemFont(ofSize: 17)
        return view
    }()
    
    lazy var listenButton:UIButton = {
        let bt = UIButton(type: .custom)
        bt.setImage(UIImage(named: "readAloud"), for: .normal)
        bt.addTarget(self, action: #selector(listenAction(bt:)), for: .touchUpInside)
        return bt
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backButton)
        addSubview(titleLabel)
        addSubview(listenButton)
        backgroundColor = UIColor.black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let statusHeight = UIApplication.shared.statusBarFrame.height
        backButton.frame = CGRect(x: 10, y: statusHeight + 5, width: 60, height: 30)
        titleLabel.frame = CGRect(origin: CGPoint(x: 70, y: statusHeight + 5), size: CGSize(width: ScreenWidth - 140, height: 30))
        listenButton.frame = CGRect(origin: CGPoint(x: self.bounds.size.width - 50, y: statusHeight), size: CGSize(width: 49, height: 49))
    }
    
    @objc
    private func backAction(bt:UIButton) {
        delegate?.topBar(topBar: self, clickBack: bt)
    }
    
    @objc
    private func listenAction(bt:UIButton) {
        delegate?.topBar(topBar: self, clickListen: bt)
    }
}
