//
//  ZSVoicePlayerViewController.swift
//  zhuishushenqi
//
//  Created by caony on 2019/3/23.
//  Copyright © 2019年 QS. All rights reserved.
//

import UIKit

class ZSVoicePlayerViewController: UIViewController {

    var album:XMAlbum?
    
    var tracks:[XMTrack] = []
    
    private func requestTrack() {
        if let albumValue = album {
            var count = 20
            if albumValue.includeTrackCount >= 1 && albumValue.includeTrackCount <= 200 {
                count = albumValue.includeTrackCount
            }
            let params = ["album_id":albumValue.albumId,
                          "count":count,
                          "page":1]
            XMReqMgr.sharedInstance()?.requestXMData(XMReqType.albumsBrowse, params: params, withCompletionHander: { (result, error) in
                if let dict = result as? [String:Any] {
                    if let albumArr = dict["tracks"] as? [[AnyHashable : Any]] {
                        var albumsModel:[XMTrack] = []
                        for item in albumArr {
                            if let albumModel = XMTrack(dictionary: item) {
                                albumsModel.append(albumModel)
                            }
                        }
                        self.tracks = albumsModel
                        self.play()
                    }
                }
            })
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupSubview()
        requestTrack()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        layoutSubview()
    }
    
    override func viewWillLayoutSubviews() {
        layoutSubview()
    }
    
    private func play() {
        if self.tracks.count > 0 {
            XMSDKPlayer.shared()?.trackPlayDelegate = self
            XMSDKPlayer.shared()?.setVolume(0.5)
            XMSDKPlayer.shared()?.setPlayMode(XMSDKPlayMode.track)
            XMSDKPlayer.shared()?.setTrackPlayMode(XMSDKTrackPlayMode.XMTrackPlayerModeList)
            XMSDKPlayer.shared()?.play(with: self.tracks[0], playlist: self.tracks)
            XMSDKPlayer.shared()?.setAutoNexTrack(true)
            refreshView(track: self.tracks[0])
        }
    }
    
    private func refreshView(track:XMTrack) {
        let coverUrlLarge = track.coverUrlLarge ?? ""
        if let url = URL(string: coverUrlLarge) {
            let resource = QSResource(url: url)
            self.imageView.kf.setImage(with: resource, placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
            self.descLabel.text = track.trackTitle
            self.sourceLabel.text = "内容来自喜马拉雅FM"
        }
    }
    
    private func layoutSubview() {
        descLabel.snp.remakeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(40)
            make.height.equalTo(20)
        }
        
        imageView.snp.remakeConstraints { (make) in
            make.left.equalToSuperview().offset(self.view.bounds.width/3)
            make.right.equalToSuperview().offset(-self.view.bounds.width/3)
            make.top.equalTo(self.descLabel.snp.bottom).offset(80)
            make.height.equalTo(self.view.bounds.width/3)
        }
        
        sourceLabel.snp.remakeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.imageView.snp.bottom).offset(30)
            make.height.equalTo(20)
        }
        
        playerView.snp.remakeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(200)
        }
        imageView.qs_addCornerRadius(cornerRadius: 4)
        imageView.addShadow(cornerRadius: 4)
    }
    
    private func setupSubview() {
        
        descLabel = UILabel(frame: CGRect.zero)
        descLabel.textAlignment = .center
        descLabel.textColor = UIColor.gray
        descLabel.font = UIFont.systemFont(ofSize: 15)
        
        imageView = UIImageView(frame: CGRect.zero)
        
        sourceLabel = UILabel(frame: CGRect.zero)
        sourceLabel.textAlignment = .center
        sourceLabel.textColor = UIColor.gray
        sourceLabel.font = UIFont.systemFont(ofSize: 15)
        
        playerView = ZSVoicePlayerView(frame: CGRect.zero)
        playerView.playerDelegate = self
        playerView.isUserInteractionEnabled = true
        view.addSubview(descLabel)
        view.addSubview(imageView)
        view.addSubview(sourceLabel)
        view.addSubview(playerView)

    }
    
//    fileprivate var titleLabel:UILabel!
    fileprivate var descLabel:UILabel!
//    fileprivate var imageBackgroundView:UIView!
    fileprivate var imageView:UIImageView!
    fileprivate var sourceLabel:UILabel!
    fileprivate var playerView:ZSVoicePlayerView!

}

extension ZSVoicePlayerViewController:XMTrackPlayerDelegate {
    
    func xmTrackPlayNotifyProcess(_ percent: CGFloat, currentSecond: UInt) {
        playerView.progress = Float(percent)
        playerView.currentSeconds = currentSecond
    }
    
    func xmTrackPlayerWillPlaying() {
        if let track = XMSDKPlayer.shared()?.currentTrack() {
            
            playerView.bind(track: track)
        }
    }
    
    func xmTrackPlayerDidPlaying() {
        playerView.didStartPlay()
    }
    
    func xmTrackPlayerDidFailed(toPlay track: XMTrack!, withError error: Error!) {
        playerView.didFailedToPlay()
    }
    
    func xmTrackPlayerDidError(withType type: String!, withData data: [AnyHashable : Any]!) {
        playerView.didFailedToPlay()
    }
}

extension ZSVoicePlayerViewController:ZSVoicePlayerDelegate {
    func playerView(playerView: ZSVoicePlayerView, didClickPauseButton: UIButton) {
        if self.tracks.count > 0 {
            if didClickPauseButton.isSelected {
                if XMSDKPlayer.shared()?.playerState == XMSDKPlayerState.paused {
                    XMSDKPlayer.shared()?.resumeTrackPlay()
                } else {
                    play()
                }
            } else {
                XMSDKPlayer.shared()?.pauseTrackPlay()
            }
        }
        
    }
    
    func playerView(playerView: ZSVoicePlayerView, didClickLastButton: UIButton) {
        
    }
    
    func playerView(playerView: ZSVoicePlayerView, didClickNextButton: UIButton) {
        
    }
    
    func playerView(playerView: ZSVoicePlayerView, didClickCatelogButton: UIButton) {
        
    }
    
    func playerView(playerView: ZSVoicePlayerView, didClickShelfButton: UIButton) {
        
    }
    
    func playerView(playerView: ZSVoicePlayerView, didClickTimerButton: UIButton) {
        
    }
    
    func playerView(playerView: ZSVoicePlayerView, valueChangedTo seconds: Float) {
        XMSDKPlayer.shared()?.seek(toTime: CGFloat(seconds))
    }
}
