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

class ZSReaderTouchManager {
    
    var touchWindow:ZSReaderTouchWindow!
    
    static let share = ZSReaderTouchManager()
    private init() {
        touchWindow = ZSReaderTouchWindow()
        touchWindow.frame = UIScreen.main.bounds
        touchWindow.windowLevel = .normal
        touchWindow.backgroundColor = UIColor.clear
    }
    
    func show(view:UIView) {
        touchWindow.addSubview(view)
        touchWindow.isHidden = false
    }
    
    func hiden(view:UIView) {
        view.removeFromSuperview()
        touchWindow.isHidden = true
    }
    
    func hiden() {
        touchWindow.isHidden = true
        for subview in touchWindow.subviews {
            subview.removeFromSuperview()
        }
    }
}

class ZSReaderTouchWindow: UIWindow {
    
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
        isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(tap:)))
        addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @objc
    private func tapAction(tap:UITapGestureRecognizer) {
        delegate?.touchAreaTapCenter(touchAres: self)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}
