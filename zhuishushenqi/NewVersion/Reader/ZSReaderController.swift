//
//  ZSReaderViewController.swift
//  zhuishushenqi
//
//  Created by caony on 2019/7/9.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit

enum ZSReaderType {
    case normal
    case vertical
    case horizonal
    case pageCurl
}

struct ZSReaderPref {
    var type:ZSReaderType = .normal
    var readerVC:ZSReaderVCProtocol? {
        switch type {
        case .normal:
            return ZSNormalViewController.pageViewController()
        case .vertical:
            
            break
        case .horizonal:
            
            break
        case .pageCurl:
            
            break
        }
        return nil
    }
}

class ZSReaderController: BaseViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var pref:ZSReaderPref = ZSReaderPref()
    var viewModel:ZSReaderBaseViewModel = ZSReaderBaseViewModel()
    var reader = ZSReader()
    
    convenience init(chapter:ZSBookChapter) {
        self.init()
        viewModel.originalChapter = chapter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeReaderType()
        request()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.isNavigationBarHidden = true
        if let vc = pref.readerVC as? UIViewController {
            vc.view.bounds = view.bounds
        }
    }

    private func request() {
        // 请求当前章节
        viewModel.request { (_) in
            
        }
    }
    
    private func load() {
        
    }

    private func changeReaderType() {
        if let vc = pref.readerVC as? UIViewController {
            if let _ = vc.view.superview {
                return
            }
            view.addSubview(vc.view)
        }
        pref.readerVC?.bind(viewModel: viewModel)
    }
    
    //MARK: - UIPageViewControllerDataSource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    //MARK: - UIPageViewControllerDelegate
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
    }
    
    // Sent when a gesture-initiated transition ends. The 'finished' parameter indicates whether the animation finished, while the 'completed' parameter indicates whether the transition completed or bailed out (if the user let go early).
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
    }
}
