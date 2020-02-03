//
//  ZSReaderBottomBigBar.swift
//  zhuishushenqi
//
//  Created by caony on 2020/1/11.
//  Copyright © 2020 QS. All rights reserved.
//

import UIKit

protocol ZSReaderBottomBigBarDelegate:class {
    func bigBar(bigBar:ZSReaderBottomBigBar, progress:Float)
    func bigBar(bigBar:ZSReaderBottomBigBar, readerStyle:ZSReaderStyle)
    func bigBar(bigBar:ZSReaderBottomBigBar, fontAdd:UIButton)
    func bigBar(bigBar:ZSReaderBottomBigBar, fontPlus:UIButton)
    func bigBar(bigBar:ZSReaderBottomBigBar, animationStyle:UIButton)
}

class ZSReaderBottomBigBar: UIView, ZSReaderThemeSelectionViewDelegate {
    
    weak var delegate:ZSReaderBottomBigBarDelegate?

    lazy var progressBar:UISlider = {
        let bar = UISlider(frame: UIScreen.main.bounds)
        bar.minimumTrackTintColor = UIColor.white
        bar.maximumTrackTintColor = UIColor.gray
        bar.minimumValue = 0.0
        bar.maximumValue = 1.0
        bar.value = 1.0
        bar.addTarget(self, action: #selector(sliderAction(slider:)), for: .valueChanged)
        return bar
    }()
    
    lazy var animationButton:ZSReaderMenuButton = {
        let bt = ZSReaderMenuButton(type: .custom)
        bt.setTitle("翻页动画", for: .normal)
        bt.setTitleColor(UIColor.white, for: .normal)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        bt.setImage(UIImage(named: "icon_tools_menu_30x30_"), for: .normal)
        bt.addTarget(self, action: #selector(catalogAction(bt:)), for: .touchUpInside)
        return bt
    }()
    
    lazy var eyeButton:ZSReaderMenuButton = {
        let bt = ZSReaderMenuButton(type: .custom)
        bt.setTitle("护眼模式", for: .normal)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        bt.setImage(UIImage(named: "pic_day_46x46_"), for: .selected)
        bt.setImage(UIImage(named: "pic_night_46x46_"), for: .normal)
        bt.setTitleColor(UIColor.white, for: .normal)
        bt.addTarget(self, action: #selector(darkAction(bt:)), for: .touchUpInside)
        return bt
    }()
    
    lazy var autoButton:ZSReaderMenuButton = {
        let bt = ZSReaderMenuButton(type: .custom)
        bt.setTitle("自动阅读", for: .normal)
        bt.setTitleColor(UIColor.white, for: .normal)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        bt.setImage(UIImage(named: "icon_tools_setting_30x30_"), for: .normal)
        bt.addTarget(self, action: #selector(settingAction(bt:)), for: .touchUpInside)
        return bt
    }()
    
    lazy var moreButton:ZSReaderMenuButton = {
        let bt = ZSReaderMenuButton(type: .custom)
        bt.setTitle("更多", for: .normal)
        bt.setTitleColor(UIColor.white, for: .normal)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        bt.setImage(UIImage(named: "icon_tools_setting_30x30_"), for: .normal)
        bt.addTarget(self, action: #selector(settingAction(bt:)), for: .touchUpInside)
        return bt
    }()
    
    lazy var lightPlusButton:UIButton = {
        let bt = UIButton(type: .custom)
        bt.setImage(UIImage(named: "QDReaderSetting_brightnessDown_24x24_"), for: .normal)
        bt.setTitleColor(UIColor.white, for: .normal)
        bt.addTarget(self, action: #selector(lastAction(bt:)), for: .touchUpInside)
        return bt
    }()
    
    lazy var lightAddButton:UIButton = {
        let bt = UIButton(type: .custom)
        bt.setImage(UIImage(named: "QDReaderSetting_brightnessUp_24x24_"), for: .normal)
        bt.setTitleColor(UIColor.white, for: .normal)
        bt.addTarget(self, action: #selector(nextAction(bt:)), for: .touchUpInside)
        return bt
    }()
    
    lazy var fontAddButton:UIButton = {
       let bt = UIButton(type: .custom)
//       bt.setImage(UIImage(named: ""), for: .normal)
        bt.setTitle("A+", for: .normal)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: 22)
       bt.setTitleColor(UIColor.white, for: .normal)
        bt.layer.cornerRadius = 20
        bt.layer.masksToBounds = true
        bt.layer.borderColor = UIColor.white.cgColor
        bt.layer.borderWidth = 0.5
       bt.addTarget(self, action: #selector(fontAddAction(bt:)), for: .touchUpInside)
       return bt
    }()
    
    lazy var fontPlusButton:UIButton = { // 72.5
       let bt = UIButton(type: .custom)
//       bt.setImage(UIImage(named: ""), for: .normal)
        bt.setTitle("A-", for: .normal)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: 22)
       bt.setTitleColor(UIColor.white, for: .normal)
        bt.layer.cornerRadius = 20
        bt.layer.masksToBounds = true
        bt.layer.borderColor = UIColor.white.cgColor
        bt.layer.borderWidth = 0.5
       bt.addTarget(self, action: #selector(fontPlusAction(bt:)), for: .touchUpInside)
       return bt
    }()
    
    lazy var fontButton:UIButton = {
       let bt = UIButton(type: .custom)
       bt.setImage(UIImage(named: ""), for: .normal)
        bt.setTitle("系统字体", for: .normal)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: 15)
       bt.setTitleColor(UIColor.white, for: .normal)
        bt.layer.cornerRadius = 20
        bt.layer.masksToBounds = true
        bt.layer.borderColor = UIColor.white.cgColor
        bt.layer.borderWidth = 0.5
       bt.addTarget(self, action: #selector(nextAction(bt:)), for: .touchUpInside)
       return bt
    }()
    
    lazy var fontSizeLabel:UILabel = {
        let lb = UILabel(frame: .zero)
        lb.textColor = UIColor.white
        lb.textAlignment = .center
        lb.font = UIFont.systemFont(ofSize: 13)
        lb.text = "\(ZSReader.share.theme.fontSize.size)"
       return lb
    }()
    
    lazy var selectionView:ZSReaderThemeSelectionView = {
        let view = ZSReaderThemeSelectionView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 40))
        view.delegate = self
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(lightPlusButton)
        addSubview(progressBar)
        addSubview(lightAddButton)
        addSubview(fontPlusButton)
        addSubview(fontSizeLabel)
        addSubview(fontAddButton)
        addSubview(fontButton)
        addSubview(selectionView)
        addSubview(animationButton)
        addSubview(eyeButton)
        addSubview(autoButton)
        addSubview(moreButton)

        backgroundColor = UIColor.black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lightPlusButton.frame = CGRect(origin: CGPoint(x: 20, y: 20), size: CGSize(width: 24, height: 30))
        lightAddButton.frame = CGRect(x: self.bounds.width - 44, y: 20, width: 24, height: 30)
        progressBar.frame = CGRect(x: lightPlusButton.frame.maxX + 10, y: 20, width: self.bounds.width - lightPlusButton.frame.maxX * 2 - 20, height: 30)
        fontPlusButton.frame = CGRect(x: 20, y: lightPlusButton.frame.maxY + 20, width: 82.5, height: 40)
        fontSizeLabel.frame = CGRect(x: fontPlusButton.frame.maxX , y: lightPlusButton.frame.maxY + 20, width: 40, height: 40)
        fontAddButton.frame = CGRect(x: fontSizeLabel.frame.maxX, y: lightPlusButton.frame.maxY + 20, width: 82.5, height: 40)
        fontButton.frame = CGRect(x: self.bounds.width - 82.5 - 20, y: lightPlusButton.frame.maxY + 20, width: 82.5, height: 40)
        selectionView.frame = CGRect(x: 0, y: fontPlusButton.frame.maxY + 20, width: self.bounds.width, height: 40)
        let animationWidth:CGFloat = 50
        let spaceX:CGFloat = (self.bounds.width - 40 - animationWidth * 4)/3.0
        animationButton.frame = CGRect(x: 20, y: selectionView.frame.maxY + 20, width: animationWidth, height: 60)
        eyeButton.frame = CGRect(x: 20 + animationWidth + spaceX, y: selectionView.frame.maxY + 20, width: animationWidth, height: 60)
        autoButton.frame = CGRect(x: 20 + animationWidth * 2 + spaceX * 2, y: selectionView.frame.maxY + 20, width: animationWidth, height: 60)
        moreButton.frame = CGRect(x: 20 + animationWidth * 3 + spaceX * 3, y: selectionView.frame.maxY + 20, width: animationWidth, height: 60)

    }
    
    @objc
    private func fontAddAction(bt:UIButton) {
        delegate?.bigBar(bigBar: self, fontAdd: bt)
    }
    
    @objc
    private func fontPlusAction(bt:UIButton) {
        delegate?.bigBar(bigBar: self, fontPlus: bt)
    }
    
    @objc
    private func nextAction(bt:UIButton) {
        
    }
    
    @objc
    private func lastAction(bt:UIButton) {
        
    }
    
    @objc
    private func settingAction(bt:UIButton) {
        
    }
    
    @objc
    private func darkAction(bt:UIButton) {
        
    }
    
    @objc
    private func catalogAction(bt:UIButton) {
        delegate?.bigBar(bigBar: self, animationStyle: bt)
    }
    
    @objc
    private func sliderAction(slider:UISlider) {
        let brightness = ZSReader.share.theme.brightness
        let scale = 1/(brightness.maxValue - brightness.minValue)
        let progress = brightness.maxValue - ((slider.value - slider.minimumValue) / scale + brightness.minValue)
        delegate?.bigBar(bigBar: self, progress: progress)
    }
    
    //MARK: - ZSReaderThemeSelectionViewDelegate
    func selectionView(selectionView: ZSReaderThemeSelectionView, select: ZSReaderStyle) {
        delegate?.bigBar(bigBar: self, readerStyle: select)
    }
}
