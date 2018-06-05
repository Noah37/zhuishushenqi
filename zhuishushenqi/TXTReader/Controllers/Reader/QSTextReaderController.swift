
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
    
    // save read history,default true,bookshelf are false
    var saveRecord:Bool = true
    
    var presenter: QSTextPresenterProtocol?

    var bookDetail:BookDetail!
    
    // key为章节的link，value为QSChapter模型
    var chapterDict:[String:Any]! = [:]
    
    //all chapters
    var chapters = [NSDictionary]()
    
    var reusePages:[PageViewController] = []

    var isToolBarHidden:Bool = true
    var isAnimatedFinished:Bool = false
    var currentPage:Int = 0
    var currentChapter:Int = 0
    
    var curlPageStyle:QSTextCurlPageStyle = .forwards

    // 拟真阅读
    var pageController:UIPageViewController?
    // 简洁阅读与滑动
    var readerViewController:QSReaderViewController?
    
    // 当前阅读视图控制器，处于动画中时，则表示要切换到的控制器，非动画中则表示当前的阅读控制器
    var currentReaderVC:PageViewController!

    var window:UIWindow?
    var callback:QSTextCallBack?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        // 初始化根控制器
        createRootController()
        
        presenter?.viewDidLoad(bookDetail:bookDetail)
        
        bookDetail.isUpdated = false
        if let book = bookDetail {
            BookManager.shared.modifyBookshelf(book: book)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        // 保存浏览记录
        BookManager.shared.addReadHistory(book: bookDetail)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.tapCount == 1 {
            if isToolBarHidden {
                toolBar.showWithAnimations(animation: true,inView: currentReaderVC.view)
            }
            isToolBarHidden = !isToolBarHidden
        }
    }
    
    //MARK: - custom action
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
            break
        case .simple:
            setupReaderViewController()
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
    
    private func setupReaderViewController(){
        if readerViewController != nil {
            readerViewController?.view.removeFromSuperview()
            readerViewController?.removeFromParentViewController()
            readerViewController = nil
        }
        if pageController != nil {
            pageController?.view.removeFromSuperview()
            pageController?.removeFromParentViewController()
        }
        let layout = QSReaderViewFlowLayout()
        readerViewController = QSReaderViewController(collectionViewLayout: layout)
        view.addSubview(readerViewController!.view)
        addChildViewController(readerViewController!)
    }
    
    func initialPageViewController()->PageViewController{
        if let record = bookDetail.record {
            currentChapter = record.chapter
            currentPage = record.page
        }
        let pageVC = PageViewController()
        let page = getPage(chapter: currentChapter, page: currentPage)
        pageVC.page = page
        currentReaderVC = pageVC
        return pageVC
    }
    
    func getLastPage(chapter:Int,page:Int)->PageViewController?{
        let pageVC = PageViewController()
        let pageModel = getPage(chapter: chapter, page: page)
        pageVC.page = pageModel
        if pageModel.content == "" {
            // 重新请求数据
            presenter?.interactor.getChapter(chapterIndex: currentChapter, pageIndex: currentPage)
        }
        return pageVC
    }
    
    func getNextPage(chapter:Int,page:Int)->PageViewController{
        let pageVC = PageViewController()
        let pageModel = getPage(chapter: chapter, page: page)
        pageVC.page = pageModel
        if pageModel.content == "" {
            // 如果没网，可以先展示章节名与页码
            presenter?.interactor.getChapter(chapterIndex: currentChapter, pageIndex: currentPage)
        }
        return pageVC
    }
    
    //MARK: - statusBar
    override var prefersStatusBarHidden: Bool{
        return isToolBarHidden
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation{
        return .slide
    }
    
    //MARK:  - lazy variable
    lazy var toolBar:ToolBar = {
        let toolBar:ToolBar = ToolBar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        //        toolBar.isHidden = true
        toolBar.toolBarDelegate = self
        toolBar.title = self.bookDetail.title
        return toolBar;
    }()
}

extension QSTextReaderController:UIPageViewControllerDataSource,UIPageViewControllerDelegate,ToolBarDelegate,CategoryDelegate{
    
