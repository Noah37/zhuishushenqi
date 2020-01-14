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
    
    weak var delegate:ZSReaderTouchAreaDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backgroundView)
        isUserInteractionEnabled = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(tap:)))
        tap.numberOfTouchesRequired = 1
        tap.numberOfTapsRequired = 1
        addGestureRecognizer(tap)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
//         let touchs = event?.allTouches
//        if view == self {
//            return self.superview
//        }
        return view
    }
    
    @objc
    private func tapAction(tap:UITapGestureRecognizer) {
        delegate?.touchAreaTapCenter(touchAres: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
