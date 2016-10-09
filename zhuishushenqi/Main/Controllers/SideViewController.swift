//
//  SideViewController.swift
//  zhuishushenqi
//
//  Created by caonongyun on 16/9/30.
//  Copyright © 2016年 CNY. All rights reserved.
//

import UIKit

class SideViewController: UIViewController {
    /**
     *  右侧视图控制器相对于容器视图的比例,1.0不进行缩放
     */
    var rightViewControllerScale:CGFloat = 1.0
    /**
     *  左侧视图控制器相对于容器视图的比例,1.0不进行缩放
     */
    var leftViewControllerScale:CGFloat = 1.0
    /**
     *  右侧视图控制器相对于容器视图的 x 方向的偏移量比例，1.0则为完全偏移
     */
    var rightOffSetXScale:CGFloat = 0.8
    
    /**
     *  左侧视图控制器相对于容器视图的 x 方向的偏移量比例，1.0则为完全偏移
     */
    var leftOffSetXScale:CGFloat = 0.2
    /**
     *  侧滑菜单加载时间
     */
    var animateDuration = 0.35
    
    /// 是否右侧边栏处于关闭状态
    var isCloseRightSide:Bool = true
    /// 是否左侧边栏处于关闭状态
    var isCloseLeftSide:Bool = true
    

    var leftViewController:UIViewController?
    var rightViewController:UIViewController?
    var contentViewController:UIViewController?
    
    private var contentView:UIView = UIView()
    private var rightView:UIView = UIView()
    private var leftView:UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubview()
        addChildController()
        updateContentViewShadow()

    }
    
    private func initSubview(){
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        leftView = UIView(frame: self.view.bounds)
        leftView.backgroundColor = UIColor.blueColor()
        view.addSubview(leftView)

        
        rightView = UIView(frame: self.view.bounds)
        rightView.backgroundColor = UIColor.redColor()
        view.addSubview(rightView)
        
        contentView = UIView(frame: self.view.bounds)
        contentView.backgroundColor = UIColor.orangeColor()
        view.addSubview(contentView)
        
    }
    
    private func addChildController(){
        if leftViewController != nil {
            addChildViewController(leftViewController!)
            leftViewController?.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight)
            leftView.addSubview(leftViewController!.view)
        }
        if rightViewController != nil {
            addChildViewController(rightViewController!)
            rightViewController?.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight)
            rightView.addSubview(rightViewController!.view)
        }
        if contentViewController != nil {
            let nav  = UINavigationController(rootViewController: contentViewController!)
            addChildViewController(nav)
            nav.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight)
            contentView.addSubview(nav.view)
        }
    }
    
    func showLeftViewController(){
        if !isCloseLeftSide {
            closeLeftViewController()
            return
        }
        rightView.hidden = true
        let transT = CGAffineTransformMakeTranslation(leftOffSetXScale*ScreenWidth, 0)
        let scaleT = CGAffineTransformMakeScale(leftViewControllerScale, leftViewControllerScale)
        let conT = CGAffineTransformConcat(transT, scaleT)
        UIView.animateWithDuration(animateDuration, animations: {
            self.contentView.transform = conT
        }) { (isfinished) in
            self.isCloseLeftSide = false
        }
    }
    
    func closeLeftViewController(){
        let orit = CGAffineTransformIdentity
        UIView.animateWithDuration(animateDuration, animations: {
            self.contentView.transform = orit
        }) { (finished) in
            self.isCloseLeftSide = true
            self.rightView.hidden = false
        }
    }
    
    func showRightViewController(){
        if !isCloseRightSide {
            closeRightViewController()
            return
        }
        let transT = CGAffineTransformMakeTranslation(-rightOffSetXScale*ScreenWidth, 0)
        let scaleT = CGAffineTransformMakeScale(rightViewControllerScale, rightViewControllerScale)
        let conT = CGAffineTransformConcat(transT, scaleT)
        UIView.animateWithDuration(animateDuration, animations: { 
                self.contentView.transform = conT
            }) { (isfinished) in
              self.isCloseRightSide = false
                self.updateContentViewShadow()
        }
    }
    
    func closeRightViewController(){
        let orit = CGAffineTransformIdentity
        UIView.animateWithDuration(animateDuration, animations: { 
                self.contentView.transform = orit
            }) { (finished) in
              self.isCloseRightSide = true
        }
    }
    
    private func updateContentViewShadow(){
        let layer = self.contentView.layer
        let path = UIBezierPath(rect: layer.bounds)
        layer.shadowPath = path.CGPath
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSizeZero
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 3
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    static let sharedInstance = SideViewController()

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
}
