//
//  UIImageView+zhuishu.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/3/16.
//  Copyright © 2017年 QS. All rights reserved.
//

import Foundation
import UIKit
import ZSAppConfig
import Kingfisher

public class ZSResource: Resource {
    
    public var imageURL:URL? = URL(string: "http://statics.zhuishushenqi.com/ranking-cover/142319144267827")
    public var downloadURL: URL {
        return imageURL!
    }
    
    public var cacheKey: String{
        return "\(String(describing: self.imageURL))"
    }
    
    init(url:URL) {
        self.imageURL = url
    }
    
}

extension UIImageView{
    public func qs_setBookCoverWithURLString(urlString:String){
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
            let resource:ZSResource = ZSResource(url: imageURL)
            self.kf.setImage(with: resource, placeholder: UIImage(named: "default_book_cover"), options: nil, progressBlock: nil, completionHandler: nil)
//        }
    }
    
    public func qs_setAvatarWithURLString(urlString:String){
        self.image = UIImage(named: "default_avatar_light")
        let imageUrlString =  "\(IMAGE_BASEURL)\(urlString)"
        let url:URL? = URL(string: imageUrlString)
        guard let imageURL = url else {
            QSLog("Invalid URL")
            return
        }
        let resource:ZSResource = ZSResource(url: imageURL)
        self.kf.setImage(with: resource, placeholder: UIImage(named: "default_avatar_light"), options: nil, progressBlock: nil, completionHandler: nil)
    }
    
    public func qs_addCorner(radius: CGFloat) {
        //1.一种圆角添加方式，效率比直接CornerRadius高
        self.image = self.image?.qs_drawRectWithRoundedCorner(radius: radius, self.bounds.size)
    }
    
    public func qs_addCornerRadius(cornerRadius:CGFloat){
        //2.高效添加圆角的方式
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width:cornerRadius, height: cornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
}

extension UIButton{
    public func qs_setBookCoverWithUrlString(urlString:String){
        
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
        let resource:ZSResource = ZSResource(url: imageURL)
        self.kf.setImage(with:resource, for: .normal, placeholder: UIImage(named:"default_book_cover"), options: nil, progressBlock: nil, completionHandler: nil)
    }
}

