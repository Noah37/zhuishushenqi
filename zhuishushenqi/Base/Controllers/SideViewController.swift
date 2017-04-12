//
//  SideViewController.swift
//  zhuishushenqi
//
//  Created by Nory Chao on 16/9/30.
//  Copyright © 2016年 QS. All rights reserved.
//

import UIKit

private enum HorizonalXSideType{
    case left
    case right
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
    
    fileprivate var contentView:UIView = UIView()
    fileprivate var rightView:UIView = UIView()
    fileprivate var leftView:UIView = UIView()
    fileprivate var maskView:UIView = UIView()
    
    /// 显示菜单方向
    fileprivate var horizonalXSide:HorizonalXSideType?
    /// 弹性空间，可以回弹
    fileprivate var bounchesX:CGFloat = 20
    /// 最小open宽度
    fileprivate var minimumSwipeX:CGFloat = 20

    fileprivate lazy var panGes:UIPanGestureRecognizer =  {
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
    
    fileprivate func initSubview(){
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        leftView = UIView(frame: self.view.bounds)
        leftView.backgroundColor = UIColor.blue
        view.addSubview(leftView)

        
        rightView = UIView(frame: self.view.bounds)
        rightView.backgroundColor = UIColor.red
        view.addSubview(rightView)
        
        contentView = UIView(frame: self.view.bounds)
        contentView.backgroundColor = UIColor.orange
        view.addSubview(contentView)
        contentView.addGestureRecognizer(panGes)
        
        
        
        maskView.frame = self.view.bounds
        maskView.backgroundColor = UIColor(white: 0.5, alpha: 0.2)
        let ges = UITapGestureRecognizer(target: self, action: #selector(maskAction(_:)))
        maskView.addGestureRecognizer(ges)
    }
    
    @objc fileprivate func panAction(_ pan:UIPanGestureRecognizer){
        let translation:CGPoint = pan.translation(in: self.contentView)
        let velocity:CGPoint = pan.velocity(in: self.contentView)

        if pan.state == UIGestureRecognizerState.began {
            if velocity.x > 0  && isCloseLeftSide{
                horizonalXSide = .left
            }else if velocity.x < 0 && isCloseRightSide {
                horizonalXSide = .right
            }
            if !isCloseLeftSide {
                rightView.isHidden = true
            }else if !isCloseRightSide {
                rightView.isHidden = false
            }
            
            updateContentViewShadow()
        }
        
        if pan.state == UIGestureRecognizerState.ended {
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
        else if pan.state == .changed{
            let offSetX = translation.x
            /**
             *  显示与隐藏 rightView
             */
            self.contentView.frame.origin.x > 0 ? (self.rightView.isHidden = true):(self.rightView.isHidden = false)
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
                let scaleT = CGAffineTransform(scaleX: scale, y: scale)
                let transT = CGAffineTransform(translationX: offSetX + leftOffSetXScale*ScreenWidth, y: 0)
                let conT = transT.concatenating(scaleT)
                self.contentView.transform = conT

            }else if !isCloseRightSide {
                if offSetX < -bounchesX{
                    return
                }
                if offSetX > rightOffSetXScale*ScreenWidth + bounchesX {
                    return
                }
                pan.setTranslation(CGPoint(x: offSetX, y: translation.y), in: self.contentView)
                let transT = CGAffineTransform(translationX: offSetX + -rightOffSetXScale*ScreenWidth, y: 0)
                //目前只考虑了平移的问题，缩放后面慢慢加上
                let scale:CGFloat = rightViewControllerScale + abs(offSetX)/(rightOffSetXScale*ScreenWidth)*(1 - rightViewControllerScale)
                let scaleT = CGAffineTransform(scaleX: scale, y: scale)
                let conT = transT.concatenating(scaleT)
                self.contentView.transform = conT

            }else if horizonalXSide == .left {
                /**
                 *  左右侧边栏都处于关闭状态
                 */
                //缩放实现
                let scale:CGFloat = 1 - abs(offSetX)/(leftOffSetXScale*ScreenWidth)*(1 - leftViewControllerScale)
                let scaleT = CGAffineTransform(scaleX: scale, y: scale)
                
                if offSetX < -bounchesX {
                    return
                }
                if offSetX > leftOffSetXScale*ScreenWidth + bounchesX {
                    return
                }
                let transT = CGAffineTransform(translationX: offSetX, y: 0)
                let conT = transT.concatenating(scaleT)


                self.contentView.transform = conT
            }else if horizonalXSide == .right {
                //缩放实现
                let scale:CGFloat = 1 - abs(offSetX)/(rightOffSetXScale*ScreenWidth)*(1 - rightViewControllerScale)
                let scaleT = CGAffineTransform(scaleX: scale, y: scale)
                if offSetX  > bounchesX  {
                    return
                }
                if offSetX <  -rightOffSetXScale*ScreenWidth - bounchesX {
                    return
                }
                let transT = CGAffineTransform(translationX: offSetX, y: 0)
                let conT = transT.concatenating(scaleT)

                self.contentView.transform = conT
            }
            
           
        }
    }
    
    //MARK: - UIGestureRecognizerDelegate
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == panGes {
            let pan:UIPanGestureRecognizer = gestureRecognizer as! UIPanGestureRecognizer
            let velocity:CGPoint = pan.velocity(in: self.contentView)
            if pan.velocity(in: self.contentView).x < 3000 && abs(velocity.x)/abs(velocity.y) > 1 {
                return true
            }
            return false
        }
        return true
    }

    
    @objc fileprivate func maskAction(_ tap:UITapGestureRecognizer){
        if !isCloseLeftSide {
            showLeftViewController()
        }else if !isCloseRightSide{
            showRightViewController()
        }
    }
    
    fileprivate func addChildController(){
        if leftViewController != nil {
            addChildViewController(leftViewController!)
            leftViewController?.view.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
            leftView.addSubview(leftViewController!.view)
        }
        if rightViewController != nil {
            addChildViewController(rightViewController!)
            rightViewController?.view.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
            rightView.addSubview(rightViewController!.view)
        }
        if contentViewController != nil {
            let nav  = UINavigationController(rootViewController: contentViewController!)
            addChildViewController(nav)
            nav.view.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
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
        rightView.isHidden = true
        let transT = CGAffineTransform(translationX: leftOffSetXScale*ScreenWidth, y: 0)
        let scaleT = CGAffineTransform(scaleX: leftViewControllerScale, y: leftViewControllerScale)
        let conT = transT.concatenating(scaleT)
        UIView.animate(withDuration: animateDuration, animations: {
            self.contentView.transform = conT
        }, completion: { (isfinished) in
            self.isCloseLeftSide = false
        }) 
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
        let transT = CGAffineTransform(translationX: -rightOffSetXScale*ScreenWidth, y: 0)
        let scaleT = CGAffineTransform(scaleX: rightViewControllerScale, y: rightViewControllerScale)
        let conT = transT.concatenating(scaleT)
        UIView.animate(withDuration: animateDuration, animations: { 
                self.contentView.transform = conT
            }, completion: { (isfinished) in
              self.isCloseRightSide = false
                self.updateContentViewShadow()
        }) 
    }
    
    /**
     关闭侧滑菜单
     */
    func closeSideViewController(){
        let orit = CGAffineTransform.identity
        UIView.animate(withDuration: animateDuration, animations: {
            self.contentView.transform = orit
        }, completion: { (finished) in
            self.isCloseLeftSide = true
            self.isCloseRightSide = true
            self.rightView.isHidden = false
            self.maskView.removeFromSuperview()
        }) 
    }
    
    fileprivate func updateContentViewShadow(){
        let layer = self.contentView.layer
        let path = UIBezierPath(rect: layer.bounds)
        layer.shadowPath = path.cgPath
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize.zero
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 3
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    static let shared = SideViewController()

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
}
