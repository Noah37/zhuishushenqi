//
//  ZSNormalViewController.swift
//  zhuishushenqi
//
//  Created by caony on 2019/7/9.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit

class ZSNormalViewController: BaseViewController, ZSReaderVCProtocol {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    static let shared = ZSNormalViewController()
    
    var viewModel:ZSReaderBaseViewModel?
    
    fileprivate var changedPage = false
    
    fileprivate var pageViewController:PageViewController = PageViewController()

    //MARK: - ZSReaderVCProtocol
    static func pageViewController() -> ZSReaderVCProtocol? {
        if shared.pageViewController.view.superview != shared.view {
            shared.pageViewController.view.removeFromSuperview()
            shared.view.addSubview(shared.pageViewController.view)
        }
        return shared
    }
    
    func load() {
        let page = ZSReaderCache.shared.load()
        let pageVC = PageViewController()
        pageVC.page = page
        addChild(pageVC)
        view.addSubview(pageVC.view)
    }
    
    func bind(viewModel: ZSReaderBaseViewModel) {
        self.viewModel = viewModel
    }
    
    func pageViewController(_ pageViewController: PageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func pageViewController(_ pageViewController: PageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func pageViewController(_ pageViewController: PageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
    }
    
    // Sent when a gesture-initiated transition ends. The 'finished' parameter indicates whether the animation finished, while the 'completed' parameter indicates whether the transition completed or bailed out (if the user let go early).
    func pageViewController(_ pageViewController: PageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
    }
    
    func setupGesture(){
            let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction))
            view.addGestureRecognizer(pan)
        }
            
        @objc func panAction(pan:UIPanGestureRecognizer){
            // x方向滑动超过20就翻页
            let translation:CGPoint = pan.translation(in: self.view)
            
            if pan.state == .changed && !changedPage {
                let offsetX = translation.x
                if offsetX < -20 {
                    // 在本次手势结束前都不再响应
                    changedPage = true
//                    getNextPage()
                } else if (offsetX > 20) {
                    // 在本次手势结束前都不再响应
                    changedPage = true
//                    getLastPage()
                }
            } else if pan.state == .ended {
                changedPage = false
            }
        }
    
}
