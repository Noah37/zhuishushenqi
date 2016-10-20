//
//  ToolBar.swift
//  PageViewController
//
//  Created by caonongyun on 16/10/10.
//  Copyright © 2016年 CNY. All rights reserved.
//

import UIKit

protocol ToolBarDelegate{
    func backButtonDidClicked()
    func catagoryClicked()
    func toolBarDidShow()
    func toolBarDidHidden()
}

class ToolBar: UIView {

    private let TopBarHeight:CGFloat = 64
    private let BottomBarHeight:CGFloat = 49
    var toolBarDelegate:ToolBarDelegate?
    var topBar:UIView?
    var bottomBar:UIView?
    var isShow:Bool = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubview()
    }
    
    private func initSubview(){
        topBar = UIView(frame: CGRectMake(0,-TopBarHeight,UIScreen.mainScreen().bounds.size.width,TopBarHeight))
        topBar?.backgroundColor = UIColor(white: 0.0, alpha: 1.0)
        addSubview(topBar!)
        
        bottomBar = UIView(frame: CGRectMake(0,UIScreen.mainScreen().bounds.size.height,UIScreen.mainScreen().bounds.size.width,49))
        bottomBar?.backgroundColor = UIColor(white: 0.0, alpha: 1.0)
        addSubview(bottomBar!)
        
        let backBtn = UIButton(type: .Custom)
        backBtn.setImage(UIImage(named: "bg_back_white"), forState: .Normal)
        backBtn.addTarget(self, action: #selector(backAction(_:)), forControlEvents: .TouchUpInside)
        backBtn.frame = CGRectMake(10, 27, 30, 30)
        topBar?.addSubview(backBtn)
        
        let btn = UIButton(type: .Custom)
        btn.setImage(UIImage(named: "catelog"), forState: .Normal)
        btn.frame = CGRectMake(self.bounds.size.width/2 - 15, 8, 30, 30)
        btn.addTarget(self, action: #selector(catalogAction(_:)), forControlEvents: .TouchUpInside)
        bottomBar?.addSubview(btn)
        
        let tap = UITapGestureRecognizer(target: self, action:#selector(hideWithAnimations(_:)) )
        addGestureRecognizer(tap)
    }
    
    func showWithAnimations(animation:Bool){
        UIView.animateWithDuration(0.35, animations: {
            self.topBar?.frame = CGRectMake(0, 0, self.bounds.size.width, self.TopBarHeight)
            self.bottomBar?.frame = CGRectMake(0, self.bounds.size.height - self.BottomBarHeight, self.bounds.size.width, self.BottomBarHeight)
        }) { (finished) in
            self.isShow = true
            self.hidden = !self.isShow
        }
        toolBarDelegate?.toolBarDidShow()
    }
    
    func hideWithAnimations(animation:Bool){
        UIView.animateWithDuration(0.35, animations: {
            self.topBar?.frame = CGRectMake(0, -self.TopBarHeight, self.bounds.size.width, self.TopBarHeight)
            self.bottomBar?.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, self.BottomBarHeight)
            }) { (finished) in
               self.isShow = false
                self.hidden = !self.isShow
        }
        toolBarDelegate?.toolBarDidHidden()
    }
    
    @objc private func  backAction(btn:UIButton){
        toolBarDelegate?.backButtonDidClicked()
    }
    
    @objc private func catalogAction(btn:UIButton){
        toolBarDelegate?.catagoryClicked()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
