//
//  ZSHorizonalViewController.swift
//  zhuishushenqi
//
//  Created by caony on 2019/7/9.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit

class ZSHorizonalViewController: BaseViewController, ZSReaderVCProtocol {
    
    fileprivate var pageVC:PageViewController = PageViewController()
    
    weak var toolBar:ZSReaderToolbar?
    
    weak var dataSource:UIPageViewControllerDataSource?
    weak var delegate:UIPageViewControllerDelegate?
    
    var nextPageHandler: ZSReaderPageHandler?
    
    var lastPageHandler: ZSReaderPageHandler?
    
    lazy var horizonalController:UIPageViewController = {
        var transitionStyle:UIPageViewController.TransitionStyle = .scroll
        let controller = UIPageViewController(transitionStyle: transitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation.horizontal, options: nil)
        controller.dataSource = self
        controller.delegate = self
        controller.isDoubleSided = false
        controller.setViewControllers([pageVC], direction: .forward, animated: true, completion: nil)
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.horizonalController.view.superview != self.view {
            self.horizonalController.view.removeFromSuperview()
            self.addChild(self.horizonalController)
            self.view.addSubview(self.horizonalController.view)
            self.horizonalController.didMove(toParent: self)
        }
    }
    
    func bind(toolBar: ZSReaderToolbar) {
        self.toolBar = toolBar
    }
    
    func destroy() {
        if let controllers = horizonalController.viewControllers as? [PageViewController] {
            for controller in controllers {
                controller.destroy()
            }
        }
        pageVC.destroy()
    }
    
    func changeBg(style: ZSReaderStyle) {
        pageVC.bgView.image = style.backgroundImage
    }
    
    func jumpPage(page: ZSBookPage,_ animated:Bool = false,_ direction:UIPageViewController.NavigationDirection = .forward) {
        if horizonalController.viewControllers?.count == 0 {
            return
        }
        if animated {
            if direction == .forward {
                if let vc = pageViewController(horizonalController, viewControllerAfter: horizonalController.viewControllers![0]) as? PageViewController {
                    vc.newPage = page
                    horizonalController.setViewControllers([vc], direction: direction, animated: animated) { [weak self] (finished) in
                        self?.pageVC = vc
                    }
                }
            } else {
               if let vc = pageViewController(horizonalController, viewControllerBefore: horizonalController.viewControllers![0]) as? PageViewController {
                    vc.newPage = page
                    horizonalController.setViewControllers([vc], direction: direction, animated: animated) { [weak self] (finished) in
                        self?.pageVC = vc
                    }
                }
            }
        } else {
            pageVC = horizonalController.viewControllers![0] as! PageViewController
            pageVC.newPage = page
        }
    }
}

extension ZSHorizonalViewController:UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return dataSource?.pageViewController(pageViewController, viewControllerBefore: viewController)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return dataSource?.pageViewController(pageViewController, viewControllerAfter: viewController)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool){
        delegate?.pageViewController?(pageViewController, didFinishAnimating: finished, previousViewControllers: previousViewControllers, transitionCompleted: completed)
        if !completed {
            guard let pageVC = previousViewControllers.first as? PageViewController else { return }
            self.pageVC = pageVC
        } else {
            
        }
    }
}
