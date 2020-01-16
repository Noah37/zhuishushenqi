//
//  ZSShelfOperatingView.swift
//  zhuishushenqi
//
//  Created by caony on 2020/1/16.
//  Copyright © 2020 QS. All rights reserved.
//

import UIKit

class ZSShelfOperatingView: UIView {

    lazy var bookIconView:UIImageView = {
        let view = UIImageView(frame: .zero)
        return view
    }()
    
    lazy var bookNameLB:UILabel = {
        let lb = UILabel(frame: .zero)
        lb.textColor = UIColor(red:0.51, green:0.33, blue:0.32, alpha:1.00)
        lb.font = UIFont.systemFont(ofSize: 13)
        lb.textAlignment = .center
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(inView:UIView,_ animated:Bool = true) {
        
    }
    
}
