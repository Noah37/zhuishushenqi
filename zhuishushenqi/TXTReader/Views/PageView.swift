//
//  PageView.swift
//  PageViewController
//
//  Created by caonongyun on 16/10/9.
//  Copyright © 2016年 CNY. All rights reserved.
//

import UIKit

class PageView: UIView {

    var attribute:NSDictionary?{
        didSet{
            if attributedText != nil {
                
                attributedText?.addAttributes(attribute as! [String : Any], range: NSMakeRange(0,attributedText!.length))
            }
            setNeedsDisplay()
        }
    }
    var attributedText:NSMutableAttributedString?{
        didSet{
            if attribute != nil {
                
                attributedText?.addAttributes(attribute as! [String : Any], range: NSMakeRange(0,attributedText!.length))
            }
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.textMatrix = CGAffineTransform.identity
        //x，y轴方向移动
        context!.translateBy(x: 0, y: bounds.size.height)
        //缩放x，y轴方向缩放，－1.0为反向1.0倍,坐标系转换,沿x轴翻转180度
        context!.scaleBy(x: 1.0, y: -1.0)
        let childFramesetter = CTFramesetterCreateWithAttributedString(attributedText!)
        let bezierPath = UIBezierPath(rect: rect)
        let frame = CTFramesetterCreateFrame(childFramesetter, CFRangeMake(0, 0), bezierPath.cgPath, nil)
        CTFrameDraw(frame, context!)
//        CFRelease(frame) //auto release
//        CFRelease(childFramesetter)
    }
    
    
}
