//
//  SegMenu.swift
//  zhuishushenqi
//
//  Created by caonongyun on 16/9/17.
//  Copyright © 2016年 CNY. All rights reserved.
//

import UIKit

protocol SegMenuDelegate {
    func didSelectAtIndex(index:Int)
}

class SegMenu: UIView {
    
    var menuDelegate:SegMenuDelegate?
    var titles:[String]?

    init(frame:CGRect, WithTitles _titles:NSArray){
        super.init(frame: frame)
        titles = _titles as? [String]
        initSubview(frame,titles: _titles)
    }
    
    private func initSubview(frame:CGRect,titles:NSArray){
        var index:Int = 0
        let ScreenBounds = UIScreen.mainScreen().bounds
        let width = ScreenBounds.width/CGFloat(titles.count)
        let height = frame.size.height
        for title in titles {
            let btn = UIButton(type: .Custom)
            btn.setTitle(title as? String, forState: .Normal)
            btn.setTitleColor(UIColor.grayColor(), forState: .Normal)
            btn.tag = index
            btn.frame = CGRectMake(width*CGFloat(index), 0, width, height)
            btn.titleLabel?.font = UIFont.systemFontOfSize(13)
            btn.addTarget(self, action: #selector(self.segAction(_:)), forControlEvents: .TouchUpInside)
            addSubview(btn)
            if index > 0 && index <= titles.count - 1 {
                let line = UILabel(frame: CGRectMake(width*CGFloat(index),height/3,0.5,height/3))
                line.backgroundColor = UIColor.grayColor()
                line.alpha = 0.6
                addSubview(line)
            }
            index += 1
        }
        let bottomView = UIView(frame: CGRectMake(0,frame.size.height - 2,width,2))
        bottomView.tag = 12333
        bottomView.backgroundColor = UIColor ( red: 0.7235, green: 0.0, blue: 0.1146, alpha: 1.0 )
        let bottomLine = UILabel(frame: CGRectMake(0,height - 0.5,ScreenBounds.width,0.5))
        bottomLine.backgroundColor = UIColor.grayColor()
        addSubview(bottomLine)
        
        addSubview(bottomView)
        
        backgroundColor = UIColor.whiteColor()
    }
    
    @objc private func segAction(btn:UIButton){
        let bottomView = self.viewWithTag(12333)
        bottomView?.center = CGPointMake(frame.size.width/CGFloat(titles!.count)/2*CGFloat(btn.tag*2 + 1), frame.size.height - 1)
        menuDelegate?.didSelectAtIndex(btn.tag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
