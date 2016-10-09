//
//  XYCContainerViewController.swift
//  ContainerView
//
//  Created by caonongyun on 16/9/19.
//  Copyright © 2016年 CNY. All rights reserved.
//

import UIKit

enum ShowType {
    case Left
    case Right
}

class XYCContainerViewController: UIViewController {

    
    private let ScreenWidth = UIScreen.mainScreen().bounds.size.width
    private let ScreenHeight = UIScreen.mainScreen().bounds.size.height
    private let frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height - 0)
    
    
    var contentViewController:UIViewController = UIViewController()
    
    var rightViewController:UIViewController?
    var leftViewController:UIViewController?
    
    var leftScaleX:CGFloat = 0.5//显示right时，左侧视图占整个窗口宽度的比例
    var rightScaleX:CGFloat = 0.5
    
    var maskView:UIView?
    
    var type:ShowType = .Left
    
    var changeBtn:UIButton{
        let btn = UIButton(type: .Custom)
        btn.setTitle("exchange", forState: .Normal)
        btn .setTitleColor(UIColor.blueColor(), forState: .Normal)
        btn.frame = CGRectMake(UIScreen.mainScreen().bounds.size.width/2 - 50,40, 100, 30)
        btn.addTarget(self, action: #selector(changeAction(_:)), forControlEvents: .TouchUpInside)
        btn.layer.cornerRadius = 5
        btn.layer.borderWidth = 0.2
        return btn
    }
    
    convenience init(_contentViewController:UIViewController,leftViewController:UIViewController,rightViewController:UIViewController){
        self.init()
        contentViewController = _contentViewController
        self.rightViewController = rightViewController
        self.leftViewController = leftViewController
    }
    
    private func getView() ->UIView{
        if type == .Right{
            
            let view = UIView(frame: CGRectMake(0,0,ScreenWidth*(rightScaleX),ScreenHeight))
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.hideRightView(_:)))
            view.addGestureRecognizer(tap)
            return view
        }else{
            let view = UIView(frame: CGRectMake(ScreenWidth*(1-leftScaleX),0,ScreenWidth*leftScaleX,ScreenHeight))
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.hideLefttView(_:)))
            view.addGestureRecognizer(tap)
            return view
        }
    }
    
    @objc private func changeAction(btn:UIButton){
//        if self.childViewControllers[0] == rightViewController {
//            self.transitionFromViewController(rightViewController, toViewController: contentViewController)
//        }else{
//            self.transitionFromViewController(contentViewController, toViewController: rightViewController)
//        }
        showRightViewController()
    }
    
    @objc private func hideRightView(tap:UITapGestureRecognizer){
        self.hideRightViewController()
    }
    
    @objc private func hideLefttView(tap:UITapGestureRecognizer){
        self.hideLeftViewController()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addLeftViewController()
        addRightViewController()
        
        self.addChildViewController(contentViewController)
        contentViewController.view.frame = frame
        self.view.addSubview(contentViewController.view)
        contentViewController.didMoveToParentViewController(self)
    }
    
    private func addLeftViewController(){
        if leftViewController == nil {
            return
        }
        self.addChildViewController(leftViewController!)
        leftViewController!.view.frame = frame
        self.view.addSubview(leftViewController!.view)
        leftViewController!.didMoveToParentViewController(self)
    }
    
    private func addRightViewController(){
        if rightViewController == nil {
            return
        }
        self.addChildViewController(rightViewController!)
        rightViewController!.view.frame = frame
        self.view.addSubview(rightViewController!.view)
        rightViewController!.didMoveToParentViewController(self)
    }
    
    func showLeftViewController(){
        if leftViewController == nil {
            return
        }
        type = .Left
        rightViewController?.view.hidden = true
        UIView.animateWithDuration(0.35, animations: {
            self.contentViewController.view.frame = CGRectMake(UIScreen.mainScreen().bounds.size.width*self.leftScaleX, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height - 0)
        }) { (finished) in
        }
        self.maskView = self.getView()
        self.view.addSubview(self.maskView!)
    }
    
    func hideLeftViewController(){
        if leftViewController == nil {
            return
        }
        UIView.animateWithDuration(0.35, animations: {
            self.contentViewController.view.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height - 0)
        }) { (finished) in
            self.rightViewController?.view.hidden = false
        }
        if self.maskView?.superview != nil {
            self.maskView!.removeFromSuperview()
        }
        self.maskView = nil
    }

    
    func showRightViewController(){
        if rightViewController == nil {
            return
        }
        type = .Right
        UIView.animateWithDuration(0.35, animations: {
            self.contentViewController.view.frame = CGRectMake(-UIScreen.mainScreen().bounds.size.width*(1 - self.rightScaleX), 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height - 0)
            }) { (finished) in
        }
        self.maskView = self.getView()
        self.view.addSubview(self.maskView!)
    }
    
    func hideRightViewController(){
        if rightViewController == nil {
            return
        }
        UIView.animateWithDuration(0.35, animations: {
            self.contentViewController.view.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height - 0)
        }) { (finished) in
        }
        if self.maskView?.superview != nil {
            self.maskView!.removeFromSuperview()
        }
        self.maskView = nil
    }
    
    func fullRightViewController(){
        if rightViewController == nil {
            return
        }
        UIView.animateWithDuration(0.35, animations: {
            self.contentViewController.view.frame = CGRectMake(-self.ScreenWidth, 0, self.ScreenWidth, self.ScreenHeight)
            
        }) { (finished) in
            
        }
//        UIView.animateWithDuration(2, animations: {
//            self.rightViewController!.view.frame = self.view.frame
//        }) { (finished) in
//            
//        }
        if self.maskView?.superview != nil {
            self.maskView!.removeFromSuperview()
        }
        self.maskView = nil
    }
    
    func identityViewController(){
        if rightViewController == nil {
            return
        }
        type = .Right
        
        UIView.animateWithDuration(0.35*Double(rightScaleX/1-rightScaleX), animations: {
            self.contentViewController.view.frame = CGRectMake(-UIScreen.mainScreen().bounds.size.width*(1 - self.rightScaleX), 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height - 0)
        }) { (finished) in
        }
        self.maskView = self.getView()
        self.view.addSubview(self.maskView!)
    }
    
    /**
     from one child viewcontroller to another childviewcontroller
     
     - parameter fromViewController: one childviewcontroller
     - parameter toViewController:   another childviewcontroller
     */
    func transitionFromViewController(fromViewController: UIViewController, toViewController: UIViewController){
        
        fromViewController.willMoveToParentViewController(nil)
        self.addChildViewController(toViewController)
        toViewController.view.frame = frame
        self.view.addSubview(toViewController.view)
        self.transitionFromViewController(fromViewController, toViewController: toViewController, duration: 0.35, options: .TransitionNone, animations: {
            
            }) { (finished) in
                fromViewController.removeFromParentViewController()
                toViewController.didMoveToParentViewController(self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension UIViewController{
    var containerViewController:XYCContainerViewController{
        get{
            var iter = self.parentViewController
            while iter != nil {
                if iter?.isKindOfClass(XYCContainerViewController.self) == true {
                    return iter as! XYCContainerViewController
                }else if iter?.parentViewController != nil && iter?.parentViewController != iter{
                    iter = iter?.parentViewController
                }else{
                    iter = nil
                }
            }
            return iter as! XYCContainerViewController
        }
    }
}
