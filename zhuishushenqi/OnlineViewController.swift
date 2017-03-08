//
//  OnlineViewController.swift
//  PageViewController
//
//  Created by caonongyun on 16/10/11.
//  Copyright © 2016年 CNY. All rights reserved.
//

import UIKit
import Alamofire
import QSNetwork

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


class OnlineViewController: UIViewController,UIPageViewControllerDataSource,UIPageViewControllerDelegate,ToolBarDelegate ,CategoryDelegate{
    var currentChapter:Int = 0
    var currentPage:Int = 0
    var chapters:NSArray = []
    var bookName:String = ""
    var nextVC:PageViewController?
    fileprivate var isToolBarShow:Bool = false
    var pageInfoModel:PageInfoModel?
    lazy var pageController:UIPageViewController = {
        let pageController = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)
        pageController.dataSource = self
        pageController.delegate = self
        let model = PageInfoModel()
        model.bookName = self.bookName
        model.type = .online
        self.pageInfoModel = model.getModelWithContent("",bookName: self.bookName)
        self.pageInfoModel?.bookName = self.bookName
        self.currentPage = self.pageInfoModel?.pageIndex ?? 0
        self.currentChapter = self.pageInfoModel?.chapter ?? 0
 
        pageController.setViewControllers([self.pageViewWithChapter(self.pageInfoModel?.chapter ?? 0,page:self.pageInfoModel?.pageIndex ?? 0)], direction: .forward, animated: true, completion: nil)
        return pageController
    }()
    
    lazy var testString:String = {
        let path = Bundle.main.path(forResource: "743.txt", ofType: nil)
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!))
        let encodingGB_18030_2000 = CFStringConvertEncodingToNSStringEncoding(UInt32(CFStringEncodings.GB_18030_2000.rawValue))
        let encodingUTF8 = String.Encoding.utf8
        var testString:String = (NSString(data: data!, encoding: encodingGB_18030_2000) ?? "") as String
        if (testString as NSString).length == 0{
            testString = (NSString(data: data!, encoding: encodingUTF8.rawValue) ?? "") as String
        }
        return testString
    }()
    
    //工具栏，阅读时点击屏幕弹出
    fileprivate lazy var navBar:ToolBar = {
        let navView:ToolBar = ToolBar(frame: CGRect(x: 0,y: 0,width: self.view.bounds.size.width,height: self.view.bounds.size.height))
        navView.isHidden = true
        navView.toolBarDelegate = self
        return navView
    }()
    
    /// 阅读页面，主要显示文本
    fileprivate lazy var pageView:PageView = {
        let pageView = PageView()
        pageView.frame = CGRect(x: 20, y: 30, width: self.view.bounds.size.width - 40, height: self.view.bounds.size.height - 40)
        pageView.backgroundColor = UIColor.white
        return pageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
        view.addGestureRecognizer(tap)
    }
    
    @objc fileprivate func tapAction(_ tap:UITapGestureRecognizer){
        
        navBar.showWithAnimations(true)
    }
    
    //MARK: - 目录中选中的第几章
    func categoryDidSelectAtIndex(_ index:Int){
        let model = pageInfoModel
        model?.chapter = index
        model?.pageIndex = 0
        pageInfoModel = model
        currentPage = model!.pageIndex
        currentChapter = model!.chapter
        pageController.setViewControllers([self.pageViewWithChapter(model!.chapter,page:model!.pageIndex)], direction: .forward, animated: true, completion: nil)
    }
    
    //MARK: - ToolBarDelegate
    func backButtonDidClicked(){
        let model = self.pageInfoModel
        model?.chapter = currentChapter
        model?.pageIndex = currentPage
        model!.updateModel(WithModel: model!)
        dismiss(animated: true, completion: nil)
    }
    
    //目录按钮点击
    func catagoryClicked(){
        let cateVC = CategoryViewController()
        cateVC.showCategoryWithViewController(self, chapter: currentChapter,titles:getTitles() as! [String] as NSArray)
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
    
    fileprivate func getTitles()->NSArray{
        let tittles = NSMutableArray()
        if self.pageInfoModel?.chapters?.count > 0 || self.pageInfoModel?.chapters != nil {
            for item in self.chapters {
                tittles.add((item as! NSDictionary).object(forKey: "title")!)
            }
        }
        return tittles.copy() as! NSArray
    }
    
    
    override var prefersStatusBarHidden : Bool {
        return !isToolBarShow
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.backgroundColor = UIColor.gray
        addChildViewController(pageController)
        view.addSubview(pageController.view)
        view.addSubview(navBar)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
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
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
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
        DispatchQueue.main.async {
            let url = "http://chapter2.zhuishushenqi.com/chapter/http://vip.zhuishushenqi.com/chapter/\((self.chapters[self.currentChapter] as AnyObject).object(forKey: "id")!)?cv=1474263421423?k=a798981749fcbf4d&t=1488797155"
            QSNetwork.setDefaultURL(url: "")
            QSNetwork.request(url, completionHandler: { (response) in
                HUD.hide()
                print("")
                if let data = response.data {
                    do{
                        let dict:NSDictionary? = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
                        let content = (dict?["chapter"] as? NSDictionary)?.object(forKey:"cpContent") as? String ?? ""
                        let model = PageInfoModel()
                        model.bookName = self.bookName
                        model.type = .online
                        self.pageInfoModel = model.getModelWithContent(content,bookName: self.bookName)
                        self.pageInfoModel?.pageIndex = self.currentPage
                        self.pageInfoModel?.chapter = self.currentChapter
                        self.pageInfoModel?.bookName = self.bookName
                        let chapterModel = self.pageInfoModel?.chapters?[self.currentChapter]
                        let string =  chapterModel?.stringOfPage(self.currentPage)
                        self.nextVC?.totalPage = chapterModel?.pageCount ?? 0
                        self.nextVC?.titleLabel.text = chapterModel?.title
                        DispatchQueue.main.async {
                            self.nextVC?.pageView.attributedText = NSMutableAttributedString(string:string ?? "", attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 20)])
                        }
                    }catch{
                        print(error)
                    }
                }
            })
        }
    }
    
    func pageViewWithChapter(_ chapter:Int,page:Int)->UIViewController{
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
            vc1Attibutestring = NSMutableAttributedString(string: (pageInfoModel?.chapters![chapter].stringOfPage(page)) ?? "", attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 20)])
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

