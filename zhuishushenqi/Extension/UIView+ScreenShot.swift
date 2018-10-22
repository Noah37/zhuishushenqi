//
//  UIView+ScreenShot.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/4/17.
//  Copyright © 2017年 QS. All rights reserved.
//

import Foundation
import UIKit
import PKHUD

func RGBAColor<T>(_ red:T, _ green:T, _ blue:T, _ alpha:CGFloat? = 1) -> UIColor {
    
    var redString = "\(red)"
    var greenString = "\(green)"
    var blueString = "\(blue)"
    if redString.hasPrefix("0x") || redString.hasPrefix("0X") {
        redString = redString.qs_subStr(from: 2)
    }
    if greenString.hasPrefix("0x") || greenString.hasPrefix("0X") {
        greenString = greenString.qs_subStr(from: 2)
    }
    if blueString.hasPrefix("0x") || blueString.hasPrefix("0X") {
        blueString = blueString.qs_subStr(from: 2)
    }
    
//    if T.self == CGFloat.self || T.self == Int.self || T.self == Double.self {
//        let redFloatValue:CGFloat = red as! CGFloat
//        let greenFloatValue:CGFloat = green as! CGFloat
//        let blueFloatValue:CGFloat = blue as! CGFloat
//        return UIColor(red: redFloatValue/255, green: greenFloatValue/255, blue: blueFloatValue/255, alpha: alpha ?? 1)
//    }
    
    return UIColor(hexString: "#\(redString)\(greenString)\(blueString)") ?? UIColor.black
}

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
    
    func showTipView(tip:String) {
        HUD.flash(.label(tip), delay: 3)
    }
    
    func showProgress() {
        HUD.flash(.labeledProgress(title: "正在请求...", subtitle: nil))
    }
    
    func hideProgress() {
        HUD.hide(animated: true)
    }
    
    func showTip(tip:String) {
        let tag = 10124
        if let tipLabel = self.viewWithTag(tag) {
            tipLabel.removeFromSuperview()
        }
        
        let width = tip.qs_width(UIFont.systemFont(ofSize: 14), height: 30)
        let label = UILabel(frame: CGRect(x: ScreenWidth/2 - (width + 20)/2, y: self.bounds.height/2 - 15, width: width + 20, height: 30))
        label.backgroundColor = UIColor.gray
        label.textAlignment = .center
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.white
        label.text = tip
        label.tag = tag
        self.addSubview(label)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+3) {
            label.removeFromSuperview()
            label.text = nil
        }
    }
}
