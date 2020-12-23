//
//  ZSSearchViewCell.swift
//  zhuishushenqi
//
//  Created by yung on 2018/6/28.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit

class ZSSearchViewCell: UITableViewCell {
    
    fileprivate var tagColor = [UIColor(red: 0.56, green: 0.77, blue: 0.94, alpha: 1.0),
                                UIColor(red: 0.75, green: 0.41, blue: 0.82, alpha: 1.0),
                                UIColor(red: 0.96, green: 0.74, blue: 0.49, alpha: 1.0),
                                UIColor(red: 0.57, green: 0.81, blue: 0.84, alpha: 1.0),
                                UIColor(red: 0.40, green: 0.80, blue: 0.72, alpha: 1.0),
                                UIColor(red: 0.91, green: 0.56, blue: 0.56, alpha: 1.0),
                                UIColor(red: 0.56, green: 0.77, blue: 0.94, alpha: 1.0),
                                UIColor(red: 0.75, green: 0.41, blue: 0.82, alpha: 1.0)]
    
    var activity:UIActivityIndicatorView!
    
    var hotwords:[String] = [] {
        didSet {
            setupSubviews()
        }
    }
    
    var change:Change?
    
    var hotwordClick:HotwordClick?
    
    let hotwordsBaseTag = 121
    
    var totalHeight:CGFloat = 20


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupSubviews()
    }
    
    func setupSubviews() {
        var x:CGFloat = 20
        var y:CGFloat = 10 + 21
        let spacex:CGFloat = 10
        let spacey:CGFloat = 10
        let height:CGFloat = 20
        
        for index in 0..<hotwords.count {
            let width = hotwords[index].qs_width(UIFont.systemFont(ofSize: 11), height: 21) + 20
            if x + width + 20 > ScreenWidth {
                x = 20
                y = y + spacey + height
                totalHeight = totalHeight + height
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
            contentView.addSubview(btn)
            
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
