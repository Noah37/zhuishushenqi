//
//  QSBookDetailRateView.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/4/13.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit

class QSBookDetailRateView: UIView {
    
    var rate:[String]?{
        didSet{
            setRate()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews(){
        self.backgroundColor = UIColor.white
        let text = ["追书人数","读者留存率","更新字数/天"]
        let x:CGFloat = 0
        let y:CGFloat = 20
        let width = ScreenWidth/3
        let height:CGFloat = 21.0
        for index in 0..<3 {
            let label = UILabel(frame: CGRect(x: x + width*CGFloat(index),y: y,width: width,height: height))
            label.text = text[index]
            label.textAlignment = .center
            label.textColor = UIColor.gray
            label.font = UIFont.systemFont(ofSize: 13)
            self.addSubview(label)
            
            let slabel = UILabel(frame: CGRect(x: x + width*CGFloat(index),y: y + 21,width: width,height: height))
            slabel.textAlignment = .center
            slabel.textColor = UIColor.gray
            slabel.tag = 123 + index
            slabel.font = UIFont.systemFont(ofSize: 13)
            self.addSubview(slabel)
        }
    }
    
    func setRate(){
        for index in 0..<(rate?.count ?? 0) {
            let label:UILabel? = self.viewWithTag(123 + index) as? UILabel
            label?.text = rate?[index]
        }
    }

}
