//
//  ZSReaderTouchArea.swift
//  zhuishushenqi
//
//  Created by caony on 2020/1/9.
//  Copyright © 2020 QS. All rights reserved.
//

import UIKit

protocol ZSReaderTouchAreaDelegate:class {
    func touchAreaTapCenter(touchAres:ZSReaderTouchArea)
}

class ZSReaderTouchArea: UIView, UIGestureRecognizerDelegate {
    
    private lazy var backgroundView:UIView = {
        let view = UIView(frame: self.bounds)
        view.backgroundColor = UIColor.black
        view.alpha = alpah
        view.isUserInteractionEnabled = false
        return view
    }()
    
    var alpah:CGFloat = 0.0 {
        didSet {
            backgroundView.alpha = alpah
        }
    }
    
    weak var delegate:ZSReaderTouchAreaDelegate?

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
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}
