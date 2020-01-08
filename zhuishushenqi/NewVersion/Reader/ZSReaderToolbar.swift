//
//  ZSReaderToolbar.swift
//  zhuishushenqi
//
//  Created by caony on 2020/1/8.
//  Copyright © 2020 QS. All rights reserved.
//

import UIKit

class ZSReaderToolbar: UIView {
    
    lazy var bgView:UIView = {
        let view = UIView()
        return view
    }()

    lazy var topBar:ZSReaderTopbar = {
        let top = ZSReaderTopbar()
        return top
    }()
    
    lazy var bottomBar:ZSReaderBottomBar = {
        let bar = ZSReaderBottomBar(frame: CGRect(x: 0, y: self.bounds.height - 130, width: self.bounds.width, height: 130))
        return bar
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(topBar)
        addSubview(bottomBar)
    }
    
    static func show() {
        let toolBar = ZSReaderToolbar(frame: UIScreen.main.bounds)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
