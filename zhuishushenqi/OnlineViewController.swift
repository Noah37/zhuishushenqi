//
//  OnlineViewController.swift
//  PageViewController
//
//  Created by caonongyun on 16/10/11.
//  Copyright © 2016年 CNY. All rights reserved.
//

import UIKit
import Alamofire

class OnlineViewController: UIViewController,UIPageViewControllerDataSource,UIPageViewControllerDelegate,ToolBarDelegate ,CategoryDelegate{
    var currentChapter:Int = 0
    var currentPage:Int = 0
    var chapters:NSArray = []
    var bookName:String = ""
    var nextVC:PageViewController?
    private var isToolBarShow:Bool = false
    var pageInfoModel:PageInfoModel?
    lazy var pageController:UIPageViewController = {
        let pageController = UIPageViewController(transitionStyle: .PageCurl, navigationOrientation: .Horizontal, options: nil)
        pageController.dataSource = self
        pageController.delegate = self
        let model = PageInfoModel()
        model.bookName = self.bookName
        model.type = .Online
        self.pageInfoModel = model.getModelWithContent("",bookName: self.bookName)
        self.pageInfoModel?.bookName = self.bookName
        self.currentPage = self.pageInfoModel?.pageIndex ?? 0
        self.currentChapter = self.pageInfoModel?.chapter ?? 0
 
        pageController.setViewControllers([self.pageViewWithChapter(self.pageInfoModel?.chapter ?? 0,page:self.pageInfoModel?.pageIndex ?? 0)], direction: .Forward, animated: true, completion: nil)
        
        return pageController
    }()
    
    lazy var testString:String = {
        let path = NSBundle.mainBundle().pathForResource("743.txt", ofType: nil)
        let data = NSData(contentsOfFile: path!)
        let encodingGB_18030_2000 = CFStringConvertEncodingToNSStringEncoding(UInt32(CFStringEncodings.GB_18030_2000.rawValue))
        let encodingUTF8 = NSUTF8StringEncoding
        var testString:String = (NSString(data: data!, encoding: encodingGB_18030_2000) ?? "") as String
        if (testString as NSString).length == 0{
            testString = (NSString(data: data!, encoding: encodingUTF8) ?? "") as String
        }
        return testString
    }()
    
