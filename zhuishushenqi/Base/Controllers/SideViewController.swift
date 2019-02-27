//
//  SideViewController.swift
//  zhuishushenqi
//
//  Created by caonongyun on 16/9/30.
//  Copyright © 2016年 CNY. All rights reserved.
//

import UIKit

private enum HorizonalXSideType{
    case none
    case left
    case right
}


class SideViewController: UIViewController,UIGestureRecognizerDelegate {
    /**
     *  右侧视图控制器相对于容器视图的比例,1.0不进行缩放[暂不支持]
     */
    var rightViewControllerScale:CGFloat = 0.75
    /**
     *  左侧视图控制器相对于容器视图的比例,1.0不进行缩放[暂不支持]
     */
    var leftViewControllerScale:CGFloat = 0.75
    /**
     *  手势滑动时bounces
     */
    var shouldStretchDrawer:Bool = true
    
    var maximumLeftOffsetWidth:CGFloat = 100
    
    var maximumRightOffsetWidth:CGFloat = 200
    /**
     *  侧滑菜单加载时间
     */
    var animateDuration = 0.25
    
    /// 是否右侧边栏处于关闭状态
    var isCloseRightSide:Bool = true
    /// 是否左侧边栏处于关闭状态
    var isCloseLeftSide:Bool = true
    
    var isPanGestureEnable:Bool = true
    
    
    var leftViewController:UIViewController? {
        didSet { setSideViewController(side: .left) }
    }
    var rightViewController:UIViewController? {
        didSet { setSideViewController(side: .right) }
    }
    var contentViewController:UIViewController? {
        didSet { setContentViewController() }
    }
    
    fileprivate var contentView:UIView = UIView()
    fileprivate var containerView:UIView = UIView()
    fileprivate var maskView:UIView = UIView()
    fileprivate var shadowView:UIView = UIView()
    
    fileprivate var startingPanRect:CGRect = CGRect.zero
    
    var drawerOvershootPercentage:CGFloat = 0.1
    
    var drawerOvershootLinearRangePercentage:CGFloat = 0.75
    
    var panVelocityXAnimationThreshold:CGFloat = 200
    
