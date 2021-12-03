//
//  UIImageView+zhuishu.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/3/16.
//  Copyright © 2017年 QS. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView{
    func qs_setBookCoverWithURLString(urlString:String){
        self.image = UIImage(named: "default_book_cover")
//        DispatchQueue.global().async {
        let noPercentStr:String = urlString.removingPercentEncoding ?? ""
            var urlStr = noPercentStr
            if urlStr.qs_subStr(to: 4) != "http"{
//                urlStr = urlStr.qs_subStr(from: 7)
                urlStr = "\(IMAGE_BASEURL)\(urlStr)-coverl"
            }
            if urlStr.contains("http") == false {
                urlStr = "\(IMAGE_BASEURL)\(noPercentStr)"
            }
            let url = URL(string: urlStr)
            guard let imageURL = url else {
                QSLog("Invalid URL")
                return
            }
            let resource:QSResource = QSResource(url: imageURL)
            self.kf.setImage(with: resource, placeholder: UIImage(named: "default_book_cover"))
//        }
    }
    
    func qs_setAvatarWithURLString(urlString:String){
        self.image = UIImage(named: "default_avatar_light")
        let imageUrlString =  "\(IMAGE_BASEURL)\(urlString)"
        let url:URL? = URL(string: imageUrlString)
        guard let imageURL = url else {
            QSLog("Invalid URL")
            return
        }
        let resource:QSResource = QSResource(url: imageURL)
        self.kf.setImage(with: resource, placeholder: UIImage(named: "default_avatar_light"))
    }
    
    func qs_addCorner(radius: CGFloat) {
        //1.一种圆角添加方式，效率比直接CornerRadius高
        self.image = self.image?.qs_drawRectWithRoundedCorner(radius: radius, self.bounds.size)
    }
    
    func qs_addCornerRadius(cornerRadius:CGFloat){
        //2.高效添加圆角的方式
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width:cornerRadius, height: cornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
}

public struct ZSWrapper<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol ZSCompatible: AnyObject { }

public protocol ZSCompatibleValue {}

extension ZSCompatible {
    /// Gets a namespace holder for zs compatible types.
    public var zs: ZSWrapper<Self> {
        get { return ZSWrapper(self) }
        set { }
    }
}

extension ZSCompatibleValue {
    /// Gets a namespace holder for zs compatible types.
    public var zs: ZSWrapper<Self> {
        get { return ZSWrapper(self) }
        set { }
    }
}

extension ZSWrapper where Base: UIImageView {
    func setImage(imageUrl:String, placeHolder:String? = nil) {
        let url = URL(string: imageUrl)
        guard let imageURL = url else {
            QSLog("Invalid URL")
            return
        }
        let resource:QSResource = QSResource(url: imageURL)
    }
}

extension UIImageView {
    func setImage(imageUrl:String, placeHolder:String? = nil) {
        let url = URL(string: imageUrl)
        guard let imageURL = url else {
            QSLog("Invalid URL")
            return
        }
        let resource:QSResource = QSResource(url: imageURL)
        self.kf.setImage(with: resource, placeholder: UIImage(named: placeHolder ?? ""))
    }
}

extension UIButton{
    func qs_setBookCoverWithUrlString(urlString:String){
        
        let noPercentStr:String = urlString.removingPercentEncoding ?? ""
        self.setImage(UIImage(named: "default_book_cover"), for: .normal)
        var urlStr = noPercentStr
        if urlStr.qs_subStr(to: 4) != "http"{
            urlStr = urlStr.qs_subStr(from: 7)
        }
        if urlStr.contains("http") == false {
            urlStr = "\(IMAGE_BASEURL)\(urlString)"
        }
        let url = URL(string: urlStr)
        guard let imageURL = url else {
            QSLog("Invalid URL")
            return
        }
        let resource:QSResource = QSResource(url: imageURL)
        self.kf.setImage(with:resource, for: .normal, placeholder: UIImage(named:"default_book_cover"))
    }
}

