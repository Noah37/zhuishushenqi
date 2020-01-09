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

class ZSReaderController: BaseViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, ZSReaderToolbarDelegate,ZSReaderCatalogViewControllerDelegate {

    var pref:ZSReaderPref = ZSReaderPref()
    var viewModel:ZSReaderBaseViewModel = ZSReaderBaseViewModel()
    var reader = ZSReader.share
    var toolBar:ZSReaderToolbar = ZSReaderToolbar(frame: UIScreen.main.bounds)
    var statusBarStyle:UIStatusBarStyle = .lightContent
    var statusBarHiden:Bool = true
    
    convenience init(chapter:ZSBookChapter,_ model:ZSAikanParserModel?) {
        self.init()
        viewModel.originalChapter = chapter
        viewModel.model = model
        toolBar.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeReaderType()
        request()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        if let vc = pref.readerVC as? UIViewController {
            vc.view.bounds = view.bounds
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }
    
    override func popAction() {
        pref.readerVC?.destroy()
        if let vc = pref.readerVC as? UIViewController {
            vc.willMove(toParent: self)
            vc.view.removeFromSuperview()
            vc.removeFromParent()
        }
        super.popAction()
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
        pref.readerVC?.bind(toolBar: toolBar)
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
    
    //MARK: - ZSReaderToolbarDelegate
    func toolBar(toolBar: ZSReaderToolbar, clickBack: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func toolBarWillShow(toolBar: ZSReaderToolbar) {
        statusBarHiden = false
        UIView.animate(withDuration: 0.35, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
    }
    
    func toolBarWillHiden(toolBar: ZSReaderToolbar) {
        statusBarHiden = true
        UIView.animate(withDuration: 0.35, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
    }
    
    func toolBarDidShow(toolBar: ZSReaderToolbar) {
        
    }
    
    func toolBarDidHiden(toolBar: ZSReaderToolbar) {
        
    }
    
    func toolBar(toolBar:ZSReaderToolbar, clickLast:UIButton) {
        pref.readerVC?.lastChapter()
    }
    
    func toolBar(toolBar:ZSReaderToolbar, clickNext:UIButton) {
        pref.readerVC?.nextChapter()
    }
    
    func toolBar(toolBar:ZSReaderToolbar, clickCatalog:UIButton) {
        toolBar.hiden(false)
        let catalogVC = ZSReaderCatalogViewController()
        catalogVC.model = viewModel.model
        catalogVC.chapter = pref.readerVC?.currentChapter()
        catalogVC.delegate = self
        navigationController?.pushViewController(catalogVC, animated: true)
    }
    
    func toolBar(toolBar:ZSReaderToolbar, clickDark:UIButton) {
        
    }
    
    func toolBar(toolBar:ZSReaderToolbar, clickSetting:UIButton) {
        
    }
    
    func toolBar(toolBar:ZSReaderToolbar, progress:Float) {
        
    }
    
    //MARK: - ZSReaderCatalogViewControllerDelegate
    func catalog(catalog: ZSReaderCatalogViewController, clickChapter: ZSBookChapter) {
        pref.readerVC?.chapter(chapter: clickChapter)
    }
    
    //MARK: - system
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
    
    override var prefersStatusBarHidden: Bool {
        return statusBarHiden
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation{
        return .slide
    }
    
    deinit {
        
    }
}