    //MARK: - UIPageViewControllerDataSource，UIPageViewControllerDelegate
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?{
        //UIPageViewController的 isDoubleSided 设置为true后，会调用两次代理方法，第一次为背面的viewcontroller，第二次为正面
        //将正面的view截屏，然后反向显示在back
        if viewController.isKind(of: PageViewController.self) {
            let backgroundVC = QSReaderBackgroundViewController()
            backgroundVC.setBackground(viewController: self.currentReaderVC!)
            return backgroundVC
        }
        // 防止计算错误
        if currentChapter < 0 {
            currentChapter = 0
        }
        if currentPage < 0 {
            currentPage = 0
        }
        
        let pages  = getPages(chapter: currentChapter)
        if currentPage == 0 || pages.count == 0 {
            currentChapter -= 1
            if currentChapter < 0 {
                currentChapter = 0
                return nil
            }
            // 计算上一章的页数
            let pages = getPages(chapter: currentChapter)
            if pages.count > 0 {
                currentPage = pages.count - 1
            } else {
                currentPage = 0
            }
        } else {
            currentPage -= 1
        }
        if currentChapter < 0 {
            currentPage = 0
            currentChapter = 0
            return nil
        }
        curlPageStyle = .backwards
        QSLog("chapter:\(currentChapter)\npage:\(currentPage)")
        let pageVC = getLastPage(chapter: currentChapter, page: currentPage)

        return pageVC
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?{
        if viewController.isKind(of: PageViewController.self) {
            let backgroundVC = QSReaderBackgroundViewController()
            backgroundVC.setBackground(viewController: self.currentReaderVC!)
            return backgroundVC
        }
        // 防止计算错误
        if currentChapter < 0 {
            currentChapter = 0
        }
        if currentPage < 0 {
            currentPage = 0
        }
        //换源之后chapter的越界问题
        // 如果chapter存在，则使用chapter，若不存在，则认为当前章节没有数据，直接进入下一章节
        let pages = getPages(chapter: currentChapter)
        if currentPage < pages.count - 1{
            currentPage += 1
        } else {
            currentChapter += 1
            currentPage = 0
        }
        if currentChapter > self.bookDetail.chapters!.count - 1 {
            currentChapter = self.bookDetail.chapters!.count - 1
        }
        curlPageStyle = .forwards
        QSLog("chapter:\(currentChapter)\npage:\(currentPage)")
        let pageVC = getNextPage(chapter: currentChapter, page: currentPage)
        return pageVC
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]){
        QSLog("viewControllers:\(pendingViewControllers)")
        // viewControllers控制器可能会取消，因此这里要记住这个控制器，获取到数据后，刷新的是这个控制器
        currentReaderVC.qs_removeObserver()
        currentReaderVC = pendingViewControllers.first as! PageViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool){
        //如果翻页完成，则completed=true，否则为false
        isAnimatedFinished = completed//请求数据时根据此字段更新当前页
        currentReaderVC = pageViewController.viewControllers?.first as! PageViewController
        if  completed == true {

        }else{
            // 翻页未完成，回到原来的页面,原来的页面是肯定存在的
            // 分为两种情况，1.前（下一页） 2.后（上一页）
            if curlPageStyle == .backwards {
                // 向前的话，计算当前页面的下一页就行
                let pages = getPages(chapter: currentChapter)
                if currentPage < pages.count - 1{
                    currentPage += 1
                } else {
                    currentChapter += 1
                    currentPage = 0
                }
                
            } else if curlPageStyle == .forwards {
                let pages  = getPages(chapter: currentChapter)
                if pages.count == 0 {
                    currentChapter -= 1
                    currentPage = 0 // -1表示往前翻，0表示往后翻
                } else if currentPage == 0 {
                    currentChapter -= 1
                    // 计算上一章的页数
                    let pages = getPages(chapter: currentChapter)
                    if pages.count > 0 {
                        currentPage = pages.count - 1
                    } else {
                        currentPage = 0
                    }
                } else {
                    currentPage -= 1
                }
            }
        }
    }
    
