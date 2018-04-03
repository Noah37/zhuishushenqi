//
//  QSIntroducePage.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2017/6/9.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit

var introduceWindow:UIWindow?

class QSIntroducePage: NSObject {
    
    var completion:Completion?
    private var introduceRootVC:QSIntroduceViewController?
    
    func show(completion:Completion?){
        self.completion = completion
        detachRootViewController()
        let splashWindoww = UIWindow(frame: UIScreen.main.bounds)
        splashWindoww.backgroundColor = UIColor.white
        introduceRootVC = QSIntroduceViewController()
        introduceRootVC?.completion = {
            self.hide()
        }
        splashWindoww.rootViewController = introduceRootVC
        introduceWindow = splashWindoww
        introduceWindow?.makeKeyAndVisible()
    }
    
    func hide(){
        attachRootViewController()
        let mainWindow:UIWindow? = (UIApplication.shared.delegate?.window)!
        mainWindow?.makeKeyAndVisible()
        if let complete = completion {
            complete()
        }
    }
}

extension QSIntroducePage {
    func detachRootViewController(){
        if originalRootViewController == nil {
            let mainWindow:UIWindow? = (UIApplication.shared.delegate?.window)!
            originalRootViewController = mainWindow?.rootViewController
        }
    }
    
    func attachRootViewController(){
        if originalRootViewController != nil {
            let mainWindow:UIWindow? = (UIApplication.shared.delegate?.window)!
            mainWindow?.rootViewController = originalRootViewController
        }
    }
}

typealias QSScrollViewDidScroll = (_ contentOffset:CGPoint)->Void

class QSIntroduceViewController: UIViewController {
    
    var completion:Completion?
    var pageControl:UIPageControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let horizonalVC = QSHorizonalTableViewController(style: .grouped)
        horizonalVC.completion = completion
        horizonalVC.scrollViewDidScroll = { (contentOffset) in
            self.qs_scrollViewDidScroll(contentOffset: contentOffset)
        }
        horizonalVC.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        self.addChildViewController(horizonalVC)
        self.view.addSubview(horizonalVC.view)
        
        pageControl = UIPageControl(frame: CGRect(x: 0, y: self.view.bounds.height - 60, width: self.view.bounds.width, height: 30))
        pageControl.currentPage = 0
        pageControl.numberOfPages = 4
        pageControl.pageIndicatorTintColor = UIColor.white
        pageControl.currentPageIndicatorTintColor = UIColor.darkGray
        view.addSubview(pageControl)
    }
    
    func qs_scrollViewDidScroll(contentOffset:CGPoint){
        var page:Int = Int(contentOffset.y/self.view.bounds.width)
        let residual = contentOffset.y.truncatingRemainder(dividingBy: self.view.bounds.width)
        if  residual > 0 {
            page += 1
        }
        pageControl.isHidden = false
        if page > 3 {
            pageControl.isHidden = true
        }
        
        pageControl.currentPage = page
    }
}

class QSHorizonalTableViewController: UITableViewController {
    var completion:Completion?
    var totalPages:Int = 5
    var scrollViewDidScroll:QSScrollViewDidScroll?

    let backgroundColor:[UIColor] = [UIColor(red: 0.67, green: 0.83, blue: 0.24, alpha: 1.0),
                                     UIColor(red: 0.31, green: 0.75, blue: 1.0, alpha: 1.0),
                                     UIColor(red: 1.0, green: 0.85, blue: 0.16, alpha: 1.0),
                                     UIColor(red: 0.89, green: 0.20, blue: 0.13, alpha: 1.0),
                                     UIColor(red: 0.89, green: 0.20, blue: 0.13, alpha: 1.0)]
    private let imageNames = ["p_anywhere","p_synchronize","p_fast","",""]
    private let titleNames = ["p_anywhere_title","p_synchronize_title","p_fast_title","",""]
    private var scrollEnable:Bool = false
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView = UITableView()
        self.tableView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        self.tableView.isPagingEnabled = true
        self.tableView.bounces = false
        self.tableView.scrollsToTop = false
        self.tableView.showsHorizontalScrollIndicator = false
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.separatorStyle = .none
        self.tableView.qs_registerCellNib(QSIntroduceCell.self)
        self.tableView.qs_registerCellNib(QSLastIntroduceCell.self)
        self.tableView.qs_registerCellNib(QSIntroduceReadCell.self)
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalPages
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 3 {
            let cell:QSLastIntroduceCell? = tableView.qs_dequeueReusableCell(QSLastIntroduceCell.self)
            cell?.contentView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
            cell?.selectionStyle = .none
            cell?.contentView.backgroundColor = backgroundColor[indexPath.row]
            cell?.sinaLogin = {
                
            }

            cell?.qqLoginAction = {
                
            }
            
            cell?.noAccountCompletion = {
                self.scrollEnable = true
                self.tableView.setContentOffset(CGPoint(x: self.tableView.contentOffset.x, y: self.view.bounds.height*CGFloat(self.totalPages-1)), animated: true)
                self.tableView.isScrollEnabled = false
            }
            return cell!
        }else if indexPath.row == 4{
            let cell:QSIntroduceReadCell? = tableView.qs_dequeueReusableCell(QSIntroduceReadCell.self)
            cell?.contentView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
            cell?.selectionStyle = .none
            cell?.contentView.backgroundColor = backgroundColor[indexPath.row]
            cell?.startRead = {
                if let complete = self.completion {
                    complete()
                }
            }
            return cell!
        }
        let cell:QSIntroduceCell? = tableView.qs_dequeueReusableCell(QSIntroduceCell.self)
        cell?.contentView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
        cell?.contentView.backgroundColor = backgroundColor[indexPath.row]
        cell?.selectionStyle = .none
        cell?.headerImageView.image = UIImage(named: imageNames[indexPath.row])
        cell?.titleImageView.image = UIImage(named: titleNames[indexPath.row])
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView.frame.width
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        QSLog("scrollViewDidScroll:\(scrollView.contentOffset)")
        let offsetY = scrollView.contentOffset.y
        if let scroll = scrollViewDidScroll {
            scroll(scrollView.contentOffset)
        }
        if !scrollEnable {
            if offsetY >= self.view.bounds.height*CGFloat(totalPages-2) {
                scrollView.setContentOffset( CGPoint(x: scrollView.contentOffset.x, y: self.view.bounds.height*CGFloat(totalPages-2)), animated: false)
            }
        }
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if !scrollEnable {
            if offsetY >= self.view.bounds.height*CGFloat(totalPages-2) {
                scrollView.setContentOffset( CGPoint(x: scrollView.contentOffset.x, y: self.view.bounds.height*CGFloat(totalPages-2)), animated: false)
            }
        }
    }
    
}
