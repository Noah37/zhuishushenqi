//
//  ZSSearchHeaderView.swift
//  zhuishushenqi
//
//  Created by yung on 2018/7/1.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit
import SnapKit

@objcMembers class ZSSearchHeaderView: UIView {

    fileprivate var tagColor = [UIColor(red: 0.56, green: 0.77, blue: 0.94, alpha: 1.0),
                                UIColor(red: 0.75, green: 0.41, blue: 0.82, alpha: 1.0),
                                UIColor(red: 0.96, green: 0.74, blue: 0.49, alpha: 1.0),
                                UIColor(red: 0.57, green: 0.81, blue: 0.84, alpha: 1.0),
                                UIColor(red: 0.40, green: 0.80, blue: 0.72, alpha: 1.0),
                                UIColor(red: 0.91, green: 0.56, blue: 0.56, alpha: 1.0),
                                UIColor(red: 0.56, green: 0.77, blue: 0.94, alpha: 1.0),
                                UIColor(red: 0.75, green: 0.41, blue: 0.82, alpha: 1.0)]
    
    fileprivate var activity:UIActivityIndicatorView!
    fileprivate lazy var titleLabel:UILabel = {
        let lb = UILabel()
        lb.text = "大家都在搜"
        lb.font = UIFont.systemFont(ofSize: 13)
        lb.textColor = UIColor.black
        return lb
    }()
    
    fileprivate lazy var refreshButton:UIButton = {
        let bt = UIButton(type: .custom)
        bt.setTitle("换一批", for: .normal)
        bt.setTitleColor(UIColor.gray, for: .normal)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        bt.setImage(UIImage(named:"actionbar_refresh"), for: .normal)
        bt.addTarget(self, action: #selector(changeHotWord(btn:)), for: .touchUpInside)
        return bt
    }()
    
    var hotwords:[String] = [] {
        didSet {
            setupSubviews()
        }
    }
    
    var change:Change?
    
    var hotwordClick:HotwordClick?
    
    fileprivate let hotwordsBaseTag = 121
    
    dynamic var totalHeight:CGFloat = 20
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        setupSubviews()
    }
    
    func setupSubviews() {
        titleLabel.removeFromSuperview()
        refreshButton.removeFromSuperview()
        addSubview(titleLabel)
        addSubview(refreshButton)
        
        titleLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(self).offset(16)
            make.width.equalTo(200)
            make.top.equalTo(self).offset(10)
            make.height.equalTo(21)
        }
        
        refreshButton.snp.remakeConstraints { (make) in
            make.right.equalTo(self).offset(-16)
            make.width.equalTo(70)
            make.height.equalTo(21)
            make.top.equalTo(self).offset(10)
        }
        
        // 移除之前的button
        for item in hotwordsBaseTag..<self.subviews.count + hotwordsBaseTag {
            if let btn = self.viewWithTag(item) as? UIButton {
                btn.removeFromSuperview()
            }
        }
        
        
        var x:CGFloat = 20
        var y:CGFloat = 10 + 21 + 10
        let spacex:CGFloat = 10
        let spacey:CGFloat = 10
        let height:CGFloat = 20
        
        for index in 0..<hotwords.count {
            let width = hotwords[index].qs_width(UIFont.systemFont(ofSize: 11), height: 21) + 20
            if x + width + 20 > ScreenWidth {
                x = 20
                y = y + spacey + height
                self.totalHeight = y + height
            }
            let btn = UIButton(type: .custom)
            btn.frame = CGRect(x: x, y: y, width: width, height: height)
            btn.setTitle(hotwords[index], for: UIControl.State())
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 11)
            btn.setTitleColor(UIColor.white, for: UIControl.State())
            btn.backgroundColor = tagColor[index%tagColor.count]
            btn.addTarget(self, action: #selector(hotwordClicked(btn:)), for: .touchUpInside)
            btn.layer.cornerRadius = 2
            btn.tag   = hotwordsBaseTag + index
            addSubview(btn)
            x = x + width + spacex
        }
    }
    
    func animate(){
        activity = UIActivityIndicatorView(style: .gray)
        activity.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        activity.center = self.center
        self.addSubview(activity)
        activity.startAnimating()
    }
    
    func stop(){
        activity.stopAnimating()
        activity.removeFromSuperview()
    }
    
    @objc func hotwordClicked(btn:UIButton){
        if let hotword = hotwordClick {
            hotword(btn.titleLabel?.text ?? "");
        }
    }
    
    @objc func changeHotWord(btn:UIButton){
        if let changeHot = change {
            changeHot()
        }
    }
}
