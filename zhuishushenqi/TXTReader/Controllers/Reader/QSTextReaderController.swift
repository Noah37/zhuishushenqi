
//  QSTextReaderController.swift
//  TXTReader
//
//  Created by Nory Chao on 16/11/24.
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
    var book:QSBook?
    var resources:[ResourceModel]?
    var selectedIndex:Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSubviews()
        if let book = bookDetail {
            presenter?.viewDidLoad(bookDetail:book)
        }
        setRoot()
    }
    
    func setSubviews() -> Void {
        view.backgroundColor = UIColor.white
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
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
        selectedIndex = bookDetail?.sourceIndex ?? 1
        self.resources = bookDetail?.resources
        self.chapters = bookDetail?.chapters ?? []
        let rootController = PageViewController()
        var chapter:QSChapter?
        var page:QSPage?
        if (book?.chapters?.count ?? 0) > self.currentChapter {
            chapter = book?.chapters?[self.currentChapter]
            if (chapter?.pages.count ?? 0) > self.currentPage {
                page = chapter?.pages[self.currentPage]
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
        tempPage = (tempPage == -1 ? ((self.book?.chapters?[tempChapter].pages.count ?? 0) - 1) : tempPage)
        if tempPage < 0 {
            tempPage = 0
        }
        if tmpPage < (self.book?.chapters?[tempChapter].pages.count ?? 0 - 1) && tmpPage >= 0 {
            //说明是当前章节，不需要请求新的数据
            pageVC.page = self.book?.chapters?[tempChapter].pages[tempPage]
        } else {
            //新的章节，重新请求数据
            let chapterModel = presenter?.interactor.getPage(chapter: tempChapter, pageIndex: tempPage)
            if let model = chapterModel {
                self.book?.chapters?[tempChapter] = model
            }
            if (chapterModel?.pages.count ?? 0) > tempPage {
                pageVC.page = chapterModel?.pages[tempPage]
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
        self.book = presenter?.interactor.book(bookDetail: bookDetail,chapters:self.chapters,resources:self.resources)
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
        toolBar.title = self.book?.bookName ?? ""
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
        if tempPage < ((self.book?.chapters?[self.currentChapter].pages.count ?? 0) - 1) {
            tempPage += 1
        }else {
            if tempChapter < (self.book?.chapters?.count ?? 0) - 1 {
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
        bookDetail?.sourceIndex = selectedIndex
        bookDetail?.chapters = chapters
        bookDetail?.resources = resources
        let exist = isExistShelf(bookDetail: bookDetail)
        if !exist {
            self.alert(with: "追书提示", message: "是否将本书加入我的收藏", okTitle: "好的", cancelTitle: "不了", okAction: { (action) in
                updateBookShelf(bookDetail: self.bookDetail, type: .add)
                self.toolBarDismiss()
            }, cancelAction: { (action) in
                self.toolBarDismiss()
            })
        }else{
            updateReadingInfo(bookDetail: bookDetail)
            toolBarDismiss()
        }
    }
    
    func toolBarDismiss(){
        self.toolBar.hideWithAnimations(animation: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func catagoryClicked(){
        let modalVC = CategoryController()
        modalVC.categoryDelegate = self
        modalVC.titles = chapters
        modalVC.selectedIndex = currentChapter
        modalVC.resource = self.resources?[selectedIndex]
        //Application tried to present modally an active controller
        let nav = UINavigationController(rootViewController: modalVC)
        present(nav, animated: true){
            (finished) in
            self.isToolBarHidden = false
        }
    }
    
    func readBg(type: ReadeeBgType) {
        setReaderBg(type: type)
        self.pageViewController?.bgView.image = getReaderBgColor()
    }
    
    func fontChange(size: Int) {
        setFontSize(size: size)
        book?.attribute = [NSFontAttributeName:UIFont.systemFont(ofSize: CGFloat(size))]
        //字体变小，页数变少
        if tempPage > ((book?.chapters?[tempChapter].pages.count ?? 0) - 1) {
            tempPage = (book?.chapters?[tempChapter].pages.count ?? 0) - 1
        }
        //字体变大，页数变多，根据追书的设计保持当前页不变
        currentPage = tempPage
        self.pageViewController?.page = book?.chapters?[tempChapter].pages[tempPage]
    }
    
    func brightnessChange(value: CGFloat) {
        //此处亮度调节是对于手机的，退出app后应还原
        UIScreen.main.brightness = value
        setBrightness(value: value)
    }
    
    func changeSourceClicked() {
        let sourceVC = ChangeSourceViewController()
        sourceVC.id = "\(self.bookDetail?._id ?? "")"
        sourceVC.sources = self.resources
        sourceVC.selectedIndex = self.selectedIndex
        sourceVC.selectAction = { (index:Int,sources:[ResourceModel]?) in
            self.selectedIndex = index
            self.resources = sources
            self.presenter?.interactor.requestAllChapters(selectedIndex: self.selectedIndex)
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
        let pageVC = getPageViewController()
        let backgroundVC = QSReaderBackgroundViewController()
        backgroundVC.setBackground(viewController: self.pageViewController!)
        pageController.setViewControllers([pageVC,backgroundVC], direction: .forward, animated: true) { (finished) in
            self.currentChapter = self.tempChapter
            self.toolBar.hideWithAnimations(animation: true)
        }
    }
}

extension QSTextReaderController:QSTextViewProtocol{
    func showChapter(chapter:Dictionary<String,Any>,index:Int){
        self.book?.chapters = presenter?.interactor.setChapters(chapterParam: chapter as NSDictionary?,index:index,chapters: self.book?.chapters ?? [])
//        self.tempPage = 0
        let chapterInfo = book?.chapters?[self.tempChapter]
        if (chapterInfo?.pages.count ?? 0) > tempPage {
            pageViewController?.page = chapterInfo?.pages[self.tempPage]
        }
    }
    
    func showAllChapter(chapters: [NSDictionary]) {
        self.chapters = chapters
        self.tempChapter = self.currentChapter
        self.tempPage = self.currentPage
        self.presenter?.interactor.requestChapter(atIndex: self.tempChapter)
        
    }
    
    func showResources(resources: [ResourceModel]) {
        self.resources = resources
        presenter?.interactor.requestAllChapters(selectedIndex: selectedIndex)
    }
    
    func showLocalChapter() {
        
        let chapterModel = presenter?.interactor.getLocalPage(chapter: tempChapter, pageIndex: tempPage)
        if let model = chapterModel {
            self.book?.chapters?[tempChapter] = model
        }
        if (chapterModel?.pages.count ?? 0) > tempPage {
            self.pageViewController?.page = chapterModel?.pages[tempPage]
        }
    }
    
    func showEmpty(){
        
    }
}
