//
//  ZSReaderBottomBar.swift
//  zhuishushenqi
//
//  Created by caony on 2020/1/8.
//  Copyright © 2020 QS. All rights reserved.
//

import UIKit

class ZSReaderBottomBar: UIView {

    lazy var progressBar:UIProgressView = {
        let bar = UIProgressView(progressViewStyle: UIProgressView.Style.bar)
        return bar
    }()
    
    lazy var catalogButton:UIButton = {
        let bt = UIButton(type: .custom)
        bt.setTitle("目录", for: .normal)
        bt.setTitleColor(UIColor.white, for: .normal)
        return bt
    }()
    
    lazy var darkButton:UIButton = {
        let bt = UIButton(type: .custom)
        bt.setTitle("夜间", for: .normal)
        bt.setTitle("白天", for: .selected)
        bt.setTitleColor(UIColor.white, for: .normal)
        return bt
    }()
    
    lazy var settingButton:UIButton = {
        let bt = UIButton(type: .custom)
        bt.setTitle("设置", for: .normal)
        bt.setTitleColor(UIColor.white, for: .normal)
        return bt
    }()
    
    lazy var lastButton:UIButton = {
        let bt = UIButton(type: .custom)
        bt.setTitle("上一章", for: .normal)
        bt.setTitleColor(UIColor.white, for: .normal)
        return bt
    }()
    
    lazy var nextButton:UIButton = {
        let bt = UIButton(type: .custom)
        bt.setTitle("下一章", for: .normal)
        bt.setTitleColor(UIColor.white, for: .normal)
        return bt
    }()
    
    private init() {
        super.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lastButton.frame = CGRect(origin: CGPoint(x: 20, y: 20), size: CGSize(width: 60, height: 30))
        nextButton.frame = CGRect(x: self.bounds.width - 80, y: 20, width: 60, height: 30)
        progressBar.frame = CGRect(x: lastButton.frame.maxX + 10, y: 20, width: self.bounds.width - lastButton.frame.maxX * 2, height: 30)
        catalogButton.frame = CGRect(x: 20, y: lastButton.frame.maxY + 20, width: 40, height: 40)
        darkButton.frame = CGRect(x: self.bounds.width/2 - 20, y: lastButton.frame.maxY + 20, width: 40, height: 40)
        settingButton.frame = CGRect(x: self.bounds.width - 60, y: lastButton.frame.maxY + 20, width: 40, height: 40)

    }
    
}
