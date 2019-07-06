//
//  RateView.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/3/14.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit

class RateView: UIView {

    //rate 0-5
    var rate:Int = 0 {
        didSet{
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    private var darkView:DarkView?
    private var lightView:LightView?

    init(frame: CGRect,darkImage:UIImage?,lightImage:UIImage?) {
        super.init(frame: frame)
        darkView = DarkView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height), image: darkImage)
        lightView = LightView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height), image: lightImage)
        addSubview(darkView!)
        addSubview(lightView!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        darkView?.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        
        let width:CGFloat =  (self.bounds.height + 2) * CGFloat(rate)
        lightView?.frame = CGRect(x: 0, y: 0, width: width + 1, height: self.bounds.height)
    }

}
