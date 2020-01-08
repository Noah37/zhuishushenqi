//
//  ZSReaderToolbar.swift
//  zhuishushenqi
//
//  Created by caony on 2020/1/8.
//  Copyright © 2020 QS. All rights reserved.
//

import UIKit

protocol ZSReaderToolbarDelegate:class {
    func toolBar(toolBar:ZSReaderToolbar, clickBack:UIButton)
}

class ZSReaderToolbar: UIView, ZSReaderTopbarDelegate {
    
    weak var delegate:ZSReaderToolbarDelegate?
    
    lazy var bgView:UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
        return view
    }()

    lazy var topBar:ZSReaderTopbar = {
        let top = ZSReaderTopbar(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: kNavgationBarHeight))
        top.delegate = self
        return top
    }()
    
    lazy var bottomBar:ZSReaderBottomBar = {
        let bar = ZSReaderBottomBar(frame: CGRect(x: 0, y: self.bounds.height - 130, width: self.bounds.width, height: 140))
        return bar
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        addSubview(topBar)
        addSubview(bottomBar)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        bgView.addGestureRecognizer(tap)
    }
    
    func show(inView:UIView) {
        inView.addSubview(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func tapAction() {
        removeFromSuperview()
    }
    
    //MARK: - ZSReaderTopbarDelegate
    func topBar(topBar: ZSReaderTopbar, clickBack: UIButton) {
        removeFromSuperview()
        delegate?.toolBar(toolBar: self, clickBack: clickBack)
    }
}
