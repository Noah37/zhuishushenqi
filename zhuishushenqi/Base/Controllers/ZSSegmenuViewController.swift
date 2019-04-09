//
//  ZSSegmenuViewController.swift
//  zhuishushenqi
//
//  Created by caony on 2019/3/23.
//  Copyright © 2019年 QS. All rights reserved.
//

import UIKit

typealias ZSSegmentHandler = (_ index:Int)->Void

protocol ZSSegmenuProtocol {
    func viewControllersForSegmenu(_ segmenu:ZSSegmenuViewController) ->[UIViewController]
    func segmenu(_ segmenu:ZSSegmenuViewController, didSelectSegAt index:Int)
    func segmenu(_ segmenu:ZSSegmenuViewController, didScrollToSegAt index:Int)
}

class ZSSegmenuViewController: UIViewController, ZSSegmentProtocol {
    
    fileprivate var segMenu:SegMenu!
    
    fileprivate var segmentViewController:ZSSegmentViewController = ZSSegmentViewController()
    
    var delegate:ZSSegmenuProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let viewControllers = self.delegate?.viewControllersForSegmenu(self) {
            setupSubviews(viewControllers: viewControllers)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        layoutSubviews()
    }
    
    override func viewWillLayoutSubviews() {
        layoutSubviews()
    }
    
    private func layoutSubviews() {
        
        segMenu.snp.remakeConstraints { (make) in
            let statusHeight = UIApplication.shared.statusBarFrame.height
            let navHeight = self.navigationController?.navigationBar.height ?? 0
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(statusHeight + navHeight)
            make.height.equalTo(kTootSegmentViewHeight)
        }
        segmentViewController.view.snp.remakeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(segMenu.snp.bottom)
        }
    }
    
    fileprivate func setupSubviews(viewControllers:[UIViewController]) {
        var titles:[String] = []
        for controller in viewControllers {
            titles.append(controller.title ?? "")
        }
        segMenu = SegMenu(frame: CGRect.zero, WithTitles: titles)
        segMenu.menuDelegate = self
        self.view.addSubview(segMenu)
        
        segmentViewController.scrollViewDidEndDeceleratingHandler = { index in
            self.segMenu.selectIndex(index)
        }
        segmentViewController.delegate = self
        view.addSubview(segmentViewController.view)
        addChild(segmentViewController)
    }
    
    func segmentViewControllers() -> [UIViewController] {
        if let viewControllers = self.delegate?.viewControllersForSegmenu(self) {
            return viewControllers
        }
        return []
    }
}

extension ZSSegmenuViewController:SegMenuDelegate{
    //MARK: - SegMenuDelegate
    func didSelectAtIndex(_ index:Int){
        let indexPath = IndexPath(row: index, section: 0)
        self.segmentViewController.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }
}
