//
//  PageView.swift
//  PageViewController
//
//  Created by caonongyun on 16/10/9.
//  Copyright © 2016年 CNY. All rights reserved.
//

import UIKit

class PageView: UIView {

    var attribute:[String:AnyObject]?
    var attributedText:NSMutableAttributedString?{
        didSet{
            if attribute != nil {
                
                attributedText?.addAttributes(attribute!, range: NSMakeRange(0,attributedText!.length))
            }
            setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetTextMatrix(context, CGAffineTransformIdentity)
        //x，y轴方向移动
        CGContextTranslateCTM(context, 0, bounds.size.height)
        //缩放x，y轴方向缩放，－1.0为反向1.0倍,坐标系转换,沿x轴翻转180度
        CGContextScaleCTM(context, 1.0, -1.0)
        let childFramesetter = CTFramesetterCreateWithAttributedString(attributedText!)
        let bezierPath = UIBezierPath(rect: rect)
        let frame = CTFramesetterCreateFrame(childFramesetter, CFRangeMake(0, 0), bezierPath.CGPath, nil)
        CTFrameDraw(frame, context!)
//        CFRelease(frame) //auto release
//        CFRelease(childFramesetter)
    }
    
    
}
