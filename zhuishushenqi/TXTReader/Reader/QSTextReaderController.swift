
//  QSTextReaderController.swift
//  TXTReader
//
//  Created by Nory Cao on 16/11/24.
//  Copyright © 2016年 QS. All rights reserved.
//

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
    
    var style:ZSReaderAnimationStyle = .curlPage
    
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
            addChild(pageController!)
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
        case .horMove:
            break
        default:
            break
        }
    }
    
    private func setupPageController(){
        var transitionStyle:UIPageViewController.TransitionStyle = .pageCurl
        if style == .horMove {
            transitionStyle = .scroll
        }
        pageController = UIPageViewController(transitionStyle: transitionStyle, navigationOrientation: .horizontal, options: nil)
        pageController?.dataSource = self
        pageController?.delegate = self
        pageController?.isDoubleSided = true
        view.addSubview(pageController!.view)
        addChild(pageController!)
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

extension QSTextReaderController:UIPageViewControllerDataSource,UIPageViewControllerDelegate{
    
    //MARK: - UIPageViewControllerDataSource，UIPageViewControllerDelegate
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?{
        //UIPageViewController的 isDoubleSided 设置为true后，会调用两次代理方法，第一次为背面的viewcontroller，第二次为正面
        print("before")
        sideNum -= 1
        curlPageStyle = .backwards
        
        if let curPageViewController = viewController as? PageViewController {
            if let page = curPageViewController.page {
                // page 存在则根据page的值来获取下一章节
            } else {
                // page 不存在说明是新的章节
            }
        }

        func lastPage() ->UIViewController? {
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
        if style == .horMove {
            return lastPage()
        } else {
            if abs(sideNum)%2 == 0 {
                let backgroundVC = QSReaderBackgroundViewController()
                //这里获取的是当前页的背面,实际应该是获取上一页的背面
                backgroundVC.setBackground(viewController: self.currentReaderVC!)
                return backgroundVC
            } else {
                return lastPage()
            }
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?{
        print("after")
        curlPageStyle = .forwards
        sideNum += 1
        
        func nextPage() ->UIViewController? {
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
        
        if style == .horMove {
            return nextPage()
        } else {
            if abs(sideNum)%2 == 0 { //背面
                let backgroundVC = QSReaderBackgroundViewController()
                backgroundVC.setBackground(viewController: self.currentReaderVC!)
                return backgroundVC
            } else {
                return nextPage()
            }
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
        window?.windowLevel = UIWindow.Level.statusBar
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

extension QSTextReaderController:ZSReaderControllerProtocol {
    typealias Item = Book
    
}
