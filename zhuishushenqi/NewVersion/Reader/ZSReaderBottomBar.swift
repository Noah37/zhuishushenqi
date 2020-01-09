//
//  ZSReaderBottomBar.swift
//  zhuishushenqi
//
//  Created by caony on 2020/1/8.
//  Copyright © 2020 QS. All rights reserved.
//

import UIKit

protocol ZSReaderBottomBarDelegate:class {
    func bottomBar(bottomBar:ZSReaderBottomBar, clickLast:UIButton)
    func bottomBar(bottomBar:ZSReaderBottomBar, clickNext:UIButton)
    func bottomBar(bottomBar:ZSReaderBottomBar, clickCatalog:UIButton)
    func bottomBar(bottomBar:ZSReaderBottomBar, clickDark:UIButton)
    func bottomBar(bottomBar:ZSReaderBottomBar, clickSetting:UIButton)
    func bottomBar(bottomBar:ZSReaderBottomBar, progress:Float)

}

class ZSReaderBottomBar: UIView {
    
    weak var delegate:ZSReaderBottomBarDelegate?

    lazy var progressBar:UISlider = {
        let bar = UISlider(frame: UIScreen.main.bounds)
        bar.minimumTrackTintColor = UIColor.white
        bar.maximumTrackTintColor = UIColor.gray
        bar.addTarget(self, action: #selector(sliderAction(slider:)), for: .valueChanged)
        return bar
    }()
    
    lazy var catalogButton:ZSReaderMenuButton = {
        let bt = ZSReaderMenuButton(type: .custom)
        bt.setTitle("目录", for: .normal)
        bt.setTitleColor(UIColor.white, for: .normal)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        bt.setImage(UIImage(named: "icon_tools_menu_30x30_"), for: .normal)
        bt.addTarget(self, action: #selector(catalogAction(bt:)), for: .touchUpInside)
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
        bt.addTarget(self, action: #selector(darkAction(bt:)), for: .touchUpInside)
        return bt
    }()
    
    lazy var settingButton:ZSReaderMenuButton = {
        let bt = ZSReaderMenuButton(type: .custom)
        bt.setTitle("设置", for: .normal)
        bt.setTitleColor(UIColor.white, for: .normal)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        bt.setImage(UIImage(named: "icon_tools_setting_30x30_"), for: .normal)
        bt.addTarget(self, action: #selector(settingAction(bt:)), for: .touchUpInside)
        return bt
    }()
    
    lazy var lastButton:UIButton = {
        let bt = UIButton(type: .custom)
        bt.setTitle("上一章", for: .normal)
        bt.setTitleColor(UIColor.white, for: .normal)
        bt.addTarget(self, action: #selector(lastAction(bt:)), for: .touchUpInside)
        return bt
    }()
    
    lazy var nextButton:UIButton = {
        let bt = UIButton(type: .custom)
        bt.setTitle("下一章", for: .normal)
        bt.setTitleColor(UIColor.white, for: .normal)
        bt.addTarget(self, action: #selector(nextAction(bt:)), for: .touchUpInside)
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
    
    @objc
    private func lastAction(bt:UIButton) {
        delegate?.bottomBar(bottomBar: self, clickLast: bt)
    }
    
    @objc
    private func nextAction(bt:UIButton) {
        delegate?.bottomBar(bottomBar: self, clickNext: bt)
    }
    
    @objc
    private func catalogAction(bt:UIButton) {
        delegate?.bottomBar(bottomBar: self, clickCatalog: bt)
    }
    
    @objc
    private func darkAction(bt:UIButton) {
        delegate?.bottomBar(bottomBar: self, clickDark: bt)
    }
    
    @objc
    private func settingAction(bt:UIButton) {
        delegate?.bottomBar(bottomBar: self, clickSetting: bt)
    }
    
    @objc
    private func sliderAction(slider:UISlider) {
        delegate?.bottomBar(bottomBar: self, progress: slider.value)
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
