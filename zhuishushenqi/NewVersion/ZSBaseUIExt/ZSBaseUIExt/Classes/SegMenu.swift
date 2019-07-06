//
//  SegMenu.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 16/9/17.
//  Copyright © 2016年 QS. All rights reserved.
//

import UIKit
import RxSwift
import Then

public protocol SegMenuDelegate {
    func didSelectAtIndex(_ index:Int)
}

open class SegMenu: UIView {
    
    var menuDelegate:SegMenuDelegate?
    var titles:[String] = []
    var selectedIndex = 0
    private let lineTag = 1111
    private let btnBaseTag = 1414
    private var lastSelectedBtn:UIButton!
    private let disposeBag = DisposeBag()
    private let bottomLine = UILabel().then {
        $0.frame = CGRect.zero
        $0.backgroundColor = UIColor.gray
    }

    init(frame:CGRect, WithTitles _titles:[String]){
        super.init(frame: frame)
        titles = _titles
        initSubview(frame,titles: _titles)
    }
    
    fileprivate func layoutAllSubview() {
        let width = self.bounds.width/CGFloat(titles.count)
        let height = self.bounds.height
        for index in 0..<titles.count {
            let btn = self.viewWithTag(index + btnBaseTag)
            btn?.snp.remakeConstraints({ (make) in
                make.left.equalTo(width*CGFloat(index))
                make.top.equalTo(self)
                make.width.equalTo(width)
                make.height.equalTo(height)
            })
            if index > 0 && index <= titles.count - 1 {
                let line = self.viewWithTag(lineTag + index)
                line?.snp.remakeConstraints({ (make) in
                    make.left.equalTo(width*CGFloat(index))
                    make.top.equalTo(height/3)
                    make.width.equalTo(0.5)
                    make.height.equalTo(height/3)
                })
            }
        }
        bottomLine.snp.makeConstraints({ (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(height - 0.5)
            make.height.equalTo(0.5)
        })
    }
    
    fileprivate func initSubview(_ frame:CGRect,titles:[String]){
        var index:Int = 0
        for title in titles {
            let btn = create(title,index + btnBaseTag)
            btn.rx.tap.subscribe(onNext: {
                self.segAction(btn)
            }).disposed(by: disposeBag)
            addSubview(btn)
            
            if index > 0 && index <= titles.count - 1 {
                let line = create(lineTag + index)
                addSubview(line)
            }
            if (index == 0) {
                lastSelectedBtn = btn
                lastSelectedBtn.isSelected = true
                lastSelectedBtn.isUserInteractionEnabled = !(lastSelectedBtn.isSelected)
            }
            index += 1
        }
        addSubview(bottomLine)
        backgroundColor = UIColor.white
    }
    
    @objc fileprivate func segAction(_ btn:UIButton){
        lastSelectedBtn.isSelected = false
        lastSelectedBtn.isUserInteractionEnabled = !(lastSelectedBtn.isSelected)
        btn.isSelected = !btn.isSelected
        btn.isUserInteractionEnabled = false
        lastSelectedBtn = btn
        selectedIndex = btn.tag - btnBaseTag
        menuDelegate?.didSelectAtIndex(selectedIndex)
    }
    
    func selectIndex(_ index:Int) {
        for i in 0..<titles.count {
            if index == i {
                if let btn = self.viewWithTag(index + btnBaseTag) as? UIButton  {
                    segAction(btn)
                }
            }
        }
    }
    
    private func create(_ title:String,_ tag:Int) ->UIButton{
        let btn = UIButton(type: .custom).then {
            $0.setTitle(title, for: .normal)
            $0.setTitleColor(UIColor.gray, for: .normal)
            $0.setBackgroundImage(UIImage(named: "new_nav_normal"), for: .normal)
            $0.setBackgroundImage(UIImage(named: "new_nav_selected"), for: .selected)
            $0.adjustsImageWhenHighlighted = false
            $0.frame = CGRect.zero
            $0.tag = tag
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        }
        return btn
    }
    
    private func create(_ tag:Int) -> UILabel {
        let line = UILabel(frame: CGRect.zero)
        line.tag = tag
        line.backgroundColor = UIColor.gray
        line.alpha = 0.6
        return line
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.layoutAllSubview()
    }

}
