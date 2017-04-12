//
//  UIImageView+zhuishu.swift
//  zhuishushenqi
//
//  Created by Nory Chao on 2017/3/16.
//  Copyright © 2017年 QS. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView{
    func qs_setBookCoverWithURLString(urlString:String){
        self.image = UIImage(named: "default_book_cover")
        var urlStr = urlString
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
        self.kf.setImage(with: resource, placeholder: UIImage(named: "default_book_cover"), options: nil, progressBlock: nil, completionHandler: nil)
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
        self.kf.setImage(with: resource, placeholder: UIImage(named: "default_avatar_light"), options: nil, progressBlock: nil, completionHandler: nil)
    }
}
