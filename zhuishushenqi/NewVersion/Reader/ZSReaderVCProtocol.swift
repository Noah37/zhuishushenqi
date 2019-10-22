//
//  ZSReaderProtocol.swift
//  zhuishushenqi
//
//  Created by caony on 2019/9/19.
//  Copyright © 2019 QS. All rights reserved.
//

import Foundation


protocol ZSReaderVCProtocol {
    
    @available(iOS 5.0, *)
    static func pageViewController() ->ZSReaderVCProtocol?
    
    func load()
    
    @available(iOS 5.0, *)
    func pageViewController(_ pageViewController: PageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    
    @available(iOS 5.0, *)
    func pageViewController(_ pageViewController: PageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    
    
    // Sent when a gesture-initiated transition begins.
    @available(iOS 6.0, *)
    func pageViewController(_ pageViewController: PageViewController, willTransitionTo pendingViewControllers: [UIViewController])
    
    
    // Sent when a gesture-initiated transition ends. The 'finished' parameter indicates whether the animation finished, while the 'completed' parameter indicates whether the transition completed or bailed out (if the user let go early).
    @available(iOS 5.0, *)
    func pageViewController(_ pageViewController: PageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
}
