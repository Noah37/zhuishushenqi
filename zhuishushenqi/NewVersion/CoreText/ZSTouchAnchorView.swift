//
//  ZSTouchAnchorView.swift
//  CoreTextDemo
//
//  Created by caony on 2019/7/14.
//  Copyright © 2019 cj. All rights reserved.
//

import UIKit

class ZSTouchAnchorView: UIView {
    
    lazy var dotView:UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor(red:0.92, green:0.25, blue:0.29, alpha:1.00)
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var lineView:UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor(red:0.92, green:0.25, blue:0.29, alpha:1.00)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(dotView)
        addSubview(lineView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dotView.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        lineView.frame = CGRect(x: bounds.width/2 - 1, y: 9, width: 2, height: bounds.height - 9)
    }
}
