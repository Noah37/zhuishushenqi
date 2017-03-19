//
//  BarButton.swift
//  zhuishushenqi
//
//  Created by caonongyun on 16/9/17.
//  Copyright © 2016年 CNY. All rights reserved.
//

import UIKit

class BarButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.frame = self.bounds
        imageView?.contentMode = .scaleAspectFill
    }
}
