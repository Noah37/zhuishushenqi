
//  QSTextReaderController.swift
//  TXTReader
//
//  Created by Nory Cao on 16/11/24.
//  Copyright © 2016年 QS. All rights reserved.
//

/*
 *
 * 换源需要做的事情，重新请求所有章节信息，成功后，刷新QSBook的信息
 * 请求到某一章节的信息后，需要刷新QSBook中的QSChapter信息
 * 保存当前阅读进度
 * 退出阅读器时，若尚未加入书架，则提示用户是否需要加入书架，选择是，加入书架，同时刷新书架中书籍的阅读信息，选择否，则不记录信息
 * 记录信息包括，当前阅读的章节，页面，上次更新时间
 */

import UIKit
import QSNetwork

class QSTextReaderController: UIViewController {
    
    // save read history,default true,bookshelf are false
    var saveRecord:Bool = true
    
    var presenter: QSTextPresenterProtocol?

    var bookDetail:BookDetail?
    //all chapters
    var chapters = [NSDictionary](){
        didSet{
            self.setBookInfo()
        }
    }
    var isToolBarHidden:Bool = true
    var isAnimatedFinished:Bool = false
    var currentPage:Int = 0
    var currentChapter:Int = 0
    var tempPage:Int = 0
    var tempChapter:Int = 0
    var pageViewController:PageViewController?
    var window:UIWindow?
    var callback:QSTextCallBack?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        setSubviews()
        setRoot()
        if let book = bookDetail {
            presenter?.viewDidLoad(bookDetail:book)
        }
        bookDetail?.isUpdated = false
        if let book = bookDetail {
            updateBookShelf(bookDetail: book, type: .update, refresh: true)
        }
    }
    
    func setSubviews() {
//        view.backgroundColor = UIColor.black
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        
        DispatchQueue.global().async {
            if self.saveRecord {
                var historyList:[BookDetail] = BookShelfInfo.books.readHistory
                if let book  = self.bookDetail {
                    if !isExist(bookDetail: book, at: historyList) {
                        historyList.append(book)
                    }
                }
                BookShelfInfo.books.readHistory = historyList
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.tapCount == 1 {
            if isToolBarHidden {
                toolBar.showWithAnimations(animation: true)
            }
            isToolBarHidden = !isToolBarHidden
        }
    }
    
    //MARK: - custom action
    private func setRoot(){
        currentChapter = bookDetail?.chapter ?? 0
        currentPage = bookDetail?.page ?? 0
        tempChapter = currentChapter
        tempPage = currentPage
//        self.chapters = bookDetail?.chapters ?? []
        let rootController = PageViewController()
        var chapter:QSChapter?
        var page:QSPage?
        if (bookDetail?.book?.chapters?.count ?? 0) > self.currentChapter {
            chapter = bookDetail?.book?.chapters?[self.currentChapter]
            if (chapter?.getPages().count ?? 0) > self.currentPage {
                page = chapter?.getPages()[self.currentPage]
            }
        }
        rootController.page = page
        pageViewController = rootController
        pageController.setViewControllers([rootController], direction: .forward, animated: true, completion: nil)
        addChildViewController(pageController)
//        pageController.view.frame = CGRect(x: 0, y: 20, width: self.view.bounds.width, height: self.view.bounds.height - 40)
        view.addSubview(pageController.view)
    }
    
    //获取 pageViewController
    func getPageViewController()->PageViewController{
        let pageVC = PageViewController()
        QSLog("\(NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true))")
        let tmpPage = tempPage
        tempPage = (tempPage == -1 ? ((bookDetail?.book?.chapters?[tempChapter].getPages().count ?? 0) - 1) : tempPage)

        if tempPage < 0 {
            tempPage = 0
        }
        //换源之后的越界问题
        if tempChapter > (bookDetail?.book?.totalChapters ?? 0)  {
            tempChapter = (bookDetail?.book?.totalChapters ?? 1) - 1
            tempPage = 0
        }
        if tmpPage < (bookDetail?.book?.chapters?[tempChapter].getPages().count ?? 0 - 1) && tmpPage >= 0 {
            //说明是当前章节，不需要请求新的数据
            pageVC.page = bookDetail?.book?.chapters?[tempChapter].getPages()[tempPage]
        } else {
            //新的章节，重新请求数据
            let chapterModel = presenter?.interactor.getChapter(chapterIndex: tempChapter, pageIndex: tempPage)
            if let model = chapterModel {
                bookDetail?.book?.chapters?[tempChapter] = model
            }
            if (chapterModel?.getPages().count ?? 0) > tempPage {
                pageVC.page = chapterModel?.getPages()[tempPage]
            }
        }
        pageViewController = pageVC
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
    
    func setBookInfo(){//更换书籍来源则需要更新book.chapters信息,请求某一章节成功后也需要刷新chapters的content及其他信息
        bookDetail?.book = presenter?.interactor.book(bookDetail: bookDetail,chapters:self.chapters,resources:bookDetail?.resources)
    }
    
    //MARK:  - lazy variable
    lazy var pageController:UIPageViewController = {
        let pageController = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)
        pageController.dataSource = self
        pageController.delegate = self
        pageController.isDoubleSided = true
        return pageController
    }()
    
    lazy var toolBar:ToolBar = {
        let toolBar:ToolBar = ToolBar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        //        toolBar.isHidden = true
        toolBar.toolBarDelegate = self
        toolBar.title = self.bookDetail?.book?.bookName ?? ""
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
            backgroundVC.setBackground(viewController: self.pageViewController!)
            return backgroundVC
        }
        QSLog("page:\(currentPage) \n chapter:\(currentChapter)")
        tempChapter = currentChapter
        tempPage = currentPage
        if tempPage == 0 {
            if tempChapter == 0 {
                return nil
            }
            tempChapter -= 1
            tempPage -= 1 //用于判断是向前翻页
        } else {
            tempPage -= 1
        }
        let pageVC = getPageViewController()
        
        return pageVC
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?{
        if viewController.isKind(of: PageViewController.self) {
            let backgroundVC = QSReaderBackgroundViewController()
            backgroundVC.setBackground(viewController: self.pageViewController!)
            return backgroundVC
        }
        QSLog("page:\(currentPage) \n chapter:\(currentChapter)")
        tempPage = currentPage
        tempChapter = currentChapter
        //换源之后的越界问题
        if tempChapter > (bookDetail?.book?.totalChapters ?? 0)  {
            tempChapter = (bookDetail?.book?.totalChapters ?? 1) - 1
            tempPage = 0
        }
        if tempPage < ((bookDetail?.book?.chapters?[self.currentChapter].getPages().count ?? 0) - 1) {
            tempPage += 1
        }else {
            if tempChapter < (bookDetail?.book?.chapters?.count ?? 0) - 1 {
                tempChapter += 1
                tempPage = 0
            }else{
                return nil
            }
        }
        let pageVC = getPageViewController()
        return pageVC
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]){
        QSLog(pendingViewControllers)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool){
        //如果翻页成功，则completed=true，否则为false
        QSLog(previousViewControllers)
        isAnimatedFinished = completed//请求数据时根据此字段更新当前页
        if  completed == true {
            currentChapter = tempChapter
            currentPage = tempPage
        }else{
            tempPage = currentPage
            tempChapter = currentChapter
        }
    }
    
    //MARK: - ToolBarDelegate
    func backButtonDidClicked(){
        bookDetail?.chapter = tempChapter
        bookDetail?.page = tempPage
        //如果有更新，退出时设置为已观看
        bookDetail?.isUpdated = false
        //一般新进入或者换源，才会有变化
        if chapters.count > 0 {
            bookDetail?.chapters = chapters
        }
        let exist = isExistShelf(bookDetail: bookDetail)
        if !exist {
            self.alert(with: "追书提示", message: "是否将本书加入我的收藏", okTitle: "好的", cancelTitle: "不了", okAction: { (action) in
                updateBookShelf(bookDetail: self.bookDetail, type: .add,refresh:true)
                self.toolBarDismiss()
            }, cancelAction: { (action) in
                self.toolBarDismiss()
            })
        }else{
            updateBookShelf(bookDetail: self.bookDetail, type: .update, refresh: false)
            toolBarDismiss()
        }
        if let back = callback {
            if let book = self.bookDetail {
                back(book)
            }
        }
    }
    
    func toolBarDismiss(){
        self.toolBar.hideWithAnimations(animation: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func catagoryClicked(){
        if let book = self.bookDetail {
            presenter?.didClickCategory(book:book)
        }
    }
    
    func readBg(type: ReadeeBgType) {
        setReaderBg(type: type)
        self.pageViewController?.bgView.image = getReaderBgColor()
    }
    
    func fontChange(size: Int) {
        setFontSize(size: size)
        bookDetail?.book?.attribute = [NSFontAttributeName:UIFont.systemFont(ofSize: CGFloat(size))]
        //字体变小，页数变少
        if tempPage > ((bookDetail?.book?.chapters?[tempChapter].getPages().count ?? 0) - 1) {
            tempPage = (bookDetail?.book?.chapters?[tempChapter].getPages().count ?? 0) - 1
        }
        //字体变大，页数变多，根据追书的设计保持当前页不变
        currentPage = tempPage
        self.pageViewController?.page = bookDetail?.book?.chapters?[tempChapter].getPages()[tempPage]
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
        UIScreen.main.brightness = value
        setBrightness(value: value)
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
//            updateBookShelf(bookDetail: self.bookDetail, type: .update, refresh: false)
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
        tempChapter = index
        tempPage = 0
        currentPage = tempPage
        self.bookDetail?.chapter = tempChapter
        let pageVC = getPageViewController()
        let backgroundVC = QSReaderBackgroundViewController()
        backgroundVC.setBackground(viewController: self.pageViewController!)
        pageController.setViewControllers([pageVC,backgroundVC], direction: .forward, animated: true) { (finished) in
            self.currentChapter = self.tempChapter
            self.toolBar.hideWithAnimations(animation: true)
        }
    }
}

extension QSTextReaderController:QSTextViewProtocol,QSCategoryDelegate{
    
    func showBook(book:QSBook){
        bookDetail?.book = book
        let chapterModel = presenter?.interactor.getChapter(chapterIndex: tempChapter, pageIndex: tempPage)
        if (chapterModel?.getPages().count ?? 0) > tempPage {
            let pages = chapterModel?.getPages()
            pageViewController?.page = pages?[self.tempPage]
        }
    }
    
    func downloadFinish(book: QSBook) {
        self.bookDetail?.book = book
    }
    
    func showProgress(dict: [String : Any]) {
        toolBar.progressView.dict = dict
    }
    
    func showChapter(chapter:Dictionary<String,Any>,index:Int){
        bookDetail?.book?.chapters = presenter?.interactor.setChapters(chapterParam: chapter as NSDictionary?,index:index,chapters: bookDetail?.book?.chapters ?? [])
        let chapterInfo = bookDetail?.book?.chapters?[self.tempChapter]
        
        if (chapterInfo?.getPages().count ?? 0) > tempPage {
            pageViewController?.page = chapterInfo?.getPages()[self.tempPage]
        }
    }
    
    func showAllChapter(chapters: [NSDictionary]) {
        self.chapters = chapters
        self.tempChapter = self.currentChapter
        self.tempPage = self.currentPage
        //换源引起的数组越界
        if self.tempChapter > self.chapters.count - 1 {
            self.tempChapter = self.chapters.count - 1
            self.currentChapter = self.tempChapter
        }
        self.presenter?.requestChapter(index: self.tempChapter)
    }
    
    func showResources(resources: [ResourceModel]) {
        bookDetail?.resources = resources
        presenter?.requestAllChapter(index: bookDetail?.sourceIndex ?? 0)
    }
    
    func showEmpty(){
        
    }
}
