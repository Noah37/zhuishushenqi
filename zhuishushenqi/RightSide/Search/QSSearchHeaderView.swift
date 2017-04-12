//
//  QSSearchHeaderView.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2017/4/10.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit

typealias Change = ()->Void
typealias HotwordClick = (_ hotword:String)->Void

class QSSearchHeaderView: UIView {
    
    var hotwords:[String] = [] {
        didSet{
            setNeedsLayout()
        }
    }
    
    var change:Change?
    var hotwordClick:HotwordClick?
    
    fileprivate var tagColor = [UIColor(red: 0.56, green: 0.77, blue: 0.94, alpha: 1.0),
                                UIColor(red: 0.75, green: 0.41, blue: 0.82, alpha: 1.0),
                                UIColor(red: 0.96, green: 0.74, blue: 0.49, alpha: 1.0),
                                UIColor(red: 0.57, green: 0.81, blue: 0.84, alpha: 1.0),
                                UIColor(red: 0.40, green: 0.80, blue: 0.72, alpha: 1.0),
                                UIColor(red: 0.91, green: 0.56, blue: 0.56, alpha: 1.0),
                                UIColor(red: 0.56, green: 0.77, blue: 0.94, alpha: 1.0),
                                UIColor(red: 0.75, green: 0.41, blue: 0.82, alpha: 1.0)]
    override init(frame: CGRect) {
        super.init(frame: frame)
        setHeaderView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setHeaderView(){
        self.backgroundColor = UIColor.white
        let label = UILabel()
        label.frame = CGRect(x: 15, y: 0, width: 200, height: 21)
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.black
        label.text = "大家都在搜"
        self.addSubview(label)
        
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named:"actionbar_refresh"), for: .normal)
        btn.setTitle("换一批", for: .normal)
        btn.setTitleColor(UIColor.darkGray, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.contentHorizontalAlignment = .right
        btn.addTarget(self, action: #selector(changeHotWord(btn:)), for: .touchUpInside)
        btn.frame = CGRect(x: self.bounds.width - 90, y: 0, width: 70, height: 21)
        self.addSubview(btn)
    }
    
    @objc func changeHotWord(btn:UIButton){
        if let changeHot = change {
            changeHot()
        }
    }
    
    @objc func hotwordClicked(btn:UIButton){
        if let hotword = hotwordClick {
            hotword(btn.titleLabel?.text ?? "");
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for item in self.subviews {
            if item.isKind(of: UIButton.self) {
                let btn:UIButton? = item as? UIButton
                if btn?.imageView?.image == nil{
                    btn?.removeFromSuperview()
                }
            }
        }
        
        var x:CGFloat = 20
        var y:CGFloat = 10 + 21
        let spacex:CGFloat = 10
        let spacey:CGFloat = 10
        let height:CGFloat = 20
        
        for index in 0..<hotwords.count {
            let width = widthOfString(hotwords[index], font: UIFont.systemFont(ofSize: 11), height: 21) + 20
            if x + width + 20 > ScreenWidth {
                x = 20
                y = y + spacey + height
            }
            let btn = UIButton(type: .custom)
            btn.frame = CGRect(x: x, y: y, width: width, height: height)
            btn.setTitle(hotwords[index], for: UIControlState())
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 11)
            btn.setTitleColor(UIColor.white, for: UIControlState())
            btn.backgroundColor = tagColor[index%tagColor.count]
            btn.addTarget(self, action: #selector(hotwordClicked(btn:)), for: .touchUpInside)
            btn.layer.cornerRadius = 2
            self.addSubview(btn)
            
            x = x + width + spacex
        }
        self.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 121)
    }
}
