//
//  ZSReaderTouchArea.swift
//  zhuishushenqi
//
//  Created by caony on 2020/1/9.
//  Copyright © 2020 QS. All rights reserved.
//

import UIKit

class ZSReaderTouchArea: UIView {
    
    private lazy var backgroundView:UIView = {
        let view = UIView(frame: self.bounds)
        view.backgroundColor = UIColor.black
        view.alpha = alpah
        return view
    }()
    
    var alpah:CGFloat = 0.0 {
        didSet {
            backgroundView.alpha = alpah
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backgroundView)
        isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
