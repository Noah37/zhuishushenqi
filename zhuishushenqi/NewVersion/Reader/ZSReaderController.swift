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
    
    init() {
        switch type {
        case .normal:
            readerVC = ZSNormalViewController()
        case .vertical:
            
            break
        case .horizonal:
            
            break
        case .pageCurl:
            
            break
        }
    }
    
    var type:ZSReaderType = .normal
    var readerVC:ZSReaderVCProtocol?
}

class ZSReaderController: BaseViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var pref:ZSReaderPref = ZSReaderPref()
    var viewModel:ZSReaderBaseViewModel = ZSReaderBaseViewModel()
    var reader = ZSReader.share
    
    convenience init(chapter:ZSBookChapter,_ model:AikanParserModel?) {
        self.init()
        viewModel.originalChapter = chapter
        viewModel.model = model
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        pref.readerVC?.destroy()
        if let vc = pref.readerVC as? UIViewController {
            vc.willMove(toParent: self)
            vc.view.removeFromSuperview()
            vc.removeFromParent()
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
            addChild(vc)
            view.addSubview(vc.view)
            vc.didMove(toParent: self)
        }
        pref.readerVC?.bind(viewModel: viewModel)
        pref.readerVC?.load()
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
    
    deinit {
        
    }
}
