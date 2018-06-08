//
//  RootNavigationView.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/3/16.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit

class RootNavigationView: UIView {

    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    static func  make(delegate:UIViewController,leftAction:Selector,rightAction:Selector){
        let leftBtn = BarButton(type: .custom)
        leftBtn.addTarget(delegate, action: leftAction, for: .touchUpInside)
        leftBtn.setBackgroundImage(UIImage(named: "nav_home_side_menu"), for: UIControlState())
        leftBtn.setBackgroundImage(UIImage(named: "nav_home_side_menu_selected"), for: .highlighted)
        leftBtn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        let leftBar = UIBarButtonItem(customView: leftBtn)
        let rightBtn = BarButton(type: .custom)
        rightBtn.addTarget(delegate, action: rightAction, for: .touchUpInside)
        rightBtn.setBackgroundImage(UIImage(named: "nav_add_book"), for: UIControlState())
        rightBtn.setBackgroundImage(UIImage(named: "nav_add_book_selected"), for: .highlighted)
        rightBtn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        let rightBar = UIBarButtonItem(customView: rightBtn)
        
        delegate.navigationItem.leftBarButtonItem = leftBar
        delegate.navigationItem.rightBarButtonItem = rightBar
        let titleImg = UIImageView(image: UIImage(named: "zssq_image"))
        delegate.navigationItem.titleView = titleImg
        
        let base64String = UIImage(named:"nav_back_red")?.base64()
        QSLog(base64String)

    }
}
