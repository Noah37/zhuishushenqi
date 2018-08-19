//
//  TXTReaderViewController.swift
//  TXTReader
//
//  Created by Nory Chao on 16/11/24.
//  Copyright © 2016年 QS. All rights reserved.
//

import UIKit

class TXTReaderViewController: UIViewController {
    
    var viewModel = ZSReaderViewModel()
    
    var isToolBarHidden:Bool = true
    
    var sideNum = 1
    
    var curlPageStyle:QSTextCurlPageStyle = .forwards
    
    // 拟真阅读
    var pageController:UIPageViewController?
    
    // 当前阅读视图控制器，处于动画中时，则表示要切换到的控制器，非动画中则表示当前的阅读控制器
    var currentReaderVC:PageViewController!
    
    var window:UIWindow?
    var callback:QSTextCallBack?
    
    var style:ZSReaderAnimationStyle = .horMove
    
    var viewControllers:[PageViewController] = []
    
    var record:QSRecord = QSRecord()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        // 第一次进入没有record,初始化一个record
        setupRecord()
        
        // 初始化根控制器
        createRootController()
        
        // 初始化请求
        initial()
        
        // 变更书籍的更新信息
        viewModel.book?.isUpdated = false
        
        if let book = viewModel.book {
            BookManager.shared.modifyBookshelf(book: book)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        // 保存浏览记录
        if let book = viewModel.book {
            BookManager.shared.addReadHistory(book: book)
        }
    }
    
    //MARK: - initial action
    private func createRootController(){
        let pageStyle = QSReaderSetting.shared.pageStyle
        switch pageStyle {
        case .horMove:
            guard let _ = pageController else {
                setupPageController()
                return
            }
            view.addSubview(pageController!.view)
            addChildViewController(pageController!)
            pageController?.setViewControllers([currentReaderVC], direction: .forward, animated: true, completion: nil)
            if let model = viewModel.book?.record?.chapterModel {
                if let chapterIndex = viewModel.book?.record?.chapter {
                    if chapterIndex < model.pages.count {
                        currentReaderVC.page = model.pages[chapterIndex]
                    }
                }
            }
            break
        case .none:
            
            break
        case .curlPage:
            break
        default:
            break
        }
    }
    
    private func setupPageController(){
        var transitionStyle:UIPageViewControllerTransitionStyle = .pageCurl
        if style == .horMove {
            transitionStyle = .scroll
        }
        pageController = UIPageViewController(transitionStyle: transitionStyle, navigationOrientation: .horizontal, options: nil)
        pageController?.dataSource = self
        pageController?.delegate = self
        pageController?.isDoubleSided = (style == .horMove ? false:true)
        view.addSubview(pageController!.view)
        addChildViewController(pageController!)
        pageController?.setViewControllers([initialPageViewController()], direction: .forward, animated: true, completion: nil)
    }
    
    func initialPageViewController()->PageViewController{
        let pageVC = PageViewController()
        if let record = viewModel.book?.record {
            if let chapterModel = record.chapterModel {
                let pageIndex = record.page
                if pageIndex < chapterModel.pages.count {
                    pageVC.page = chapterModel.pages[pageIndex]
                }
            } else if (viewModel.book?.book.localChapters.count)! > 0 {
                if let chapters =  viewModel.book?.book.localChapters {
                    let chapterIndex = record.chapter
                    let pageIndex = record.page
                    if chapterIndex < chapters.count  {
                        let chapterModel = chapters[chapterIndex]
                        if pageIndex < chapterModel.pages.count {
                            pageVC.page = chapterModel.pages[pageIndex]
                        }
                    }
                }
            } else {
                viewModel.fetchInitialChapter { (page) in
                    pageVC.page = page
                }
            }
        }
        currentReaderVC = pageVC
        return pageVC
    }
    
    func initial(){
        //如果是本地书籍,则不清求
        if viewModel.exsitLocal() {
            return
        }
        viewModel.fetchAllResource { resources in
            self.viewModel.fetchAllChapters({ (chapters) in
                self.viewModel.fetchInitialChapter({ (page) in
                    self.currentReaderVC.page = page
                })
            })
        }
    }
    
    func setupRecord(){
        // 第一次进入没有record,初始化一个record
        if let book = viewModel.book {
            record.bookId = book._id
            if book.record == nil {
                book.record = record
            }
        }
    }
}

extension TXTReaderViewController:UIPageViewControllerDataSource,UIPageViewControllerDelegate{
    
