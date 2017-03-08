//
//  SegMenu.swift
//  zhuishushenqi
//
//  Created by caonongyun on 16/9/17.
//  Copyright © 2016年 CNY. All rights reserved.
//

import UIKit

protocol SegMenuDelegate {
    func didSelectAtIndex(_ index:Int)
}

class SegMenu: UIView {
    
    var menuDelegate:SegMenuDelegate?
    var titles:[String]?

    init(frame:CGRect, WithTitles _titles:NSArray){
        super.init(frame: frame)
        titles = _titles as? [String]
        initSubview(frame,titles: _titles)
    }
    
    fileprivate func initSubview(_ frame:CGRect,titles:NSArray){
        var index:Int = 0
        let ScreenBounds = UIScreen.main.bounds
        let width = ScreenBounds.width/CGFloat(titles.count)
        let height = frame.size.height
        for title in titles {
            let btn = UIButton(type: .custom)
            btn.setTitle(title as? String, for: UIControlState())
            btn.setTitleColor(UIColor.gray, for: UIControlState())
            btn.tag = index
            btn.frame = CGRect(x: width*CGFloat(index), y: 0, width: width, height: height)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            btn.addTarget(self, action: #selector(self.segAction(_:)), for: .touchUpInside)
            addSubview(btn)
            if index > 0 && index <= titles.count - 1 {
                let line = UILabel(frame: CGRect(x: width*CGFloat(index),y: height/3,width: 0.5,height: height/3))
                line.backgroundColor = UIColor.gray
                line.alpha = 0.6
                addSubview(line)
            }
            index += 1
        }
        let bottomView = UIView(frame: CGRect(x: 0,y: frame.size.height - 2,width: width,height: 2))
        bottomView.tag = 12333
        bottomView.backgroundColor = UIColor ( red: 0.7235, green: 0.0, blue: 0.1146, alpha: 1.0 )
        let bottomLine = UILabel(frame: CGRect(x: 0,y: height - 0.5,width: ScreenBounds.width,height: 0.5))
        bottomLine.backgroundColor = UIColor.gray
        addSubview(bottomLine)
        
        addSubview(bottomView)
        
        backgroundColor = UIColor.white
    }
    
    @objc fileprivate func segAction(_ btn:UIButton){
        let bottomView = self.viewWithTag(12333)
        bottomView?.center = CGPoint(x: frame.size.width/CGFloat(titles!.count)/2*CGFloat(btn.tag*2 + 1), y: frame.size.height - 1)
        menuDelegate?.didSelectAtIndex(btn.tag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
