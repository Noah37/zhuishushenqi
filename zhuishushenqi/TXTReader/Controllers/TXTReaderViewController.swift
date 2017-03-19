//
//  TXTReaderViewController.swift
//  TXTReader
//
//  Created by caonongyun on 16/11/24.
//  Copyright © 2016年 masterY. All rights reserved.
//

import UIKit
import Alamofire

class TXTReaderViewController: UIViewController {

    var CategoryUrl = "\(baseUrl)/atoc/57df797cb061df9e19b8b030?view=chapters"
    //这个id是zhuishu的id
    var bookId:String = ""
    //这个是不同来源的id
    var id:String = "" {
        didSet{
            CategoryUrl = "\(baseUrl)/atoc/\(id)?view=chapters"
        }
    }
    //all chapters
    var chapters = [NSDictionary]()
    var chapterInfo:ChapterInfo? = ChapterInfo()
    var isToolBarHidden:Bool = true
    var isAnimatedFinished:Bool = false
    var currentPage:Int = 0
    var currentChapter:Int = 0
    var tempPage:Int = 0
    var tempChapter:Int = 0
    var pageViewController:PageViewController?
    var window:UIWindow?
    var model:NSDictionary?
    var resources:[ResourceModel] = [ResourceModel]()  {
        didSet{
            if resources.count > 1 {
                selectedResource = resources[1]
            }else if resources.count > 0{
                selectedResource = resources[0]
            }
        }
    }
    var selectedResource:ResourceModel?
    
    var selectedIndex:Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        requestAllChapters()
//        loadAllChapters()
        setRoot()
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
        let rootController = PageViewController()
        rootController.pageInfo = PageInfo(chapterInfo!, pageIndex: currentPage, total: chapterInfo?.ranges?.count ?? 0)
        pageViewController = rootController
        pageController.setViewControllers([rootController], direction: .forward, animated: true, completion: nil)
        addChildViewController(pageController)
        view.addSubview(pageController.view)
    }
    
    //网络请求所有的章节信息
    func requestAllChapters(){
        Alamofire.request(CategoryUrl).responseJSON { (response) in
            if let json = response.result.value as? NSDictionary {
                QSLog("JSON:\(json)")
                if let chapters = json["chapters"] as? [NSDictionary] {
                    QSLog("Chapters:\(chapters)")
                    self.chapters = chapters
                    self.requestChapter(atIndex: self.currentChapter)
                }
            }
        }
    }
    
    //网络请求某一章节的信息
    func requestChapter(atIndex index:Int){
        if index >= chapters.count {
            return;
        }
        let url = "\(chapterURL)/\(chapters[index].object(forKey: "link") ?? "")?k=19ec78553ec3a169&t=1476188085"
        Alamofire.request(url).responseJSON { (response) in
            if let json = response.result.value as? Dictionary<String, Any> {
                QSLog("JSON:\(json)")
                if let chapter = json["chapter"] as?  Dictionary<String, Any> {
                    
                    let chapterInfo = ChapterInfo(JSON: chapter)
                    QSLog(chapterInfo?.body)
                    chapterInfo?.currentIndex = index
                    chapterInfo?.resource = self.selectedResource
                    self.chapterInfo = chapterInfo
                    ChapterInfo.updateLocalModel(localModel: self.chapterInfo!,id:self.id)
                    //不论向前或向后翻页，都从第一页开始显示
                    self.tempPage = 0
                    //请求到数据后需要刷新当前页,如果不是当前页，则不需要刷新,否则会出现跳页
//                    if self.chapterInfo?.id == self.pageViewController?.pageInfo?.chapterInfo?.id {
                        DispatchQueue.main.async {
                            let pageInfp:PageInfo = PageInfo(self.chapterInfo!, pageIndex: self.tempPage, total: self.chapterInfo?.ranges?.count ?? 0)
                            self.pageViewController?.pageInfo = pageInfp
                        }
//                    }
                }
            }
        }
    }
    
    //本地加载json章节信息
    private func loadChapter(){
        if let model = ChapterInfo.localModelWithKey(key: chapters[tempPage].object(forKey: "id") as! String) {
            chapterInfo = model
            return
        }
        let mainBundlePath:String = Bundle.main.bundlePath.appendingFormat("%@", "/ChapterInfo.json")
        let ChapterInfoData = NSData(contentsOfFile: mainBundlePath)
        if let data = ChapterInfoData {
            do{
                let chapterInfoDict = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments)
                if let chapter = chapterInfoDict as? Dictionary<String,Any> {
                    if let chapterInfo = chapter["chapter"] as? Dictionary<String,Any> {
                        let chapterInfoo = ChapterInfo(JSON:chapterInfo)
                        self.chapterInfo = chapterInfoo
                        ChapterInfo.updateLocalModel(localModel: self.chapterInfo!,id:self.id)
                    }
                }
            }catch{
                
            }
        }
    }
    
    //加载本地的json数据（貌似可以节省很多流量）
    private func loadAllChapters(){
        let mainBundlePath:String = Bundle.main.bundlePath.appendingFormat("%@", "/Chapters.json")
        let allChapter = NSData(contentsOfFile: mainBundlePath)
        if let data = allChapter {
            do{
                let allChapterDict = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.allowFragments)
                if let chapters = allChapterDict as? NSDictionary {
                    self.chapters = chapters.object(forKey: "chapters") as! [NSDictionary]
                    QSLog(self.chapters)
                    loadChapter()
                }
            }catch{
                
            }
        }
    }
    
    //获取 pageViewController
    func getPageViewController()->PageViewController{
        var pageVC = PageViewController()
        var currId = pageViewController?.pageInfo?.chapterInfo?.resource?.link as NSString?
        if currId?.pathExtension != "" {
            currId = currId?.deletingLastPathComponent as NSString?
        }
        var newId = chapters[tempChapter].object(forKey: "link") as? String as NSString?
        if newId?.pathExtension != "" {
            newId = newId?.deletingLastPathComponent as NSString?
        }
        QSLog("currId:\(currId ?? "")\n,newId:\(newId)")
        QSLog("\(NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true))")
        if tempPage < pageViewController?.pageInfo?.chapterInfo?.ranges?.count ?? 0 - 1 && tempChapter == currentChapter{
            //说明是当前章节，不需要请求新的数据
            pageVC.pageInfo = PageInfo(pageViewController!.pageInfo!.chapterInfo!, pageIndex: tempPage, total: pageViewController?.pageInfo?.chapterInfo?.ranges?.count ?? 0)
        } else {
            //新的章节，重新请求数据
           pageVC = getNewChapter()
        }
        pageViewController = pageVC
        return pageVC
    }
    
    //获取新的章节信息
    func getNewChapter() -> PageViewController{
        let pageVC = PageViewController()
        var chapterInfo = ChapterInfo()
        //获取本地 model，存在即返回,使用本章节序号 + 小说id的md5
        let localKey:String = "\(tempChapter)\(self.id)"
        if let model = ChapterInfo.localModelWithKey(key: localKey) {
            chapterInfo = model
            //判断向前翻页还是向后翻页
            tempPage == -1 ? (tempPage = (chapterInfo.ranges?.count ?? 0) - 1) : (tempPage = 0)
            pageVC.pageInfo = PageInfo(chapterInfo, pageIndex: tempPage, total: chapterInfo.ranges?.count ?? 0)
            return pageVC
        }
        tempPage == -1 ? (tempPage = 0) : (tempPage = tempPage)
        let title = chapters[tempChapter].object(forKey: "title")
        let id = chapters[tempChapter].object(forKey: "id")
        chapterInfo.title = title as? String ?? "QSSSSSSS"
        chapterInfo.id = id as? String ?? "QSSSSSS"
        pageVC.pageInfo = PageInfo(chapterInfo, pageIndex: 0, total: 1)
        requestChapter(atIndex: tempChapter)
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
    lazy var pageController:UIPageViewController = {
       let pageController = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)
        pageController.dataSource = self
        pageController.delegate = self
        return pageController
    }()
    
    lazy var toolBar:ToolBar = {
        let toolBar:ToolBar = ToolBar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
//        toolBar.isHidden = true
        toolBar.toolBarDelegate = self
        return toolBar;
    }()
}