    /// 显示菜单方向
    fileprivate var horizonalXSide:HorizonalXSideType = HorizonalXSideType.none
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
        updateContentViewShadow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateContentViewShadow()
    }
    
    override func willAnimateRotation(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        guard let oldShadowPath = self.shadowView.layer.shadowPath else { return }
        self.shadowView.layer.shadowPath = nil
        updateContentViewShadow()
        
        self.shadowView.layer.add((({
            let transition = CABasicAnimation(keyPath: "shadowPath")
            transition.fromValue = oldShadowPath
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition.duration = duration
            return transition
        })()) ,forKey: "transition")
    }
    
    fileprivate func initSubview(){
        var autoResizingMask = UIView.AutoresizingMask.flexibleWidth
        autoResizingMask = autoResizingMask.union(.flexibleHeight)
        containerView = UIView(frame: self.view.bounds)
        containerView.backgroundColor = UIColor.white
        containerView.autoresizingMask = autoResizingMask
        view.addSubview(containerView)
        
        var contentAutoResizingMask = UIView.AutoresizingMask.flexibleWidth
        contentAutoResizingMask = contentAutoResizingMask.union(.flexibleHeight)
        contentView = UIView(frame: self.view.bounds)
        contentView.backgroundColor = UIColor.white
        containerView.addSubview(contentView)
        contentView.autoresizingMask = contentAutoResizingMask
        contentView.addGestureRecognizer(panGes)
        
        maskView = UIView(frame: self.view.bounds)
        maskView.autoresizingMask = autoResizingMask
        maskView.backgroundColor = UIColor(white: 0.5, alpha: 0.2)
        let ges = UITapGestureRecognizer(target: self, action: #selector(maskAction(_:)))
        maskView.addGestureRecognizer(ges)
        contentView.addSubview(maskView)
        
        shadowView = UIView(frame: self.view.bounds)
        shadowView.isUserInteractionEnabled = true
        shadowView.autoresizingMask = autoResizingMask
        shadowView.backgroundColor = UIColor.clear
        contentView.addSubview(shadowView)
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
    
    private func originXForDrawerOriginAndTargetOriginOffset(originX:CGFloat, targetOffset:CGFloat, maxOvershoot:CGFloat) ->CGFloat {
        let delta = abs(originX - targetOffset)
        let maxLinearPercentage = drawerOvershootLinearRangePercentage
        let nonLinearRange = maxOvershoot * maxLinearPercentage
        let nonLinearScalingDelta = delta - nonLinearRange
        let overshoot = nonLinearRange + nonLinearScalingDelta * nonLinearRange/sqrt(pow(nonLinearScalingDelta, 2.0) + 15000)
        if delta < nonLinearRange {
            return originX
        }
        else if targetOffset < 0 {
            return targetOffset - round(overshoot)
        }
        else {
            return targetOffset + round(overshoot)
        }
    }
    
    private func roundedOriginX(for drawerConstriants:CGFloat) ->CGFloat {
        if drawerConstriants < -self.maximumRightOffsetWidth {
            if self.shouldStretchDrawer && self.rightViewController != nil {
                let maxOvershoot = (self.contentView.frame.width - self.maximumRightOffsetWidth) * drawerOvershootPercentage
                return originXForDrawerOriginAndTargetOriginOffset(originX: drawerConstriants, targetOffset: -self.maximumRightOffsetWidth, maxOvershoot: maxOvershoot)
            } else {
                return -self.maximumRightOffsetWidth
            }
        } else if drawerConstriants > self.maximumRightOffsetWidth {
            if self.shouldStretchDrawer && self.leftViewController != nil {
                let maxOvershoot = (self.contentView.frame.width - self.maximumLeftOffsetWidth) * drawerOvershootPercentage
                return originXForDrawerOriginAndTargetOriginOffset(originX: drawerConstriants, targetOffset: self.maximumLeftOffsetWidth, maxOvershoot: maxOvershoot)
            } else {
                return self.maximumLeftOffsetWidth
            }
        }
        return drawerConstriants
    }
    
    private func childViewControllerForSide(drawerSide:HorizonalXSideType) ->UIViewController {
        var childViewController:UIViewController?
        switch drawerSide {
        case .none:
            childViewController = contentViewController
            break
        case .left:
            childViewController = leftViewController
            break
        case .right:
            childViewController = rightViewController
            break
        }
        return childViewController!
    }
    
    private func sideDrawerViewControllerForSide(drawerSide:HorizonalXSideType) ->UIViewController {
        var sideDrawerViewController:UIViewController?
        if drawerSide != .none {
            sideDrawerViewController = self.childViewControllerForSide(drawerSide: drawerSide)
        }
        return sideDrawerViewController!
    }
    
    @objc
    private func panAction(_ pan:UIPanGestureRecognizer) {
        switch pan.state {
        case .began:
            self.startingPanRect = self.contentView.frame
            break
        case .changed:
            self.view.isUserInteractionEnabled = false
            var newFrame = self.startingPanRect
            let translatedPoint = pan .translation(in: self.contentView)
            newFrame.origin.x = self.roundedOriginX(for: self.startingPanRect.minX + translatedPoint.x)
            newFrame = newFrame.integral
            
            self.contentView.center = CGPoint(x: newFrame.midX, y: newFrame.midY)
            
            newFrame = self.contentView.frame
            newFrame.origin.x = floor(newFrame.origin.x)
            newFrame.origin.y = floor(newFrame.origin.y)
            self.contentView.frame = newFrame
            let xOffset = newFrame.origin.x;
            var visibleSide = HorizonalXSideType.none
            if xOffset > 0 {
                visibleSide = .left
                self.leftViewController?.view.isHidden = false
                self.rightViewController?.view.isHidden = true
            } else {
                visibleSide = .right
                self.leftViewController?.view.isHidden = true
                self.rightViewController?.view.isHidden = false
            }
            if visibleSide != horizonalXSide {
                self.horizonalXSide = visibleSide
            } else if visibleSide == .none {
                self.horizonalXSide = .none
            }
            
            break
        case .ended,.cancelled:
            self.startingPanRect = CGRect.null
            let velocity = pan.velocity(in: self.containerView)
            finishAnimationForPanGestureWithXVelocity(xVelocity: velocity.x) { (finished) in
                
            }
            self.view.isUserInteractionEnabled = true
            break
        default:
            break
        }
    }
    
    private func finishAnimationForPanGestureWithXVelocity(xVelocity:CGFloat, completion:(_ finished:Bool)->Void) {
        var currentOriginX = self.contentView.frame.minX
        //        let animationVelocity = max(abs(xVelocity), self.panVelocityXAnimationThreshold * 2)
        
        if horizonalXSide == .left {
            let midPoint = self.maximumLeftOffsetWidth / 2.0
            if xVelocity > self.panVelocityXAnimationThreshold {
                self.showLeftViewController()
            } else if xVelocity < -self.panVelocityXAnimationThreshold {
                self.closeSideViewController()
            } else if currentOriginX < midPoint {
                self.closeSideViewController()
            } else {
                self.showLeftViewController()
            }
        } else if horizonalXSide == .right {
            currentOriginX = self.contentView.frame.maxX
            let midPoint = self.containerView.bounds.width - self.maximumRightOffsetWidth + self.maximumRightOffsetWidth / 2.0
            if xVelocity > self.panVelocityXAnimationThreshold {
                self.closeSideViewController()
            } else if xVelocity < -self.panVelocityXAnimationThreshold {
                self.showRightViewController()
            } else if currentOriginX > midPoint {
                self.closeSideViewController()
            } else {
                self.showRightViewController()
            }
        }
    }
    
    @objc fileprivate func maskAction(_ tap:UITapGestureRecognizer){
        if !isCloseLeftSide {
            closeSideViewController()
        }else if !isCloseRightSide{
            closeSideViewController()
        }
    }
    
    private func setSideViewController(side:HorizonalXSideType) {
        var autoResizingMask = UIView.AutoresizingMask.init(rawValue: 0)
        autoResizingMask = autoResizingMask.union(UIView.AutoresizingMask.flexibleHeight)
        var viewController:UIViewController!
        if side == .left {
            viewController = leftViewController
            autoResizingMask = autoResizingMask.union(.flexibleRightMargin)
        } else  {
            viewController = rightViewController
            autoResizingMask = autoResizingMask.union(.flexibleLeftMargin)
        }
        addChild(viewController)
        containerView.addSubview(viewController.view)
        containerView.sendSubviewToBack(viewController.view)
        viewController.view.isHidden = true
        
        viewController.didMove(toParent: self)
        viewController.view.autoresizingMask = autoResizingMask
    }
    
    private func setContentViewController() {
        if let viewController = contentViewController {
            let nav  = UINavigationController(rootViewController: viewController)
            addChild(nav)
            nav.view.frame = view.bounds
            nav.view.backgroundColor = UIColor.gray
            self.contentView.addSubview(nav.view)
            var autoResizingMask = UIView.AutoresizingMask.flexibleWidth
            autoResizingMask = autoResizingMask.union(UIView.AutoresizingMask.flexibleHeight)
            nav.view.autoresizingMask = autoResizingMask
            nav.didMove(toParent: self)
        }
    }
    
    /**
     显示左侧滑菜单，若已处于显示状态，调用该方法将关闭左侧滑菜单
     */
    func showLeftViewController(){
        var newFrame = CGRect.zero
        leftViewController?.view.isHidden = false
        rightViewController?.view.isHidden = true
        _ = self.contentView.frame;
        newFrame = self.contentView.frame
        newFrame.origin.x = maximumLeftOffsetWidth
        //        var distance = abs(oldFrame.minX - newFrame.origin.x)
        self.contentView.bringSubviewToFront(self.maskView)
        UIView.animate(withDuration: 0.25, animations: {
            self.contentView.frame = newFrame
            self.maskView.isHidden = false
        }) { (finish) in
            self.isCloseLeftSide = false
            self.horizonalXSide = .left
        }
//        contentView.addSubview(self.maskView)
    }
    /**
     显示右侧滑菜单，若已处于显示状态，调用该方法将关闭右侧滑菜单
     */
    func showRightViewController(){
        var newFrame = CGRect.zero
        leftViewController?.view.isHidden = true
        rightViewController?.view.isHidden = false
        _ = self.contentView.frame;
        newFrame = self.contentView.frame
        newFrame.origin.x = 0 - maximumRightOffsetWidth
        //        var distance = abs(oldFrame.minX - newFrame.origin.x)
        self.contentView.bringSubviewToFront(self.maskView)
        UIView.animate(withDuration: 0.25, animations: {
            self.contentView.frame = newFrame
            self.maskView.isHidden = false
        }) { (finish) in
            self.isCloseRightSide = false
            self.horizonalXSide = .right
        }
//        contentView.addSubview(self.maskView)
    }
    
    /**
     关闭侧滑菜单
     */
    func closeSideViewController(){
        UIView.animate(withDuration: animateDuration, animations: {
            self.contentView.frame = self.containerView.bounds
            self.maskView.isHidden = true
        }, completion: { (finished) in
            self.isCloseLeftSide = true
            self.isCloseRightSide = true
            self.leftViewController?.view.isHidden = false
            self.rightViewController?.view.isHidden = false
        })
    }
    
    fileprivate func updateContentViewShadow(){
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowRadius = 3
        shadowView.layer.shadowOpacity = 1.0
        shadowView.layer.shadowOffset = CGSize.zero
        shadowView.layer.shadowColor = UIColor.black.cgColor
        
        if shadowView.layer.shadowPath == nil {
            shadowView.layer.shadowPath = UIBezierPath(rect: self.contentView.bounds).cgPath
        } else {
            let currentPath = shadowView.layer.shadowPath?.boundingBoxOfPath
            if currentPath?.equalTo(shadowView.bounds) == false {
                shadowView.layer.shadowPath = UIBezierPath(rect: self.contentView.bounds).cgPath
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    static let shared = SideViewController()
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
}