    //MARK: - ToolBarDelegate
    func backButtonDidClicked(){
        // 退出时，通常保存阅读记录就行，其它的不需要保存
        let exist = BookManager.shared.bookExist(book:bookDetail)
        if !exist {
            self.alert(with: "追书提示", message: "是否将本书加入我的收藏", okTitle: "好的", cancelTitle: "不了", okAction: { (action) in
                if let book = self.bookDetail {
                    BookManager.shared.modifyBookshelf(book: book)
                }
                self.dismiss(animated: true, completion: nil)
            }, cancelAction: { (action) in
                self.dismiss(animated: true, completion: nil)
            })
        }else{
            if let book = self.bookDetail {
                BookManager.shared.modifyRecord(book, currentChapter, currentPage)
            }
            self.dismiss(animated: true, completion: nil)
        }
        if let back = callback {
            if let book = self.bookDetail {
                back(book)
            }
        }
    }
    
    func toolBarDismiss(){
        self.dismiss(animated: true, completion: nil)
        self.toolBar.hideWithAnimations(animation: true)
    }
    
    func catagoryClicked(){
        // 更新下book的page与chapter字段
        if let book = self.bookDetail {
            book.chapter = self.currentChapter
            book.page = self.currentPage
            self.toolBar.hideWithAnimations(animation: true)
            presenter?.didClickCategory(book:book)
        }
    }
    
    func readBg(type: Reader) {
        AppStyle.shared.reader = type
        self.currentReaderVC?.bgView.image = AppStyle.shared.reader.backgroundImage
    }
    
    func fontChange(action:ToolBarFontChangeAction){
        var size = QSReaderSetting.shared.fontSize
        if action == .plus {
            size += 1
        } else {
            size -= 1
        }
        if size > QSReaderFontSizeMax {
            QSLog("fontSize:\(size)\n 超出了限制")
            return
        }
        if size < QSReaderFontSizeMin {
            QSLog("fontSize:\(size)\n 超出了限制")
            return
        }
        QSReaderSetting.shared.fontSize = size
        //字体变小，页数变少
        let pages = getPages(chapter: currentChapter)
        if currentPage > pages.count - 1 && pages.count != 0 {
            currentPage = pages.count - 1
        }
        //字体变大，页数变多，根据追书的设计保持当前页不变
        currentReaderVC?.page = pages[currentPage]
    }
    
    func cacheAll() {
        let root:RootViewController = SideViewController.shared.contentViewController as! RootViewController
        let type = root.reachability?.networkType
        //移动网络，进行提示
        if type == .WWAN2G || type == .WWAN3G || type == .WWAN4G {
            //提示当前正在使用移动网络，是否继续
            alert(with: "提示", message: "当前正在使用移动网络，是否继续", okTitle: "继续", cancelTitle: "取消", okAction: { (action) in
                self.presenter?.didClickCache()
            }, cancelAction: { (action) in
                
            })
        }else {
            toolBar.progressView.isHidden = false
            presenter?.didClickCache()
        }
    }
    
    func brightnessChange(value: CGFloat) {
        //此处亮度调节是对于手机的，退出app后应还原
        
    }
    
    func toolbar(toolbar:ToolBar, clickMoreSetting:UIView) {
        let moreSettingVC = QSMoreSettingController()
        let nav = UINavigationController(rootViewController: moreSettingVC)
        present(nav, animated: true, completion: nil)
    }
    
    func changeSourceClicked() {
        let sourceVC = ChangeSourceViewController()
        sourceVC.id = "\(self.bookDetail?._id ?? "")"
        sourceVC.sources = bookDetail?.resources
        sourceVC.selectedIndex = bookDetail?.sourceIndex ?? 0
        sourceVC.selectAction = { (index:Int,sources:[ResourceModel]?) in
            self.bookDetail?.sourceIndex = index
            self.bookDetail?.resources = sources
            self.bookDetail?.sourceIndex = index
            self.presenter?.requestAllChapter(index: self.bookDetail?.sourceIndex ?? 0)
        }
        let nav = UINavigationController(rootViewController: sourceVC)
        present(nav, animated: true) {
            self.toolBar.hideWithAnimations(animation: false)
        }
    }
    
