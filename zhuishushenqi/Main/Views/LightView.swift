//
//  LightView.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2017/3/9.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit

class LightView: UIView {

    init(frame: CGRect,image:UIImage?) {
        super.init(frame: frame)
        self.layer.masksToBounds = true
        makeLightView(image: image)
    }
    
    func makeLightView(image:UIImage?){
        for index in 0..<5 {
            let width = self.bounds.width/5 - 10/5
            let height = self.bounds.height
            let lightStarView = LightStarView(frame: CGRect(x: CGFloat(1) + CGFloat(index)*width + CGFloat(2*index), y: 0, width: width, height: height), image: image)
            addSubview(lightStarView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
