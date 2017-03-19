//
//  BarButton.swift
//  zhuishushenqi
//
//  Created by Nory Chao on 16/9/17.
//  Copyright © 2016年 QS. All rights reserved.
//

import UIKit

class BarButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.frame = self.bounds
        imageView?.contentMode = .scaleAspectFill
    }
}
