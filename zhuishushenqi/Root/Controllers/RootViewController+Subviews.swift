//
//  RootViewController-Subviews.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/3/19.
//  Copyright © 2017年 QS. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

let kTootSegmentViewHeight:CGFloat = 40

extension RootViewController{
    func setupSubviews(){
        RootNavigationView.make(delegate: self,leftAction: #selector(leftAction(_:)),rightAction: #selector(rightAction(_:)))
        self.automaticallyAdjustsScrollViewInsets = false
        self.setupSegMenu()
        self.setupBookSheldLB()
        self.setupHeaderView()
        self.setupTableView()
        self.setupCommunityView()
        self.layoutAllViews()
    }
    
    fileprivate func setupSegMenu(){
        segMenu = SegMenu(frame: CGRect.zero, WithTitles: ["追书架","追书社区"])
        segMenu.menuDelegate = self
        self.view.addSubview(segMenu)
    }
    
    fileprivate func layoutAllViews(){
        segMenu.snp.makeConstraints { (make) in
            make.top.equalTo(kNavgationBarHeight)
            make.left.right.equalTo(self.view)
            make.height.equalTo(kTootSegmentViewHeight)
        }
        
        communityView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.top.equalTo(segMenu.snp.bottom)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.top.equalTo(segMenu.snp.bottom)
        }
    }
    
    fileprivate func setupCommunityView() -> Void {
        communityView = CommunityView()
        
        communityView.frame = CGRect(x: 0, y: kNavgationBarHeight + 40, width: ScreenWidth, height: ScreenHeight - 104)
        communityView.delegate = self
        communityView.isHidden = true
        self.view.addSubview(communityView)
    }
    
    fileprivate func setupBookSheldLB(){
        bookShelfLB = UILabel()
        bookShelfLB.frame = CGRect(x: 5,y: 0,width: ScreenWidth - 10,height: 44)
        bookShelfLB.textColor = UIColor.gray
        bookShelfLB.font = UIFont.systemFont(ofSize: 13)
        bookShelfLB.textAlignment = .center
    }
    
    fileprivate func setupTableView(){
        self.tableView.frame = CGRect(x: 0, y: kNavgationBarHeight + 40, width: ScreenWidth, height: ScreenHeight - kNavgationBarHeight - 40)
        self.view.addSubview(self.tableView)
    }
    
    fileprivate func setupHeaderView(){
    
        headerView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: kHeaderViewHeight)
        headerView.backgroundColor = UIColor ( red: 1.0, green: 1.0, blue: 1.0, alpha: 0.7 )
        headerView.layer.masksToBounds = true
//        let signIn = UIButton(type: .custom)
//        signIn.setBackgroundImage(UIImage(named: "sign_bg"), for: UIControlState())
//        signIn.setBackgroundImage(UIImage(named: "sign_bg"), for: .highlighted)
//        signIn.frame = CGRect(x: -3, y: 0, width: ScreenWidth + 6, height: kHeaderViewHeight)
//        
//        let sign_gotoSign = UIButton(type: .custom)
//        sign_gotoSign.setBackgroundImage(UIImage(named: "sign_gotoSign"), for: UIControlState())
//        sign_gotoSign.setBackgroundImage(UIImage(named: "sign_gotoSign"), for: .highlighted)
//        sign_gotoSign.frame = CGRect(x: ScreenWidth - 100 - 10, y: 17, width: 100, height: 37)
//        signIn.addSubview(sign_gotoSign)
//        headerView.addSubview(signIn)
//        let signIn = UIButton(type: .custom)
//        signIn.setBackgroundImage(UIImage(named: "sign_bg"), for: UIControlState())
//        signIn.setBackgroundImage(UIImage(named: "sign_bg"), for: .highlighted)
//        signIn.frame = CGRect(x: -3, y: 0, width: ScreenWidth + 6, height: kHeaderViewHeight)
//        
//        let sign_gotoSign = UIButton(type: .custom)
//        sign_gotoSign.setBackgroundImage(UIImage(named: "sign_gotoSign"), for: UIControlState())
//        sign_gotoSign.setBackgroundImage(UIImage(named: "sign_gotoSign"), for: .highlighted)
//        sign_gotoSign.frame = CGRect(x: ScreenWidth - 100 - 10, y: 17, width: 100, height: 37)
//        signIn.addSubview(sign_gotoSign)
//        headerView.addSubview(signIn)
        
//        if bookShelfLB.text == nil || bookShelfLB.text == ""{
//            signIn.frame = CGRect(x: -3, y: 0, width: ScreenWidth + 6, height: 72)
//            sign_gotoSign.frame = CGRect(x: ScreenWidth - 100 - 10, y: 17, width: 100, height: 37)
//        }
        headerView.addSubview(bookShelfLB)
    }
    
    
    
}