    //MARK: - UIPageViewControllerDataSource，UIPageViewControllerDelegate
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?{
        //UIPageViewController的 isDoubleSided 设置为true后，会调用两次代理方法，第一次为背面的viewcontroller，第二次为正面
        print("before")
        sideNum -= 1
        curlPageStyle = .backwards
        
        let curPageViewController = viewController as! PageViewController
        var pageVC:PageViewController?
//        if viewControllers.count > 1 {
//            if let reusePageVC = viewControllers.first {
//                pageVC = reusePageVC
//                viewControllers.remove(at: 0)
//            }
//        } else {
            pageVC = PageViewController()
//        }
        let existLast = viewModel.hm_existLast(page: curPageViewController.page)
        if existLast {
            currentReaderVC = pageVC
            viewModel.fetchBackwardPage(page: curPageViewController.page) { (page) in
                pageVC?.page = page
            }
            return pageVC
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?{
        print("after")
        curlPageStyle = .forwards
        sideNum += 1
        
        let curPageViewController = viewController as! PageViewController
        var pageVC:PageViewController?
        if viewControllers.count > 1 {
            if let reusePageVC = viewControllers.first {
                pageVC = reusePageVC
                viewControllers.remove(at: 0)
            }
        } else {
            pageVC = PageViewController()
        }
        
        let existNext = viewModel.hm_existNext(page: curPageViewController.page)
        if existNext {
            pageVC?.view.alpha = 1.0
            viewModel.fetchForwardPage(page: curPageViewController.page) { (page) in
                pageVC?.page = page
            }
            currentReaderVC = pageVC
            return pageVC
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]){
        //        currentReaderVC.qs_removeObserver()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool){
        
        let preVC = previousViewControllers.first as! PageViewController
        if !completed {
            currentReaderVC = previousViewControllers.first as! PageViewController
        } else {
            
            // 更新阅读记录
            if curlPageStyle == .forwards {
                viewModel.updateForwardRecord(page: preVC.page)
            } else if curlPageStyle == .backwards {
                viewModel.updateBackwardRecord(page: preVC.page)
            }
            
            // pageVC的重复利用
            if !viewControllers.contains(preVC) {
                viewControllers.append(preVC)
            }
        }
        QSLog("ZSReaderChapter:\(viewModel.book?.record?.chapter ?? 0) \npage:\(viewModel.book?.record?.page ?? 0)")
//        preVC.qs_removeObserver()
    }
    
    // reader style change
    func readBg(type: Reader) {
        self.currentReaderVC?.bgView.image = AppStyle.shared.reader.backgroundImage
    }
    
    func fontChange(action:ToolBarFontChangeAction){
        viewModel.fontChange(action: action) { (page) in
            self.currentReaderVC.page = page
        }
    }
    
    func cacheAll() {
        let root:RootViewController = SideViewController.shared.contentViewController as! RootViewController
        let type = root.reachability?.networkType
        //移动网络，进行提示
        if type == .WWAN2G || type == .WWAN3G || type == .WWAN4G {
            //提示当前正在使用移动网络，是否继续
            alert(with: "提示", message: "当前正在使用移动网络，是否继续", okTitle: "继续", cancelTitle: "取消", okAction: { (action) in
                //                self.presenter?.didClickCache()
            }, cancelAction: { (action) in
                
            })
        }else {
            //            presenter?.didClickCache()
        }
    }
    
    func brightnessChange(value: CGFloat) {
        // 修改page的background与foreground
        
    }
    
    func toolbar(toolbar:ToolBar, clickMoreSetting:UIView) {
        let moreSettingVC = QSMoreSettingController()
        let nav = UINavigationController(rootViewController: moreSettingVC)
        present(nav, animated: true, completion: nil)
    }
    
    func changeSourceClicked() {
        let sourceVC = ChangeSourceViewController()
        sourceVC.viewModel = self.viewModel
        sourceVC.selectAction = { (index:Int,sources:[ResourceModel]?) in
            self.viewModel = sourceVC.viewModel
            self.viewModel.cachedChapter.removeAll()
            self.viewModel.fetchAllChapters({ (info) in
                self.viewModel.fetchCurrentPage({ (page) in
                    self.currentReaderVC.page = page
                })
            })
        }
        let nav = UINavigationController(rootViewController: sourceVC)
        present(nav, animated: true) {
            
        }
    }
    
    @objc func updateStatusBarStyle(){
        window = UIWindow(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 20, width: UIScreen.main.bounds.size.width, height: 20))
        window?.windowLevel = UIWindowLevelStatusBar
        window?.makeKeyAndVisible()
        window?.backgroundColor = UIColor.red
        setNeedsStatusBarAppearanceUpdate()
    }
    
    //MARK: - CategoryDelegate
    func categoryDidSelectAtIndex(index:Int){
        curlPageStyle = .none
        viewModel.book?.record?.chapter = index
        viewModel.book?.record?.page = 0
        viewModel.book?.record?.chapterModel = nil
        if let link = viewModel.book?.chaptersInfo?[index].link {
            if let chapterModel = viewModel.cachedChapter[link] {
                viewModel.book?.record?.chapterModel = chapterModel
            }
        }
        let pageVC = PageViewController()
        if let model = viewModel.book?.record?.chapterModel {
            pageVC.page = model.pages[0]
        } else {
            viewModel.fetchCurrentPage { (page) in
                pageVC.page = page
            }
        }
        let backgroundVC = QSReaderBackgroundViewController()
        backgroundVC.setBackground(viewController: pageVC)
        pageController?.setViewControllers([pageVC], direction: .forward, animated: true) { (finished) in
        }
        currentReaderVC = pageVC
    }
}