    //工具栏，阅读时点击屏幕弹出
    private lazy var navBar:ToolBar = {
        let navView:ToolBar = ToolBar(frame: CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height))
        navView.hidden = true
        navView.toolBarDelegate = self
        return navView
    }()
    
    /// 阅读页面，主要显示文本
    private lazy var pageView:PageView = {
        let pageView = PageView()
        pageView.frame = CGRectMake(20, 30, self.view.bounds.size.width - 40, self.view.bounds.size.height - 40)
        pageView.backgroundColor = UIColor.whiteColor()
        return pageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func tapAction(tap:UITapGestureRecognizer){
        
        navBar.showWithAnimations(true)
    }
    
    //MARK: - 目录中选中的第几章
    func categoryDidSelectAtIndex(index:Int){
        let model = pageInfoModel
        model?.chapter = index
        model?.pageIndex = 0
        pageInfoModel = model
        currentPage = model!.pageIndex
        currentChapter = model!.chapter
        pageController.setViewControllers([self.pageViewWithChapter(model!.chapter,page:model!.pageIndex)], direction: .Forward, animated: true, completion: nil)
    }
    
    //MARK: - ToolBarDelegate
    func backButtonDidClicked(){
        let model = self.pageInfoModel
        model?.chapter = currentChapter
        model?.pageIndex = currentPage
        model!.updateModel(WithModel: model!)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //目录按钮点击
    func catagoryClicked(){
//        let cateVC = CategoryViewController()
//        cateVC.showCategoryWithViewController(self, chapter: currentChapter,titles:getTitles() as! [String])
        navBar.hideWithAnimations(true)
    }
    
    func toolBarDidShow(){
        isToolBarShow = true
        setNeedsStatusBarAppearanceUpdate()
    }
    
    func toolBarDidHidden(){
        isToolBarShow = false
        setNeedsStatusBarAppearanceUpdate()
    }
    
    private func getTitles()->NSArray{
        let tittles = NSMutableArray()
        if self.pageInfoModel?.chapters?.count > 0 || self.pageInfoModel?.chapters != nil {
            for item in self.pageInfoModel!.chapters! {
                tittles.addObject((item as ChapterModel).title)
            }
        }
        return tittles.copy() as! NSArray
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return !isToolBarShow
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        view.backgroundColor = UIColor.grayColor()
        addChildViewController(pageController)
        view.addSubview(pageController.view)
        view.addSubview(navBar)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        currentPage = (viewController as! PageViewController).pageIndex
        currentPage -= 1
        if currentChapter < 0 {
            return nil
        }
        if currentPage < 0 {
            if currentChapter == 0 {
                return nil
            }
            currentChapter -= 1
            currentPage = (pageInfoModel?.chapters![currentChapter].pageCount)! - 1
        }
        return pageViewWithChapter(currentChapter,page:currentPage)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        currentPage = (viewController as! PageViewController).pageIndex
        currentPage += 1
        if currentPage >= pageInfoModel?.chapters![currentChapter].pageCount {
            currentChapter += 1
            currentPage = 0
        }
        let vvvc = pageViewWithChapter(currentChapter,page: currentPage)
        return vvvc
    }
    
    //网络请求下一章节信息，请求成功后刷新当前页的文本
    func updateChapters(withChapter chapter:Int,page:Int){
        HUD.showProgressHud(true)
        dispatch_async(dispatch_get_main_queue()) {
            let url = "http://chapter2.zhuishushenqi.com/chapter/http://vip.zhuishushenqi.com/chapter/\(self.chapters[self.currentChapter].objectForKey("id")!)?cv=1474263421423?k=19ec78553ec3a169&t=1476188085"
            Alamofire.request(.GET, url, parameters: nil)
                .validate()
                .responseJSON { response in
                    print("request:\(response.request)")  // original URL request
                    print("response:\(response.response)") // URL response
                    print("result:\(response.result.value)")   // result of response serialization
                    switch response.result {
                    case .Success:
                        HUD.hide()
                        print("")
                        let content = (response.result.value as! NSDictionary).objectForKey("chapter")!.objectForKey("cpContent") as! String
                        let model = PageInfoModel()
                        model.bookName = self.bookName
                        model.type = .Online
                        self.pageInfoModel = model.getModelWithContent(content,bookName: self.bookName)
                        self.pageInfoModel?.pageIndex = self.currentPage
                        self.pageInfoModel?.chapter = self.currentChapter
                        self.pageInfoModel?.bookName = self.bookName
                        let chapterModel = self.pageInfoModel?.chapters?[self.currentChapter]
                        let string =  chapterModel?.stringOfPage(self.currentPage)
                        self.nextVC?.totalPage = chapterModel?.pageCount ?? 0
                        self.nextVC?.titleLabel.text = chapterModel?.title
                        self.nextVC?.pageView.attributedText = NSMutableAttributedString(string:string ?? "", attributes: [NSFontAttributeName:UIFont.systemFontOfSize(20)])
                        
                    case .Failure(let error):
                        print(error)
                        
                    }
            }
        }
    }
    
    func pageViewWithChapter(chapter:Int,page:Int)->UIViewController{
        let vc1 = PageViewController()
        nextVC = vc1
        nextVC!.pageIndex = page
        if pageInfoModel?.chapters == nil || pageInfoModel?.chapters?.count < chapter + 1 {
            nextVC!.pageView.attributedText = NSMutableAttributedString(string: "正在加载，请耐心等待")
            nextVC!.totalPage = 0
            updateChapters(withChapter:chapter,page: page)
            return nextVC!
        }else{
            var vc1Attibutestring = NSMutableAttributedString(string: "")
            vc1Attibutestring = NSMutableAttributedString(string: (pageInfoModel?.chapters![chapter].stringOfPage(page)) ?? "", attributes: [NSFontAttributeName:UIFont.systemFontOfSize(20)])
            vc1.pageView.attributedText = vc1Attibutestring
            vc1.totalPage = (pageInfoModel?.chapters![chapter].pageCount)!
            vc1.titleLabel.text = pageInfoModel?.chapters?[chapter].title
            return vc1
        }
    }
    
    deinit{
        print("释放内存")
    }
}

