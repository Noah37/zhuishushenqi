//
//  SideViewController.swift
//  zhuishushenqi
//
//  Created by caonongyun on 16/9/30.
//  Copyright © 2016年 CNY. All rights reserved.
//

import UIKit

private enum HorizonalXSideType{
    case Left
    case Right
}

class SideViewController: UIViewController,UIGestureRecognizerDelegate {
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
    var animateDuration = 0.25
    
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
    private var maskView:UIView = UIView()
    
    /// 显示菜单方向
    private var horizonalXSide:HorizonalXSideType?
    /// 弹性空间，可以回弹
    private var bounchesX:CGFloat = 20
    /// 最小open宽度
    private var minimumSwipeX:CGFloat = 20

    private lazy var panGes:UIPanGestureRecognizer =  {
        let pan:UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.panAction(_:)))
        pan.delegate = self
        return pan
    }()
    
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
        contentView.addGestureRecognizer(panGes)
        
        
        
        maskView.frame = self.view.bounds
        maskView.backgroundColor = UIColor(white: 0.5, alpha: 0.2)
        let ges = UITapGestureRecognizer(target: self, action: #selector(maskAction(_:)))
        maskView.addGestureRecognizer(ges)
    }
    
    @objc private func panAction(pan:UIPanGestureRecognizer){
        let translation:CGPoint = pan.translationInView(self.contentView)
        let velocity:CGPoint = pan.velocityInView(self.contentView)

        if pan.state == UIGestureRecognizerState.Began {
            if velocity.x > 0  && isCloseLeftSide{
                horizonalXSide = .Left
            }else if velocity.x < 0 && isCloseRightSide {
                horizonalXSide = .Right
            }
            if !isCloseLeftSide {
                rightView.hidden = true
            }else if !isCloseRightSide {
                rightView.hidden = false
            }
            
            updateContentViewShadow()
        }
        
        if pan.state == UIGestureRecognizerState.Ended {
            //停止时的手势速度方向为哪边则显示哪边
            //这里设置了最小 open 宽度，小于它则不会显示侧边栏
            if self.minimumSwipeX > 0 && (self.contentView.frame.origin.x < 0 && self.contentView.frame.origin.x > -self.minimumSwipeX) ||
                (self.contentView.frame.origin.x > 0 && self.contentView.frame.origin.x < self.minimumSwipeX){
                closeSideViewController()
            }else if self.contentView.frame.origin.x  == 0 {
                closeSideViewController()
            }else{
                if velocity.x > 0 {
                    if contentView.frame.origin.x < 0 {
                        closeSideViewController()
                    }else{
                        isCloseLeftSide = true
                        showLeftViewController()
                    }
                }else{
                    if contentView.frame.origin.x < 20 {
                        isCloseRightSide = true
                        showRightViewController()
                    }else{
                        closeSideViewController()
                    }
                }
            }
        }
        else if pan.state == .Changed{
            let offSetX = translation.x
            /**
             *  显示与隐藏 rightView
             */
            self.contentView.frame.origin.x > 0 ? (self.rightView.hidden = true):(self.rightView.hidden = false)
            /**
             *  滑动主视图时的四种状态，1.左侧显示 2.右侧显示 3.左右都不显示，向右滑动 4.向左滑动
             */
            if !isCloseLeftSide {
                if offSetX > bounchesX {
                    return
                }
                //增加一点缓冲空间
                if offSetX < -leftOffSetXScale*ScreenWidth - bounchesX {
                    return
                }
                //缩放实现
                let scale:CGFloat = leftViewControllerScale + abs(offSetX)/(leftOffSetXScale*ScreenWidth)*(1 - leftViewControllerScale)
                let scaleT = CGAffineTransformMakeScale(scale, scale)
                let transT = CGAffineTransformMakeTranslation(offSetX + leftOffSetXScale*ScreenWidth, 0)
                let conT = CGAffineTransformConcat(transT, scaleT)
                self.contentView.transform = conT

            }else if !isCloseRightSide {
                if offSetX < -bounchesX{
                    return
                }
                if offSetX > rightOffSetXScale*ScreenWidth + bounchesX {
                    return
                }
                pan.setTranslation(CGPointMake(offSetX, translation.y), inView: self.contentView)
                let transT = CGAffineTransformMakeTranslation(offSetX + -rightOffSetXScale*ScreenWidth, 0)
                //目前只考虑了平移的问题，缩放后面慢慢加上
                let scale:CGFloat = rightViewControllerScale + abs(offSetX)/(rightOffSetXScale*ScreenWidth)*(1 - rightViewControllerScale)
                let scaleT = CGAffineTransformMakeScale(scale, scale)
                let conT = CGAffineTransformConcat(transT, scaleT)
                self.contentView.transform = conT

            }else if horizonalXSide == .Left {
                /**
                 *  左右侧边栏都处于关闭状态
                 */
                //缩放实现
                let scale:CGFloat = 1 - abs(offSetX)/(leftOffSetXScale*ScreenWidth)*(1 - leftViewControllerScale)
                let scaleT = CGAffineTransformMakeScale(scale, scale)
                
                if offSetX < -bounchesX {
                    return
                }
                if offSetX > leftOffSetXScale*ScreenWidth + bounchesX {
                    return
                }
                let transT = CGAffineTransformMakeTranslation(offSetX, 0)
                let conT = CGAffineTransformConcat(transT, scaleT)


                self.contentView.transform = conT
            }else if horizonalXSide == .Right {
                //缩放实现
                let scale:CGFloat = 1 - abs(offSetX)/(rightOffSetXScale*ScreenWidth)*(1 - rightViewControllerScale)
                let scaleT = CGAffineTransformMakeScale(scale, scale)
                if offSetX  > bounchesX  {
                    return
                }
                if offSetX <  -rightOffSetXScale*ScreenWidth - bounchesX {
                    return
                }
                let transT = CGAffineTransformMakeTranslation(offSetX, 0)
                let conT = CGAffineTransformConcat(transT, scaleT)

                self.contentView.transform = conT
            }
            
           
        }
    }
    
    //MARK: - UIGestureRecognizerDelegate
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == panGes {
            let pan:UIPanGestureRecognizer = gestureRecognizer as! UIPanGestureRecognizer
            let velocity:CGPoint = pan.velocityInView(self.contentView)
            if pan.velocityInView(self.contentView).x < 3000 && abs(velocity.x)/abs(velocity.y) > 1 {
                return true
            }
            return false
        }
        return true
    }

    
    @objc private func maskAction(tap:UITapGestureRecognizer){
        if !isCloseLeftSide {
            showLeftViewController()
        }else if !isCloseRightSide{
            showRightViewController()
        }
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
    
    /**
     显示左侧滑菜单，若已处于显示状态，调用该方法将关闭左侧滑菜单
     */
    func showLeftViewController(){
        if !isCloseLeftSide {
            closeSideViewController()
            maskView.removeFromSuperview()
            return
        }
        self.contentView.addSubview(maskView)
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
    /**
     显示右侧滑菜单，若已处于显示状态，调用该方法将关闭右侧滑菜单
     */
    func showRightViewController(){
        if !isCloseRightSide {
            closeSideViewController()
            maskView.removeFromSuperview()
            return
        }
        self.contentView.addSubview(maskView)
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
    
    /**
     关闭侧滑菜单
     */
    func closeSideViewController(){
        let orit = CGAffineTransformIdentity
        UIView.animateWithDuration(animateDuration, animations: {
            self.contentView.transform = orit
        }) { (finished) in
            self.isCloseLeftSide = true
            self.isCloseRightSide = true
            self.rightView.hidden = false
            self.maskView.removeFromSuperview()
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
