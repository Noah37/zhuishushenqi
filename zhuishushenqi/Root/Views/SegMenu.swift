//
//  SegMenu.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 16/9/17.
//  Copyright © 2016年 QS. All rights reserved.
//

import UIKit

protocol SegMenuDelegate {
    func didSelectAtIndex(_ index:Int)
}

class SegMenu: UIView {
    
    var menuDelegate:SegMenuDelegate?
    var titles:[String] = []
    private let lineTag = 1111
    private let bottomViewTag = 1212
    private let bottomLineTag = 1313
    private let btnBaseTag = 1414

    init(frame:CGRect, WithTitles _titles:[String]){
        super.init(frame: frame)
        titles = _titles
        initSubview(frame,titles: _titles)
    }
    
    fileprivate func layoutAllSubview() {
        let ScreenBounds = UIScreen.main.bounds
        let width = ScreenBounds.width/CGFloat(titles.count)
        let height = frame.size.height
        for index in 0..<titles.count {
            let btn = self.viewWithTag(index + btnBaseTag)
            btn?.snp.makeConstraints({ (make) in
                make.left.equalTo(width*CGFloat(index))
                make.top.equalTo(self)
                make.width.equalTo(width)
                make.height.equalTo(height)
            })
            if index > 0 && index <= titles.count - 1 {
                let line = self.viewWithTag(lineTag + index)
                line?.snp.makeConstraints({ (make) in
                    make.left.equalTo(width*CGFloat(index))
                    make.top.equalTo(height/3)
                    make.width.equalTo(0.5)
                    make.height.equalTo(height/3)
                })
            }
        }
        let bottomView = self.viewWithTag(bottomViewTag)
        bottomView?.frame = CGRect(x: 0,y: frame.size.height - 2,width: width,height: 2)
        
        let bottomLine = self.viewWithTag(bottomLineTag)
        bottomLine?.snp.makeConstraints({ (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(height - 0.5)
            make.height.equalTo(0.5)
        })
    }
    
    fileprivate func initSubview(_ frame:CGRect,titles:[String]){
        var index:Int = 0
        for title in titles {
            let btn = UIButton(type: .custom)
            btn.setTitle(title, for: UIControlState())
            btn.setTitleColor(UIColor.gray, for: UIControlState())
            btn.tag = index + btnBaseTag
            btn.frame = CGRect.zero
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            btn.addTarget(self, action: #selector(self.segAction(_:)), for: .touchUpInside)
            addSubview(btn)
            if index > 0 && index <= titles.count - 1 {
                let line = UILabel(frame: CGRect.zero)
                line.tag = lineTag + index
                line.backgroundColor = UIColor.gray
                line.alpha = 0.6
                addSubview(line)
            }
            index += 1
        }
        let bottomView = UIView(frame: CGRect.zero)
        bottomView.tag = bottomViewTag
        bottomView.backgroundColor = UIColor ( red: 0.7235, green: 0.0, blue: 0.1146, alpha: 1.0 )
        let bottomLine = UILabel(frame: CGRect.zero)
        bottomLine.backgroundColor = UIColor.gray
        bottomLine.tag = bottomLineTag
        addSubview(bottomLine)
        
        addSubview(bottomView)
        
        backgroundColor = UIColor.white
    }
    
    @objc fileprivate func segAction(_ btn:UIButton){
        self.select(at: btn.tag)
    }
    
    func select(at index:Int){
        let selectedIndex = index - btnBaseTag
        let bottomView = self.viewWithTag(bottomViewTag)
        bottomView?.center = CGPoint(x: frame.size.width/CGFloat(titles.count)/2*CGFloat(selectedIndex*2 + 1), y: frame.size.height - 1)
        menuDelegate?.didSelectAtIndex(selectedIndex)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutAllSubview()
    }

}
