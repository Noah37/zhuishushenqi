//
//  ZSVoicePlayViewController.swift
//  zhuishushenqi
//
//  Created by caony on 2019/3/23.
//  Copyright © 2019年 QS. All rights reserved.
//

import UIKit

class ZSVoicePlayViewController: BaseViewController, ZSSegmentProtocol {
    
    
    var album:XMAlbum = XMAlbum()
    var albums:[XMAlbum] = []
    fileprivate var segmentViewController:ZSSegmentViewController = ZSSegmentViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        layoutSubview()
    }
    
    override func viewWillLayoutSubviews() {
        layoutSubview()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    private func layoutSubview() {
        segmentViewController.view.snp.remakeConstraints { (make) in
            let statusHeight = UIApplication.shared.statusBarFrame.height
            let navHeight = self.navigationController?.navigationBar.height ?? 0
            make.top.equalToSuperview().offset(statusHeight + navHeight)
            make.left.right.bottom.equalToSuperview()
        }
    }

    private func setupSubviews() {
        segmentViewController.delegate = self
        segmentViewController.scrollViewDidEndDeceleratingHandler = { index in
            if index == 0 {
                self.setupAddBooShelfRightBar()
            } else {
                self.setupClearRightBar()
            }
        }
        view.addSubview(segmentViewController.view)
        addChild(segmentViewController)
        
        setupAddBooShelfRightBar()
    }
    
    private func setupAddBooShelfRightBar() {
        let rightBar = UIBarButtonItem(title: "加入书架", style: .plain, target: self, action: #selector(addBookShelfAction))
        navigationController?.navigationItem.rightBarButtonItem = rightBar
    }
    
    private func setupClearRightBar() {
        let rightBar = UIBarButtonItem(title: "清空", style: .plain, target: self, action: #selector(clearAction))
        navigationController?.navigationItem.rightBarButtonItem = rightBar
    }
    
    @objc
    private func addBookShelfAction() {
        
    }
    
    @objc
    private func clearAction() {
        
    }
    
    //MARK: - ZSSegmentProtocol
    func segmentViewControllers() -> [UIViewController] {
        let playerVC = ZSVoicePlayerViewController()
        playerVC.album = self.album
        let playListVC = ZSVoicePlayListViewController()
        playListVC.albums = self.albums
        return [playerVC, playListVC]
    }
    
}
