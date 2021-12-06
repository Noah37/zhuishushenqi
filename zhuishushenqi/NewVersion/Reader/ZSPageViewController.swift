//
//  ZSPageViewController.swift
//  zhuishushenqi
//
//  Created by caony on 2019/7/9.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit

class ZSPageViewController: BaseViewController, ZSReaderVCProtocol {
    var nextPageHandler: ZSReaderPageHandler?
    
    var lastPageHandler: ZSReaderPageHandler?
    
    var startEditingHandler:ZSDisplayHandler?
    var endEditingHandler:ZSDisplayHandler?

    
    fileprivate var pageVC:PageViewController = PageViewController() {
        didSet {
            pageVC.startEditingHandler = { [weak self] in
                self?.startEditingHandler?()
            }
            pageVC.endEditingHandler = { [weak self] in
                self?.endEditingHandler?()
            }
        }
    }
    
    weak var toolBar:ZSReaderToolbar?
    
    weak var dataSource:UIPageViewControllerDataSource?
    weak var delegate:UIPageViewControllerDelegate?
    
    var sideNum = 1
    
    lazy var horizonalController:UIPageViewController = {
        var transitionStyle:UIPageViewController.TransitionStyle = .pageCurl
        let controller = UIPageViewController(transitionStyle: transitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation.horizontal, options: nil)
        controller.dataSource = self
        controller.delegate = self
        controller.isDoubleSided = true
        controller.setViewControllers([pageVC], direction: .forward, animated: true, completion: nil)
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarHiden = true
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
        pageVC.newPage = page
        horizonalController.setViewControllers([pageVC], direction: UIPageViewController.NavigationDirection.forward, animated: animated, completion: nil)
    }
    
    @objc
    private func tapAction(tap:UITapGestureRecognizer) {
        toolBar?.show(inView: view, true)
    }
    
    deinit {
        QSLog("释放了")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        //        delegate?.touchArea(touches: touches, with: event)
    }
}

extension ZSPageViewController:UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        sideNum -= 1
        if abs(sideNum)%2 == 0 { //背面
            let backgroundVC = QSReaderBackgroundViewController()
            backgroundVC.setBackground(viewController: self.pageVC)
            return backgroundVC
        }
        if let vc = dataSource?.pageViewController(pageViewController, viewControllerBefore: viewController) as? PageViewController {
            pageVC = vc
            return vc
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        sideNum += 1
        if abs(sideNum)%2 == 0 { //背面
            let backgroundVC = QSReaderBackgroundViewController()
            backgroundVC.setBackground(viewController: self.pageVC)
            return backgroundVC
        } else if let vc = dataSource?.pageViewController(pageViewController, viewControllerAfter: viewController) as? PageViewController {
            pageVC = vc
            return vc
        }
        return nil
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
