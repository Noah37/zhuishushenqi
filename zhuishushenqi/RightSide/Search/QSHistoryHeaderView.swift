//
//  QSHistoryHeaderView.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2017/4/11.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit

typealias ClearClick = ()->Void

class QSHistoryHeaderView: UIView {

    var clear:ClearClick?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setHeaderView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setHeaderView(){
        let label = UILabel()
        label.frame = CGRect(x: 15, y: 10, width: 200, height: 21)
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.black
        label.text = "搜索历史"
        self.addSubview(label)
        
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named:"search_delete"), for: .normal)
        btn.setTitle("清空", for: .normal)
        btn.setTitleColor(UIColor.darkGray, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.contentHorizontalAlignment = .right
        btn.addTarget(self, action: #selector(clearHistory(btn:)), for: .touchUpInside)
        btn.frame = CGRect(x: self.bounds.width - 90, y: 10, width: 70, height: 21)
        self.addSubview(btn)
    }
    
    @objc func clearHistory(btn:UIButton){
        if let clearClick = clear {
            clearClick()
        }
    }
}
