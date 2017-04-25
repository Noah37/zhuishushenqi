//
//  CategoryButton.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/4/17.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit

class CategoryButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView?.frame = CGRect(x: 0, y: 0, width: 30, height: 20)
        self.imageView?.contentMode = .scaleAspectFill
        self.titleLabel?.frame = CGRect(x: 0, y: 24, width: 30, height: 10)
        self.titleLabel?.textAlignment = .center
    }

}
