//
//  ZSSpeechView.swift
//  zhuishushenqi
//
//  Created by caony on 2018/9/23.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit


protocol ZSSpeechDelegate:class {
    // 改变朗读速度 0-100
    func speechView(speechView:ZSSpeechView, change speed:Float)
    
    // 变更发音人
    func speechView(speechView:ZSSpeechView, change speaker:Speaker)
    
    // 变更定时时间
    func speechView(speechView:ZSSpeechView, change time:TimeInterval)
}


class ZSSpeechView: UIView {
    
    fileprivate var speakers:[Speaker] = []

    fileprivate var timers:[[String:Any]] = [
        ["title":"5分钟","time":300.00],
        ["title":"15分钟","time":900.00],
        ["title":"30分钟","time":1800.00],
        ["title":"60分钟","time":3600.00]
    ]
    
    var startHandler:ZSBaseCallback<Bool>?
    
    var stopHandler:ZSBaseCallback<Void>?
    
    var speaker:Speaker {
        return speakers[Int(speakerPicker.selectedItem)]
    }
    
    weak var delegate:ZSSpeechDelegate?
    
    fileprivate lazy var backgroundView:UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight))
        view.isUserInteractionEnabled = true
        return view
    }()
    
    fileprivate lazy var readerView:UIView = {
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = UIColor.black
        view.alpha = 0.8
        view.isUserInteractionEnabled = true
        return view
    }()
    
    fileprivate lazy var speedSlider:UISlider = {
        let slider = UISlider(frame: CGRect.zero)
        slider.minimumTrackTintColor = UIColor.red
        slider.maximumValue = 100
        slider.minimumValue = 0
        slider.value = 50
        slider.addTarget(self, action: #selector(speedChange(slider:)), for: .valueChanged)
        return slider
    }()
    
    fileprivate lazy var timerPicker:AKPickerView = {
        let picker = AKPickerView(frame: CGRect.zero)
        picker.delegate = self;
        picker.dataSource = self;
        picker.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        picker.textColor = UIColor.white;
        picker.font = UIFont(name: "HelveticaNeue-Light", size: 17)
        picker.highlightedFont = UIFont(name: "HelveticaNeue", size: 17)
        picker.highlightedTextColor = UIColor(red: 1.0, green: 168.0/255.0, blue: 0.0, alpha: 1.0)
        picker.interitemSpacing = 20.0
        picker.fisheyeFactor = 0.001
        picker.pickerViewStyle = AKPickerViewStyle.styleFlat
        picker.isMaskDisabled = false
        return picker
    }()
    
    fileprivate lazy var speakerPicker:AKPickerView = {
        let picker = AKPickerView(frame: CGRect.zero)
        picker.delegate = self;
        picker.dataSource = self;
        picker.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        picker.textColor = UIColor.white;
        picker.font = UIFont(name: "HelveticaNeue-Light", size: 17)
        picker.highlightedFont = UIFont(name: "HelveticaNeue", size: 17)
        picker.highlightedTextColor = UIColor(red: 1.0, green: 168.0/255.0, blue: 0.0, alpha: 1.0)
        picker.interitemSpacing = 20.0
        picker.fisheyeFactor = 0.001
        picker.pickerViewStyle = AKPickerViewStyle.styleFlat
        picker.isMaskDisabled = false
        return picker
    }()
    
    fileprivate lazy var speedView:ZSSpeechLine = {
        let speedLine = ZSSpeechLine(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 60))
        speedLine.titleLabel.text = "语速:"
        return speedLine
    }()
    
    fileprivate lazy var speakerView:ZSSpeechLine = {
        let speedLine = ZSSpeechLine(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 60))
        speedLine.titleLabel.text = "发音:"
        return speedLine
    }()
    
    fileprivate lazy var timerView:ZSSpeechLine = {
        let speedLine = ZSSpeechLine(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 60))
        speedLine.titleLabel.text = "定时:"
        return speedLine
    }()
    
    fileprivate lazy var stopButton:UIButton = {
        let button = UIButton(type: .custom)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.setTitle("退出朗读", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 3
        return button
    }()
    
    fileprivate lazy var startButton:UIButton = {
        let button = UIButton(type: .custom)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.setTitle("开始", for: .normal)
        button.setTitle("暂停", for: .selected)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 3
        return button
    }()
    
    func show() {
        speakers = TTSConfig.share.availableSpeakers()
        speakerPicker.reloadData()
        KeyWindow?.addSubview(self)
    }
    
    func hiden() {
        removeFromSuperview()
    }
    
    @objc
    fileprivate func speedChange(slider:UISlider) {
        delegate?.speechView(speechView: self, change: slider.value)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(backgroundView)
        backgroundView.addSubview(readerView)
        readerView.addSubview(speedView)
        readerView.addSubview(speakerView)
        readerView.addSubview(timerView)
        readerView.addSubview(startButton)
        readerView.addSubview(stopButton)
        
        speedView.addSubview(speedSlider)
        speakerView.addSubview(speakerPicker)
        timerView.addSubview(timerPicker)
        
        speakers = TTSConfig.share.availableSpeakers()
        
        isUserInteractionEnabled = true
        
        stopButton.addTarget(self, action: #selector(stopAction(stop:)), for: .touchUpInside)
        startButton.addTarget(self, action: #selector(startAction(start:)), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        readerView.frame = CGRect(x: 0, y: ScreenHeight - 300, width: ScreenWidth, height: 300)
        speedView.frame = CGRect(x: 60, y: 0, width: readerView.frame.width - 120, height: 60)
        speakerView.frame = CGRect(x: 60, y: 60, width: speedView.frame.width, height: 60)
        timerView.frame = CGRect(x: 60, y: 120, width: speakerView.frame.width, height: 60)
        stopButton.frame = CGRect(x: 60, y: 180 + 30, width: ScreenWidth/2 - 70, height: 50)
        startButton.frame = CGRect(x: ScreenWidth - 60 - (ScreenWidth/2 - 70), y: timerView.bottom + 30, width: ScreenWidth/2 - 70, height: 50)
        speedSlider.frame = CGRect(x: 60, y: 0, width: speedView.frame.width - 100, height: speedView.frame.height)
        speakerPicker.frame = CGRect(x: 60, y: 0, width: speakerView.frame.width - 60, height: speakerView.frame.height)
        timerPicker.frame = CGRect(x: 60, y: 0, width: timerView.frame.width - 60, height: timerView.frame.height)

    }
    
    @objc
    func stopAction(stop:UIButton) {
        stopHandler?(nil)
    }
    
    @objc
    func startAction(start:UIButton) {
        start.isSelected = !start.isSelected
        startHandler?(start.isSelected)
    }
}

extension ZSSpeechView:AKPickerViewDataSource,AKPickerViewDelegate {
    func numberOfItems(in pickerView: AKPickerView!) -> UInt {
        
        if pickerView == speakerPicker {
            if speakers.count > 0 {
                return UInt(speakers.count)
            }
            return 1
        }
        return UInt(timers.count)
    }
    
    func pickerView(_ pickerView: AKPickerView!, titleForItem item: Int) -> String! {
        if pickerView == speakerPicker {
            if speakers.count > 0 {
                return speakers[item].nickname
            }
            return "在线优声"
        }
        return timers[item]["title"] as? String ?? ""
    }
    
    func pickerView(_ pickerView: AKPickerView!, didSelectItem item: Int) {
        if pickerView == speakerPicker {
            delegate?.speechView(speechView: self, change: speakers[item])
        } else {
            delegate?.speechView(speechView: self, change: timers[item]["time"] as? TimeInterval ?? 0.0)
        }
    }
}

class ZSSpeechLine: UIView {
    
    lazy var titleLabel:UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 15, width: 50, height: 30))
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        self.addSubview(self.titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
