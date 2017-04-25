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
            let width =  1 + 10*rate + 2*(rate - 1)
            lightView?.frame = CGRect(x: 0, y: 0, width: width, height: Int(self.bounds.height))
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

}
