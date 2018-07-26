
//  QSTextReaderController.swift
//  TXTReader
//
//  Created by Nory Cao on 16/11/24.
//  Copyright © 2016年 QS. All rights reserved.
//

/*
 *
 * 换源需要做的事情，重新请求所有章节信息，成功后，刷新BookDetail的信息
 * 请求到某一章节的信息后，需要刷新NSDictionary中的QSChapter信息
 * 保存当前阅读进度,只保存阅读记录，其它的不做保存
 * 退出阅读器时，若尚未加入书架，则提示用户是否需要加入书架，选择是，加入书架，同时刷新书架中书籍的阅读信息，选择否，则不记录信息
 * 记录信息包括，当前阅读的章节，页面，上次更新时间
 */
/*
    pageViewController需要复用，否则快速切换的时候内存增加过快，内存占用过高
 */

enum QSTextCurlPageStyle {
    case none  //表示跳转到的章节，没有动画产生
    case forwards //前 ,下一页
    case backwards
}

import UIKit

class QSTextReaderController: UIViewController {
    
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
        case .curlPage:
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
        case .simple:
            
            break
        case .scroll:
            break
        }
    }
    
    private func setupPageController(){
        pageController = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)
        pageController?.dataSource = self
        pageController?.delegate = self
        pageController?.isDoubleSided = true
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
            } else {
//                presenter?.interactor.getChapter(chapterIndex: record.chapter, pageIndex: record.page)
            }
        }
        currentReaderVC = pageVC
        return pageVC
    }
    
    func initial(){
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

extension QSTextReaderController:UIPageViewControllerDataSource,UIPageViewControllerDelegate{
    
    //MARK: - UIPageViewControllerDataSource，UIPageViewControllerDelegate
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?{
        //UIPageViewController的 isDoubleSided 设置为true后，会调用两次代理方法，第一次为背面的viewcontroller，第二次为正面
        print("before")
        sideNum -= 1
        curlPageStyle = .backwards

        if abs(sideNum)%2 == 0 {
            let backgroundVC = QSReaderBackgroundViewController()
            //这里获取的是当前页的背面,实际应该是获取上一页的背面
            backgroundVC.setBackground(viewController: self.currentReaderVC!)
            return backgroundVC
        } else {
            let existLast = viewModel.existLastPage()
            if existLast {
                let pageVC = PageViewController()
                viewModel.fetchLastPage { (page) in
                    pageVC.page = page
                }
                currentReaderVC = pageVC
                return pageVC
            }
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?{
        print("after")
        curlPageStyle = .forwards
        sideNum += 1
        if abs(sideNum)%2 == 0 { //背面
            let backgroundVC = QSReaderBackgroundViewController()
            backgroundVC.setBackground(viewController: self.currentReaderVC!)
            return backgroundVC
        } else {
            let existNext = viewModel.existNextPage()
            if existNext {
                let pageVC = PageViewController()
                viewModel.fetchNextPage { (page) in
                    pageVC.page = page
                }
                currentReaderVC = pageVC
                return pageVC
            }
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]){
//        currentReaderVC.qs_removeObserver()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool){
        if !completed {
            currentReaderVC = previousViewControllers.first as! PageViewController
        } else {
            // 更新阅读记录
            if curlPageStyle == .forwards {
                viewModel.updateNextRecord { (page) in
                    // 如果当前展示的不是record中的,需要刷新下
                    if self.currentReaderVC.page?.curPage != self.viewModel.book?.record?.page {
                        self.currentReaderVC.page = page
                    }
                }
            } else if curlPageStyle == .backwards {
                viewModel.updateLastRecord { (page) in
                    if self.currentReaderVC.page?.curPage != self.viewModel.book?.record?.page {
                        self.currentReaderVC.page = page
                    }
                }
            }
        }
        QSLog("ZSReaderChapter:\(viewModel.book?.record?.chapter ?? 0) \npage:\(viewModel.book?.record?.page ?? 0)")
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
        pageController?.setViewControllers([pageVC,backgroundVC], direction: .forward, animated: true) { (finished) in
        }
        currentReaderVC = pageVC
    }
}