    func toolBarDidShow(){
        isToolBarHidden = false
        UIView.animate(withDuration: 0.35, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        })
    }
    
    func toolBarDidHidden(){
        isToolBarHidden = true
        UIView.animate(withDuration: 0.35, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        })
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
        currentChapter = index
        currentPage = 0
        let pageVC = getNextPage(chapter: currentChapter, page: currentPage)
//        let page = getPage(chapter: currentChapter, page: currentPage)
//        pageVC.page = page
        currentReaderVC = pageVC
        
        let backgroundVC = QSReaderBackgroundViewController()
        backgroundVC.setBackground(viewController: pageVC)
        pageController?.setViewControllers([pageVC,backgroundVC], direction: .forward, animated: true) { (finished) in
            self.toolBar.hideWithAnimations(animation: true)
        }
    }
}

extension QSTextReaderController:QSTextViewProtocol,QSCategoryDelegate{
    
    func showBook(book:QSBook){
        bookDetail?.book = book
        presenter?.interactor.getChapter(chapterIndex: currentChapter, pageIndex: currentPage)
    }
    
    func downloadFinish(book: QSBook) {
        self.bookDetail?.book = book
    }
    
    func showProgress(dict: [String : Any]) {
        toolBar.progressView.dict = dict
    }
    
    func getPages(chapter:Int)->[QSPage]{
        let chapterModel = self.bookDetail.chapters?[chapter]
        if let link = chapterModel?["link"] as? String{
            if let chapterInfo = chapterDict[link] as? QSChapter{
                let pages = chapterInfo.getPages()
                return pages
            }
        }
        return []
    }
    
    func getPage(chapter:Int,page:Int)->QSPage{
        let pages = getPages(chapter: chapter)
        if page <  pages.count {
            return pages[page]
        }
        // 内存中不存在
        let pageModel = QSPage()
        if let title = bookDetail.chapters?[chapter]["title"] as? String {
            pageModel.title = title
        }
        return pageModel
    }
    
    func showChapter(chapter:Dictionary<String,Any>,index:Int){
        getChapterDict(chapter: chapter, index: index)
        let pages = getPages(chapter: index)
        if curlPageStyle == .backwards { // 往前翻
            if pages.count > 0 {
                currentPage = pages.count - 1
            } else {
                currentPage = 0
            }
        }
        let page = getPage(chapter: index, page: currentPage)
        if page.content != "" {
            // 动画还未完成
            currentReaderVC.page = page
        }
    }
    
    // 将新获取的章节信息存入chapterDict中
    func getChapterDict(chapter:[String:Any],index:Int){
        let chapterModel = self.bookDetail?.chapters?[index]
        let qsChapter = QSChapter()
        if let link = chapterModel?["link"] as? String{
            qsChapter.link = link
            // 如果使用追书正版书源，取的字段应该是cpContent，需要根据当前选择的源进行判断
            if let _ = chapter["order"] as? Int {
                if let content = chapter["cpContent"] as? String  {
                    qsChapter.content = content
                }
            } else {
                if let content = chapter["body"] as? String  {
                    qsChapter.content = content
                }
            }
            if let title = chapterModel?["title"] as? String {
                qsChapter.title = title
            }
            qsChapter.curChapter = index
            chapterDict[link] = qsChapter
        }
    }
    
    func showAllChapter(chapters: [NSDictionary]) {
        self.chapters = chapters
        self.bookDetail.chapters = chapters
        //换源引起的数组越界
        if self.currentChapter > self.chapters.count - 1 {
            self.currentChapter = self.chapters.count - 1
        }
        self.presenter?.requestChapter(index: self.currentChapter)
    }
    
    func showResources(resources: [ResourceModel]) {
        bookDetail?.resources = resources
        presenter?.requestAllChapter(index: bookDetail?.sourceIndex ?? 0)
    }
    
    func showEmpty(){
        
    }
}
