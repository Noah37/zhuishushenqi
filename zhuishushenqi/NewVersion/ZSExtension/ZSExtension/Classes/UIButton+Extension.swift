//
//  UIButton+Extension.swift
//  zhuishushenqi
//
//  Created by caony on 2019/7/2.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit
import ZSAppConfig

extension UIButton {
    func qs_setBookCoverWithURLString(urlString:String){
        setImage(UIImage(named: "default_book_cover"), for: .normal)
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
        self.kf.setImage(with: resource, for: .normal, placeholder: UIImage(named: "default_book_cover"))
    }
    
    func qs_setAvatarWithURLString(urlString:String){
        setImage(UIImage(named: "default_avatar_light"), for: .normal)
        let imageUrlString =  "\(IMAGE_BASEURL)\(urlString)"
        let url:URL? = URL(string: imageUrlString)
        guard let imageURL = url else {
            QSLog("Invalid URL")
            return
        }
        let resource:QSResource = QSResource(url: imageURL)
        self.kf.setImage(with: resource, for: .normal, placeholder: UIImage(named: "default_avatar_light"))
    }
}
