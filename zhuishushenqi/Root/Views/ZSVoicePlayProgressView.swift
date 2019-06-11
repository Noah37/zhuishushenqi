//
//  ZSVoicePlayProgressView.swift
//  zhuishushenqi
//
//  Created by caony on 2019/3/23.
//  Copyright © 2019年 QS. All rights reserved.
//

import UIKit

protocol ZSVoicePlayerProgressDelegate {
    func playerProgressView(playerProgressView:ZSVoicePlayProgressView, valueChangedTo seconds:Float)
}

class ZSVoicePlayProgressView: UIView {

    fileprivate var startTimeLabel:UILabel!
    fileprivate var totalTimeLabel:UILabel!
    fileprivate var progressBar:UISlider!
    fileprivate var track:XMTrack?
    
    var delegate:ZSVoicePlayerProgressDelegate?
    
    var progress:Float = 0 {
        didSet {
            progressBar.value = progress
        }
    }
    
    var currentSeconds:UInt = 0 {
        didSet {
            updateStartLabel()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    private func setupSubviews() {
        isUserInteractionEnabled = true
        progressBar = UISlider(frame: CGRect.zero)
        progressBar.thumbTintColor = UIColor.red
        progressBar.minimumTrackTintColor = UIColor.red
        progressBar.addTarget(self, action: #selector(sliderChange), for: .valueChanged)
        progressBar.minimumValue = 0
        progressBar.maximumValue = 1.0
        progressBar.value = 0.5
        addSubview(progressBar)
        
        startTimeLabel = UILabel()
        startTimeLabel.textColor = UIColor.gray
        startTimeLabel.font = UIFont.systemFont(ofSize: 13)
        startTimeLabel.textAlignment = .left
        startTimeLabel.text = "00:00"
        addSubview(startTimeLabel)
        
        totalTimeLabel = UILabel()
        totalTimeLabel.textColor = UIColor.gray
        totalTimeLabel.font = UIFont.systemFont(ofSize: 13)
        totalTimeLabel.textAlignment = .right
        totalTimeLabel.text = "00:00"
        addSubview(totalTimeLabel)
    }
    
    @objc
    private func sliderChange() {
        let seconds = Float(self.track?.duration ?? 0) * self.progressBar.value
        self.currentSeconds = UInt(seconds)
        updateStartLabel()
        delegate?.playerProgressView(playerProgressView: self, valueChangedTo: seconds)
    }
    
    func bind(track:XMTrack) {
        self.track = track
        updateTotalLabel(with: track)
    }
    
    func updateTotalLabel(with track:XMTrack) {
        var hours = 0
        var minutes = track.duration/60
        let seconds = track.duration%60
        if minutes > 60 {
            hours = minutes/60
            minutes = minutes%60
        }
        var totalTimeText = ""
        if hours > 0 {
            let hoursText = getZeroDefaultText(text: "\(hours)")
            let minutedText = getZeroDefaultText(text: "\(minutes)")
            let secondText = getZeroDefaultText(text: "\(seconds)")
            totalTimeText = "\(hoursText):\(minutedText):\(secondText)"
        } else if minutes > 0 {
            let minutedText = getZeroDefaultText(text: "\(minutes)")
            let secondText = getZeroDefaultText(text: "\(seconds)")
            totalTimeText = "\(minutedText):\(secondText)"
        } else {
            let secondText = getZeroDefaultText(text: "\(seconds)")
            totalTimeText = "00:\(secondText)"
        }
        totalTimeLabel.text = totalTimeText
    }
    
    func getZeroDefaultText(text:String) ->String {
        var zeroText:String = text
        if zeroText.count <= 1 {
            zeroText = "0\(zeroText)"
        }
        return zeroText
    }
    
    func updateStartLabel() {
        var hours = 0
        var minutes = Int(currentSeconds)/60
        let seconds = Int(currentSeconds)%60
        if minutes > 60 {
            hours = minutes/60
            minutes = minutes%60
        }
        var startTimeText = ""
        if hours > 0 {
            let hoursText = getZeroDefaultText(text: "\(hours)")
            let minutedText = getZeroDefaultText(text: "\(minutes)")
            let secondText = getZeroDefaultText(text: "\(seconds)")
            startTimeText = "\(hoursText):\(minutedText):\(secondText)"
        } else if minutes > 0 {
            let minutedText = getZeroDefaultText(text: "\(minutes)")
            let secondText = getZeroDefaultText(text: "\(seconds)")
            startTimeText = "\(minutedText):\(secondText)"
        } else {
            let secondText = getZeroDefaultText(text: "\(seconds)")
            startTimeText = "00:\(secondText)"
        }
        startTimeLabel.text = startTimeText
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        progressBar.snp.remakeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(15)
        }
        
        startTimeLabel.snp.remakeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(self.progressBar.bottom + 15)
            make.width.equalTo(self.bounds.width/2)
            make.height.equalTo(15)
        }
        
        totalTimeLabel.snp.remakeConstraints { (make) in
            make.right.equalToSuperview()
            make.top.equalTo(self.progressBar.bottom + 15)
            make.width.equalTo(self.bounds.width/2)
            make.height.equalTo(15)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
