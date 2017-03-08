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
        topBar = UIView(frame: CGRect(x: 0, y: -TopBarHeight, width: UIScreen.main.bounds.size.width, height: TopBarHeight))
        topBar?.backgroundColor = UIColor(white: 0.0, alpha: 1.0)
        addSubview(topBar!)
        
        bottomBar = UIView(frame: CGRect(x:0,y:UIScreen.main.bounds.size.height,width:UIScreen.main.bounds.size.width,height:49))
        bottomBar?.backgroundColor = UIColor(white: 0.0, alpha: 1.0)
        addSubview(bottomBar!)
        
        let backBtn = UIButton(type: .custom)
        backBtn.setImage(UIImage(named: "bg_back_white"), for: .normal)
        backBtn.addTarget(self, action: #selector(backAction(btn:)), for: .touchUpInside)
        backBtn.frame = CGRect(x:10, y:27,width: 30,height: 30)
        topBar?.addSubview(backBtn)
        
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "catelog"), for: .normal)
        btn.frame = CGRect(x:self.bounds.size.width/2 - 15,y: 8,width: 30,height: 30)
        btn.addTarget(self, action: #selector(catalogAction(btn:)), for: .touchUpInside)
        bottomBar?.addSubview(btn)
        
        let tap = UITapGestureRecognizer(target: self, action:#selector(hideWithAnimations(animation:)) )
        addGestureRecognizer(tap)
    }
    
    func showWithAnimations(animation:Bool){
        let keyWindow = UIApplication.shared.keyWindow
        keyWindow?.addSubview(self)
        UIView.animate(withDuration: 0.35, animations: {
            self.topBar?.frame = CGRect(x:0, y:0,width: self.bounds.size.width,height: self.TopBarHeight)
            self.bottomBar?.frame = CGRect(x:0,y: self.bounds.size.height - self.BottomBarHeight,width: self.bounds.size.width,height: self.BottomBarHeight)
        }) { (finished) in
        
        }
        toolBarDelegate?.toolBarDidShow()
    }
    
    func hideWithAnimations(animation:Bool){
        UIView.animate(withDuration: 0.35, animations: {
            self.topBar?.frame = CGRect(x:0,y: -self.TopBarHeight,width: self.bounds.size.width,height: self.TopBarHeight)
            self.bottomBar?.frame = CGRect(x:0, y:self.bounds.size.height, width:self.bounds.size.width, height:self.BottomBarHeight)
            }) { (finished) in
                self.removeFromSuperview()
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
