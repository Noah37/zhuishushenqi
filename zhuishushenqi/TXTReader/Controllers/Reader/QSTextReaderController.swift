
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
    var isAnimatedFinished:Bool?
    var currentPage:Int = 0
    var currentChapter:Int = 0
    
    var sideNum = 1
    
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
        
        // 第一次进入没有record,初始化一个record
        let record = QSRecord()
        record.bookId = bookDetail._id
        if bookDetail.record == nil {
            bookDetail.record = record
        }
        
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
            if let model = bookDetail.record?.chapterModel {
                if let chapterIndex = bookDetail.record?.chapter {
                    if chapterIndex < model.pages.count {
                        currentReaderVC.page = model.pages[chapterIndex]
                    }
                }
            }
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
        let pageVC = PageViewController()
        if let record = bookDetail.record {
            let chapterIndex = record.chapter
            if let chapterModel = record.chapterModel {
                if chapterIndex < chapterModel.pages.count {
                    let pageIndex = record.page
                    if pageIndex < chapterModel.pages.count {
                        pageVC.page = chapterModel.pages[pageIndex]
                    }
                }
            }
        }
        currentReaderVC = pageVC
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
        
        sideNum -= 1
        curlPageStyle = .backwards

        if abs(sideNum)%2 == 0 {
            let backgroundVC = QSReaderBackgroundViewController()
            backgroundVC.setBackground(viewController: self.currentReaderVC!)
            return backgroundVC
        } else {
            
            // 1.获取阅读记录,每次翻页成功后都记录阅读进度
            if let record = bookDetail.record {
                //2.获取当前阅读的章节与页码,这里由于是网络小说,有几种情况
                //(1).当前章节信息为空,那么这一章只有一页,翻页直接进入了上一页,章节减一
                //(2).当前章节信息不为空,那么计算当前页码是否为该章节的最后一页
                //这是2(2)
                if let _ = record.chapterModel {
                    let page = record.page
                    // 上一页还在当前章节
                    if page > 0 {
                        // 直接获取阅读器控制器
                        let pageVC = self.lastPageVC()
                        return pageVC
                    } else { // 上一页为新的章节
                        // 判断是否还有新的章节,如果没有,说明已经阅读到最一章节了,提示没有更多章节了
                        //如果有新的章节,新建新的控制器,并请求网络数据
                        
                        //如果有新的章节,又有两种请求,一种是本地已经缓存过的章节,二是本地没有缓存的章节
                        // 为了节省空间,阅读器退出时,只保存阅读进度中的章节,其它不保存
                        // 网络请求其它章节成功后会放入内存中,下次可以直接从内存中获取
                        //1.获取新的章节的缓存
                        let chapter = record.chapter - 1
                        // 有新的章节
                        if chapter >= 0 {
                            // 内存中有缓存,直接获取控制器
                            if let link = bookDetail.chapters?[chapter]["link"] as? String {
                                if let chapterModel = chapterDict[link] as? QSChapter {
                                    let pageVC = self.lastLocalChapter(chapterModel: chapterModel)
                                    return pageVC
                                }
                            }
                            // 内存中不存在,需要网络获取
                            let pageVC = self.networkLastChapter()
                            return pageVC
                        }
                    }
                } else { // 2(1) 当前章节信息为空,那么上一页必定是新的控制器
                    //判断是否还有新的章节,如果没有,说明已经阅读到第一章了,提示没有更多章节了
                    //如果有新的章节,新建新的阅读控制器,先获取内存中的数据,再请求网络数据
                    let chapterIndex = record.chapter - 1
                    if chapterIndex >= 0 {
                        // 内存缓存
                        if let id = bookDetail.chapters?[chapterIndex]["link"] as? String {
                            if let chapterModel = chapterDict[id] as? QSChapter {
                                let pageVC = self.lastLocalChapter(chapterModel: chapterModel)
                                return pageVC
                            }
                        }
                        // 内存中不存在,需要网络获取
                        let pageVC = self.networkLastChapter()
                        return pageVC
                    }
                }
            }
            return nil
        }
    }
    
    // 获取当前章节的上一页,不涉及网络请求
    func lastPageVC() ->PageViewController? {
        if let record = bookDetail.record {
            if let model = record.chapterModel {
                // 由于请求的是上一页,pageIndex-1
                let pageIndex = record.page - 1
                // 防止越界
                if model.pages.count > pageIndex {
                    let pageModel = model.pages[pageIndex]
                    // 新建控制器
                    let pageVc = PageViewController()
                    pageVc.page = pageModel
                    return pageVc
                }
            }
        }
        return nil
    }
    
    //获取当前章节的下一页,不涉及网络请求
    func nextPageVC()->PageViewController?{
        if let record = bookDetail.record {
            if let model = record.chapterModel {
                // 由于请求的是下一页,pageIndex+1
                let pageIndex = record.page + 1
                // 防止越界
                if model.pages.count > pageIndex {
                    let pageModel = model.pages[pageIndex]
                    // 新建控制器
                    let pageVc = PageViewController()
                    pageVc.page = pageModel
                    return pageVc
                }
            }
        }
        return nil
    }
    
    func lastLocalChapter(chapterModel:QSChapter)->PageViewController?{
        //直接获取第一页
        let page = chapterModel.pages.last
        let pageVC = PageViewController()
        pageVC.page = page
        return pageVC
    }
    
    // 从缓存中获取下章节
    func localChapter(chapterModel:QSChapter)->PageViewController?{
        //直接获取第一页
        let page = chapterModel.pages.first
        let pageVC = PageViewController()
        pageVC.page = page
        return pageVC
    }
    
    // 网络获取新的章节,先新建一个控制器,page为空,默认展示空白页,这里有个问题,翻页动画结束时,网络请求可能已经成功,也可能还没返回,需要相应的进行处理.如果翻页动画结束时,网络请求已成功,翻页成功则更新阅读记录,翻页失败不更新,更新内存中的章节信息.如果翻页动画结束时,网络请求还未返回,不处理,等待网络请求返回时才刷新空白的控制器.
    func networkNextChapter()->PageViewController?{
        if let chapterIndex = bookDetail.record?.chapter {
            let pageVC = PageViewController()
            // 在这里发起网络请求
            // 调用这个方法之前已经进行了判断,不需要再次判断数组越界
            
            presenter?.interactor.getChapter(chapterIndex: chapterIndex + 1, pageIndex: 0)
            return pageVC
        }
        return nil
    }
    
    func networkLastChapter()->PageViewController?{
        if let chapterIndex = bookDetail.record?.chapter {
            let pageVC = PageViewController()
            presenter?.interactor.getChapter(chapterIndex: chapterIndex - 1, pageIndex: 0)
            return pageVC
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?{
        curlPageStyle = .forwards
        sideNum += 1
        if abs(sideNum)%2 == 0 { //背面
            let backgroundVC = QSReaderBackgroundViewController()
            backgroundVC.setBackground(viewController: self.currentReaderVC!)
            return backgroundVC
        } else {
            // 1.获取阅读记录,每次翻页成功后都记录阅读进度
            if let record = bookDetail.record {
                //2.获取当前阅读的章节与页码,这里由于是网络小说,有几种情况
                //(1).当前章节信息为空,那么这一章只有一页,翻页直接进入了下一页,章节加一
                //(2).当前章节信息不为空,说明已经请求成功了,那么计算当前页码是否为该章节的最后一页
                //这是2(2)
                if let model = record.chapterModel {
                    let page = record.page
                    // 下一页还在当前章节
                    if page < model.pages.count - 1 {
                        // 直接获取阅读器控制器
                        let pageVC = self.nextPageVC()
                        return pageVC
                    } else { // 下一页为新的章节
                        // 判断是否还有新的章节,如果没有,说明已经阅读到最新章节了,可以进行提示或者进行网络查询是否有更新,有更新则更新书籍的章节信息,没有则提示没有更多章节了
                        //如果有新的章节,新建新的控制器,并请求网络数据
                        
                        //如果有新的章节,又有两种请求,一种是本地已经缓存过的章节,二是本地没有缓存的章节
                        // 为了节省空间,阅读器退出时,只保存阅读进度中的章节,其它不保存
                        // 网络请求其它章节成功后会放入内存中,下次可以直接从内存中获取
                        //1.获取新的章节的缓存
                        let chapter = record.chapter + 1
                        // 有新的章节
                        if chapter < (bookDetail.chapters?.count ?? 0) {
                            // 内存中有缓存,直接获取控制器,model应该为新的model
                            //获取chapter的id,然后查询内存
                            if let link = bookDetail.chapters?[chapter]["link"] as? String {
                                if let chapterModel = chapterDict[link] as? QSChapter {
                                    let pageVC = self.localChapter(chapterModel: chapterModel)
                                    return pageVC
                                }
                            }
                            // 内存中不存在,需要网络获取
                            let pageVC = self.networkNextChapter()
                            return pageVC
                        }
                    }
                } else { // 2(1) 当前章节信息为空,那么下一页必定是新的控制器
                    //判断是否还有新的章节,如果没有,说明已经阅读到最新章节了,可以进行提示或者进行网络查询是否有更新,有更新则更新书籍的章节信息,没有则提示没有更多章节了
                    //如果有新的章节,新建新的阅读控制器,先获取内存中的数据,再请求网络数据
                    let chapterIndex = record.chapter + 1
                    if chapterIndex < (bookDetail.chapters?.count ?? 0) {
                        // 内存缓存
                        if let id = bookDetail.chapters?[chapterIndex]["link"] as? String {
                            if let chapterModel = chapterDict[id] as? QSChapter {
                                let pageVC = self.localChapter(chapterModel: chapterModel)
                                return pageVC
                            }
                        }
                        // 内存中不存在,需要网络获取
                        let pageVC = self.networkNextChapter()
                        return pageVC
                    }
                }
            }
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]){
        QSLog("viewControllers:\(pendingViewControllers)")
        // viewControllers控制器可能会取消，因此这里要记住这个控制器，获取到数据后，刷新的是这个控制器
        currentReaderVC.qs_removeObserver()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool){
        
        if !completed {
            currentReaderVC = previousViewControllers.first as! PageViewController
        } else {
            // 更新阅读记录
            if curlPageStyle == .forwards {
                
                // 向前章节,完成后从内存中获取当前章节,更新阅读记录中的model
                // 判断是否为新的章节
                if bookDetail.record?.chapterModel == nil { // 肯定是新章节
                    bookDetail.record?.page = 0
                    bookDetail.record?.chapter += 1
                    isAnimatedFinished = completed
                    if let link = bookDetail.chapters?[bookDetail.record!.chapter]["link"] as? String {
                        if let chapterModel = chapterDict[link] as? QSChapter {
                            //record 必定存在,否则直接退出了,不会进行翻页
                            bookDetail.record?.chapterModel = chapterModel
                        }
                    }
                } else {
                    // 有可能是新章节,如果
                    if let pageIndex = bookDetail.record?.page,let totalPage = bookDetail.record?.chapterModel?.pages.count {
                        if pageIndex < totalPage - 1 {//说明不是最后一页,直接更新记录
                            bookDetail.record?.page += 1
                            isAnimatedFinished = nil
                            //                            bookDetail.record?.chapterModel = chapterModel
                            // 更新record的mode时,需要刷新当前页面的page
                        } else {//最后一页,新的章节
                            bookDetail.record?.chapter += 1
                            bookDetail.record?.page = 0
                            isAnimatedFinished = completed
                            // 置空,如果请求已经结束,内存中已存在该chapter信息,如果请求尚未结束,置空,待请求结束后更新model
                            // 新的章节重新获取model@property (nonatomic, copy) NSString *mobilePhone;
                            bookDetail.record?.chapterModel = nil
                            if let link = bookDetail.chapters?[bookDetail.record!.chapter]["link"] as? String {
                                if let chapterModel = chapterDict[link] as? QSChapter {
                                    //record 必定存在,否则直接退出了,不会进行翻页
                                    bookDetail.record?.chapterModel = chapterModel
                                }
                            }
                        }
                    }
                }
            } else if curlPageStyle == .backwards {
                // 上一页的逻辑需要注意,如果是本地缓存的model,那么应该直接展示上一章节的最后一页
                if bookDetail.record?.chapterModel == nil { // 请求的是新的一章
                    // 既然动画完成了,说明这个章节是必然存在的,不用判断
                    bookDetail.record?.page = 0
                    // chapter 大于零
                    let chapterIndex = bookDetail.record!.chapter >= 1 ? bookDetail.record!.chapter - 1:0
                    bookDetail.record?.chapter = chapterIndex
                    isAnimatedFinished = completed
                    if let link = bookDetail.chapters?[bookDetail.record!.chapter]["link"] as? String {
                        if let chapterModel = chapterDict[link] as? QSChapter {
                            //record 必定存在,否则直接退出了,不会进行翻页
                            bookDetail.record?.chapterModel = chapterModel
                            bookDetail.record?.page = chapterModel.pages.count - 1
                        }
                    }
                } else {
                    if let pageIndex = bookDetail.record?.page {
                        if pageIndex == 0 {//是第一页,请求的是上一个章节
                            bookDetail.record?.page = 0
                            // chapter 大于零
                            let chapterIndex = bookDetail.record!.chapter >= 1 ? bookDetail.record!.chapter - 1:0
                            bookDetail.record?.chapter = chapterIndex
                            bookDetail.record?.chapterModel = nil
                            isAnimatedFinished = completed
                            if let link = bookDetail.chapters?[bookDetail.record!.chapter]["link"] as? String {
                                if let chapterModel = chapterDict[link] as? QSChapter {
                                    //record 必定存在,否则直接退出了,不会进行翻页
                                    bookDetail.record?.chapterModel = chapterModel
                                    bookDetail.record?.page = chapterModel.pages.count - 1
                                }
                            }
                        } else { //不是第一页,当前章节的前一页
                            bookDetail.record?.page -= 1
                            isAnimatedFinished = nil
                        }
                    }
                }
            }
            // 记录
            bookDetail.record?.animatedComplete = completed
            currentReaderVC = pageViewController.viewControllers?.first as! PageViewController
            if let model = bookDetail.record?.chapterModel {
                if let pageIndex = bookDetail.record?.page {
                    let pageModel = model.pages[pageIndex]
                    currentReaderVC.page = pageModel
                }
            }
        }
        
        
        //如果翻页完成，则completed=true，否则为false
//        isAnimatedFinished = completed//请求数据时根据此字段更新当前页
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
                BookManager.shared.modifyRecord(book, book.record?.chapter, book.record?.page)
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
        bookDetail.record?.chapter = index
        bookDetail.record?.page = 0
        bookDetail.record?.chapterModel = nil
        if let link = bookDetail.chapters?[index]["link"] as? String {
            if let chapterModel = chapterDict[link] as? QSChapter {
                bookDetail.record?.chapterModel = chapterModel
            }
        }
        let pageVC = PageViewController()
        if let model = bookDetail.record?.chapterModel {
            pageVC.page = model.pages[0]
        } else {
            isAnimatedFinished = true
            presenter?.interactor.getChapter(chapterIndex: index, pageIndex: 0)
        }
        let backgroundVC = QSReaderBackgroundViewController()
        backgroundVC.setBackground(viewController: pageVC)
        pageController?.setViewControllers([pageVC,backgroundVC], direction: .forward, animated: true) { (finished) in
            self.toolBar.hideWithAnimations(animation: true)
        }
        currentReaderVC = pageVC
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
        // 网络请求章节信息成功,不一定是阅读记录的请求
        if let completed = isAnimatedFinished {
            isAnimatedFinished = nil
            // 翻页动画完成,更新内存中的章节信息,如果翻页成功,更新阅读记录中的model
            let model = getChapterDict(chapter: chapter, index: index)
            if completed {
                if let chapterModel = model {
                    if bookDetail.record?.chapter == chapterModel.curChapter {
                        bookDetail.record?.chapterModel = chapterModel
                        bookDetail.record?.chapter = chapterModel.curChapter
                        bookDetail.record?.page = 0
                        currentReaderVC.page = chapterModel.pages[bookDetail.record!.page]
                    } else {
                        getChapterDict(chapter: chapter, index: index)
                    }
                }
            }
        } else {
            // 翻页动画尚未完成,请求的章节信息放入内存中,等待翻页动画完成后获取
            getChapterDict(chapter: chapter, index: index)
        }
    }
    
    // 将新获取的章节信息存入chapterDict中
    @discardableResult
    func getChapterDict(chapter:[String:Any],index:Int)->QSChapter?{
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
            qsChapter.getPages() // 直接计算page
            chapterDict[link] = qsChapter
            return qsChapter
        }
        return nil
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
