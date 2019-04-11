//
//  ZSVoicePlayerView.swift
//  zhuishushenqi
//
//  Created by caony on 2019/3/23.
//  Copyright © 2019年 QS. All rights reserved.
//

import UIKit

protocol ZSVoicePlayerDelegate {
    func playerView(playerView:ZSVoicePlayerView, didClickPauseButton:UIButton)
    func playerView(playerView:ZSVoicePlayerView, didClickLastButton:UIButton)
    func playerView(playerView:ZSVoicePlayerView, didClickNextButton:UIButton)
    func playerView(playerView:ZSVoicePlayerView, didClickCatelogButton:UIButton)
    func playerView(playerView:ZSVoicePlayerView, didClickShelfButton:UIButton)
    func playerView(playerView:ZSVoicePlayerView, didClickTimerButton:UIButton)
    func playerView(playerView:ZSVoicePlayerView, valueChangedTo seconds:Float)
}

class ZSVoicePlayerView: UIView,ZSVoicePlayerProgressDelegate {

    fileprivate var progressBar:ZSVoicePlayProgressView!
    fileprivate var catelogButton:UIButton!
    fileprivate var shelfButton:UIButton!
    fileprivate var lastButton:UIButton!
    fileprivate var pauseButton:UIButton!
    fileprivate var nextButton:UIButton!
    fileprivate var timerButton:UIButton!
    
    var progress:Float = 0 {
        didSet {
            self.progressBar.progress = progress
        }
    }
    
    var currentSeconds:UInt = 0 {
        didSet {
            self.progressBar.currentSeconds = currentSeconds
        }
    }
    
    var playerDelegate:ZSVoicePlayerDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubview()
    }
    
    func bind(track:XMTrack) {
        progressBar.bind(track: track)
    }
    
    func didStartPlay() {
        pauseButton.isSelected = true
    }
    
    func didFailedToPlay() {
        pauseButton.isSelected = false
    }
    
    private func setupSubview() {
        progressBar = ZSVoicePlayProgressView(frame: CGRect.zero)
        progressBar.delegate = self
        addSubview(progressBar)
        
        catelogButton = UIButton(type: .custom)
        catelogButton.addTarget(self, action: #selector(catelogAction(btn:)), for: .touchUpInside)
        catelogButton.setImage(UIImage(named: "discover_icon_more_24_24"), for: .normal)
        addSubview(catelogButton)
        
        lastButton = UIButton(type: .custom)
        lastButton.addTarget(self, action: #selector(lastAction(btn:)), for: .touchUpInside)
        lastButton.setImage(UIImage(named: "discover_icon_up_36_36"), for: .normal)
        addSubview(lastButton)
        
        nextButton = UIButton(type: .custom)
        nextButton.addTarget(self, action: #selector(nextAction(btn:)), for: .touchUpInside)
        nextButton.setImage(UIImage(named: "discover_icon_next_36_36"), for: .normal)
        addSubview(nextButton)
        
        pauseButton = UIButton(type: .custom)
        pauseButton.addTarget(self, action: #selector(pauseAction(btn:)), for: .touchUpInside)
        pauseButton.setImage(UIImage(named: "discover_icon_pouse_76_76"), for: .normal)
        pauseButton.setImage(UIImage(named: "discover_icon_play_76_76"), for: .selected)
        addSubview(pauseButton)
        
        shelfButton = UIButton(type: .custom)
        shelfButton.addTarget(self, action: #selector(shelfAction(btn:)), for: .touchUpInside)
        shelfButton.setImage(UIImage(named: "discover_icon_bookshelf_24_24_p"), for: .normal)
        shelfButton.setImage(UIImage(named: "discover_icon_bookshelf_24_24"), for: .selected)
        addSubview(shelfButton)
        
        timerButton = UIButton(type: .custom)
        timerButton.addTarget(self, action: #selector(timerAction(btn:)), for: .touchUpInside)
        timerButton.setImage(UIImage(named: "discover_icon_timing_24_24"), for: .normal)
        addSubview(timerButton)
        
    }
    
    @objc
    private func catelogAction(btn:UIButton) {
        playerDelegate?.playerView(playerView: self, didClickCatelogButton: btn)
    }
    
    @objc
    private func shelfAction(btn:UIButton) {
        btn.isSelected = !btn.isSelected
        playerDelegate?.playerView(playerView: self, didClickShelfButton: btn)
    }
    
    @objc
    private func timerAction(btn:UIButton) {
        playerDelegate?.playerView(playerView: self, didClickTimerButton: btn)
    }
    
    @objc
    private func lastAction(btn:UIButton) {
        playerDelegate?.playerView(playerView: self, didClickLastButton: btn)
    }
    
    @objc
    private func pauseAction(btn:UIButton) {
        btn.isSelected = !btn.isSelected
        playerDelegate?.playerView(playerView: self, didClickPauseButton: btn)
    }
    
    @objc
    private func nextAction(btn:UIButton) {
        playerDelegate?.playerView(playerView: self, didClickNextButton: btn)
    }
    
    //MARK: - ZSVoicePlayerProgressDelegate
    func playerProgressView(playerProgressView: ZSVoicePlayProgressView, valueChangedTo seconds: Float) {
        playerDelegate?.playerView(playerView: self, valueChangedTo: seconds)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        progressBar.snp.remakeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(100)
        }
        
        lastButton.snp.remakeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(self.progressBar.bottom + 7)
            make.width.equalTo(36)
            make.height.equalTo(36)
        }
        
        pauseButton.snp.remakeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.progressBar.bottom + 7)
            make.width.equalTo(36)
            make.height.equalTo(36)
        }
        
        nextButton.snp.remakeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(self.progressBar.bottom + 7)
            make.width.equalTo(36)
            make.height.equalTo(36)
        }
        
        catelogButton.snp.remakeConstraints { (make) in
            make.left.equalToSuperview()
            make.bottom.equalToSuperview().offset(-18)
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
        
        shelfButton.snp.remakeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-18)
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
        
        timerButton.snp.remakeConstraints { (make) in
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-18)
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
