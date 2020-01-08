//
//  ZSReaderBottomBar.swift
//  zhuishushenqi
//
//  Created by caony on 2020/1/8.
//  Copyright © 2020 QS. All rights reserved.
//

import UIKit

class ZSReaderBottomBar: UIView {

    lazy var progressBar:UISlider = {
        let bar = UISlider(frame: UIScreen.main.bounds)
        bar.minimumTrackTintColor = UIColor.white
        bar.maximumTrackTintColor = UIColor.gray
        return bar
    }()
    
    lazy var catalogButton:ZSReaderMenuButton = {
        let bt = ZSReaderMenuButton(type: .custom)
        bt.setTitle("目录", for: .normal)
        bt.setTitleColor(UIColor.white, for: .normal)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        bt.setImage(UIImage(named: "icon_tools_menu_30x30_"), for: .normal)
        return bt
    }()
    
    lazy var darkButton:ZSReaderMenuButton = {
        let bt = ZSReaderMenuButton(type: .custom)
        bt.setTitle("夜间", for: .normal)
        bt.setTitle("白天", for: .selected)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        bt.setImage(UIImage(named: "pic_day_46x46_"), for: .selected)
        bt.setImage(UIImage(named: "pic_night_46x46_"), for: .normal)
        bt.setTitleColor(UIColor.white, for: .normal)
        return bt
    }()
    
    lazy var settingButton:ZSReaderMenuButton = {
        let bt = ZSReaderMenuButton(type: .custom)
        bt.setTitle("设置", for: .normal)
        bt.setTitleColor(UIColor.white, for: .normal)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        bt.setImage(UIImage(named: "icon_tools_setting_30x30_"), for: .normal)
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
        addSubview(lastButton)
        addSubview(progressBar)
        addSubview(nextButton)
        addSubview(catalogButton)
        addSubview(darkButton)
        addSubview(settingButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lastButton.frame = CGRect(origin: CGPoint(x: 20, y: 20), size: CGSize(width: 60, height: 30))
        nextButton.frame = CGRect(x: self.bounds.width - 80, y: 20, width: 60, height: 30)
        progressBar.frame = CGRect(x: lastButton.frame.maxX + 10, y: 20, width: self.bounds.width - lastButton.frame.maxX * 2 - 20, height: 30)
        catalogButton.frame = CGRect(x: 20, y: lastButton.frame.maxY + 10, width: 30, height: 60)
        darkButton.frame = CGRect(x: self.bounds.width/2 - 20, y: lastButton.frame.maxY + 10, width: 30, height: 60)
        settingButton.frame = CGRect(x: self.bounds.width - 60, y: lastButton.frame.maxY + 10, width: 30, height: 60)

    }
    
}

class ZSReaderMenuButton:UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.width)
        titleLabel?.frame = CGRect(x: 0, y: (imageView?.frame.maxY ?? 30), width: self.bounds.width, height: 20)
        titleLabel?.textAlignment = .center
        
    }
}