extension TXTReaderViewController:UIPageViewControllerDataSource,UIPageViewControllerDelegate,ToolBarDelegate,CategoryDelegate{
    
    //MARK: - UIPageViewControllerDataSource，UIPageViewControllerDelegate
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?{
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
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?{
        QSLog("page:\(currentPage) \n chapter:\(currentChapter)")
        tempPage = currentPage
        tempChapter = currentChapter
        if tempPage < (self.pageViewController?.pageInfo?.chapterInfo?.ranges?.count ?? 0) - 1 {
            tempPage += 1
        }else {
            if tempChapter < chapters.count - 1 {
                tempChapter += 1
                tempPage = 0
            }else{
                return nil
            }
        }
        let pageVC = getPageViewController()
        return pageVC
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]){
        QSLog(pendingViewControllers)
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool){
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
        self.toolBar.hideWithAnimations(animation: true)
        dismiss(animated: true, completion: nil)
    }
    
    func catagoryClicked(){
        let modalVC = CategoryController()
        modalVC.categoryDelegate = self
        modalVC.titles = chapters
        modalVC.selectedIndex = currentChapter
        modalVC.id = self.id

        //Application tried to present modally an active controller
        present(modalVC, animated: true){
            (finished) in
            self.isToolBarHidden = false
        }
    }
    
    func changeSourceClicked() {
        let sourceVC = ChangeSourceViewController()
        sourceVC.id = "\(self.bookId)"
        sourceVC.sources = self.resources
        sourceVC.selectedIndex = self.selectedIndex
        sourceVC.selectAction = { (index:Int) in
            self.selectedIndex = index
            self.id = self.resources[index]._id
            self.requestAllChapters()
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
        pageController.setViewControllers([pageVC], direction: .forward, animated: true) { (finished) in
            self.currentChapter = self.tempChapter
            self.toolBar.hideWithAnimations(animation: true)
        }
    }

}
