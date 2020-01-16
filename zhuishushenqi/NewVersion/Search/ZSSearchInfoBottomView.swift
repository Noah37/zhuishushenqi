//
//  ZSSearchInfoBottomView.swift
//  zhuishushenqi
//
//  Created by caony on 2020/1/8.
//  Copyright © 2020 QS. All rights reserved.
//

import UIKit

protocol ZSSearchInfoBottomViewDelegate:class {
    func bottomView(bottomView:ZSSearchInfoBottomView, clickAdd:UIButton)
    func bottomView(bottomView:ZSSearchInfoBottomView, clickRead:UIButton)
}

class ZSSearchInfoBottomView: UIView {
    
    weak var delegate:ZSSearchInfoBottomViewDelegate?
    
    lazy var topLine:UIView = {
        let line = UIView(frame: .zero)
        line.backgroundColor = UIColor.gray
        return line
    }()
    
    lazy var addToShelfButton:UIButton = {
        let bt = UIButton(type: .custom)
        bt.setTitle("添加书架", for: .normal)
        bt.setTitleColor(UIColor.black, for: .normal)
        bt.setTitle("已在书架", for: .selected)
        bt.layer.cornerRadius = 20
        bt.layer.masksToBounds = true
        bt.layer.borderWidth = 0.3
        bt.layer.borderColor = UIColor.gray.cgColor
        bt.addTarget(self, action: #selector(addAction(bt:)), for: .touchUpInside)
        bt.setTitleColor(UIColor.gray, for: .selected)
        return bt
    }()
    
    lazy var startReadButton:UIButton = {
        let bt = UIButton(type: .custom)
        bt.setTitle("开始阅读", for: .normal)
        bt.layer.cornerRadius = 20
        bt.layer.masksToBounds = true
        bt.backgroundColor = UIColor.red
        bt.addTarget(self, action: #selector(readAction(bt:)), for: .touchUpInside)
        bt.setTitleColor(UIColor.white, for: .normal)
        return bt
    }()
    
    @objc
    private func addAction(bt:UIButton) {
        bt.isSelected = !bt.isSelected
        delegate?.bottomView(bottomView: self, clickAdd: bt)
    }
    
    @objc
    private func readAction(bt:UIButton) {
        delegate?.bottomView(bottomView: self, clickRead: bt)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        addSubview(topLine)
        addSubview(addToShelfButton)
        addSubview(startReadButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(book:ZSAikanParserModel) {
        self.addToShelfButton.isSelected = ZSShelfManager.share.exist(book.bookUrl)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        topLine.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 0.3)
        addToShelfButton.frame = CGRect(x: 20, y: 10, width: 170, height: 40)
        startReadButton.frame = CGRect(x: self.bounds.width - 190, y: 10, width: 170, height: 40)
    }
    
}
