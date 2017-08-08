//
//  UIView+ScreenShot.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/4/17.
//  Copyright © 2017年 QS. All rights reserved.
//

import Foundation
import UIKit
extension UIView {
    func screenShot()->UIImage?{
        let size = self.bounds.size
        let transform:CGAffineTransform = __CGAffineTransformMake(-1, 0, 0, 1, size.width, 0)
        UIGraphicsBeginImageContextWithOptions(size, self.isOpaque, 0.0)
        let context = UIGraphicsGetCurrentContext()
        context?.concatenate(transform)
        self.layer.render(in: context!)
        let image:UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func nextController()->UIViewController?{
        var nextResponder:UIResponder? = self.next
        while (nextResponder != nil) {
            if nextResponder?.isKind(of: UIViewController.self) == true {
                return nextResponder as? UIViewController
            }
            nextResponder = nextResponder?.next
        }
        return nil
    }
    
}
