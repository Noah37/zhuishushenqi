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

    //MARK: - ZSReaderVCProtocol
    static func pageViewController() -> ZSReaderVCProtocol? {
        return shared
    }
    
    func load() {
        let page = ZSReaderCache.shared.load()
        let pageVC = PageViewController()
        pageVC.page = page
        addChild(pageVC)
        view.addSubview(pageVC.view)
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
    
}
