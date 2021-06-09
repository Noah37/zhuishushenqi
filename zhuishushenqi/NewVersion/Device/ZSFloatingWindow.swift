//
//  ZSFloatingWindow.swift
//  zhuishushenqi
//
//  Created by daye on 2021/6/9.
//  Copyright © 2021 QS. All rights reserved.
//

import UIKit

class ZSFloatingWindow: UIWindow {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let rootVC = rootViewController {
            for subview in rootVC.view.subviews {
                if subview.frame.contains(point) {
                    return subview
                }
            }
        }
        let hitView = super.hitTest(point, with: event)
        return hitView
    }
    
}
