//
//  ZSNormalViewController.swift
//  zhuishushenqi
//
//  Created by caony on 2019/7/9.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit

class ZSNormalViewController: BaseViewController, ZSReaderVCProtocol {
    
    var nextPageHandler: ZSReaderPageHandler?
    var lastPageHandler: ZSReaderPageHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.pageViewController.view.superview != self.view {
            self.pageViewController.view.removeFromSuperview()
            self.addChild(self.pageViewController)
            self.view.addSubview(self.pageViewController.view)
            self.pageViewController.didMove(toParent: self)
            self.setupGesture()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    weak var toolBar:ZSReaderToolbar?
    
    fileprivate var changedPage = false
    
    fileprivate var pageViewController:PageViewController = PageViewController()

    //MARK: - ZSReaderVCProtocol
    func jumpPage(page: ZSBookPage,_ animated:Bool=false, _ direction:UIPageViewController.NavigationDirection = .forward) {
        pageViewController.newPage = page
    }
    
    func bind(toolBar: ZSReaderToolbar) {
        self.toolBar = toolBar
    }
    
    func changeBg(style: ZSReaderStyle) {
        pageViewController.bgView.image = style.backgroundImage
    }
    
    func setupGesture(){
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        view.addGestureRecognizer(pan)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        toolBar?.show(inView: self.view, true)
    }
            
    @objc func panAction(pan:UIPanGestureRecognizer){
        // x方向滑动超过20就翻页
        let translation:CGPoint = pan.translation(in: self.view)
        
        if pan.state == .changed && !changedPage {
            let offsetX = translation.x
            if offsetX < -20 {
                // 在本次手势结束前都不再响应
                changedPage = true
                nextPage()
            } else if (offsetX > 20) {
                // 在本次手势结束前都不再响应
                changedPage = true
                lastPage()
            }
        } else if pan.state == .ended {
            changedPage = false
        }
    }
    
    func nextPage() {
        nextPageHandler?()
    }
    
    func lastPage() {
        lastPageHandler?()
    }
    
    func destroy() {
        pageViewController.destroy()
    }
    
    deinit {
        
    }
}
