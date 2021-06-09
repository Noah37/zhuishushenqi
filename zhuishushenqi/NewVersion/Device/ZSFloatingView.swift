//
//  ZSFloatingView.swift
//  zhuishushenqi
//
//  Created by daye on 2021/6/9.
//  Copyright © 2021 QS. All rights reserved.
//

import UIKit

class ZSFloatingView: UIView {
    
    private var start:CGPoint = .zero
    private var original:CGPoint = .zero
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            start = touch.location(in: self)
            original = center
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let move = touch.location(in: self)
            let deltaX = move.x - start.x
            let deltaY = move.y - start.y
            center = CGPoint(x: center.x + deltaX, y: center.y + deltaY)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        var centerX:CGFloat = 0
        if center.x < ScreenWidth/2 {
            centerX = bounds.width/2 + 10
        } else {
            centerX = ScreenWidth - bounds.width/2 - 10
        }
        
        var centerY:CGFloat = center.y
        var topMargin:CGFloat = 10
        var bottomMargin:CGFloat = 10
        if IPHONEX {
            topMargin = 44
            bottomMargin = 34
        }
        if center.y < bounds.height/2 + topMargin {
            centerY = bounds.height/2 + topMargin
        } else if center.y > ScreenHeight - bounds.height/2 - bottomMargin {
            centerY = ScreenHeight - bounds.height/2 - bottomMargin
        } else {
            centerY = center.y
        }
        UIView.animate(withDuration: 0.1) {
            self.center = CGPoint(x: centerX, y: centerY)
        }
    }
}
