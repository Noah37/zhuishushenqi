//
//  UIImage+QSData.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/3/22.
//  Copyright © 2017年 QS. All rights reserved.
//

import Foundation
import UIKit

extension UIImage{
    static func image(with base64:String) -> UIImage? {
        let data:Data? = Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
        if let decodeData = data{
            return UIImage(data: decodeData)
        }
        return nil
    }
    
    static func image(from url:String)->UIImage?{
        var image:UIImage?
        DispatchQueue.global().async {
            do{
                let url:URL? = URL(string: url)
                if let imageUrl = url {
                    let data:Data = try Data(contentsOf: imageUrl, options: .alwaysMapped)
                    image = UIImage(data: data)
                }
                
            }catch{
                QSLog(error)
            }
        }
        return image
    }
    
    func imageHasAlpha(image:UIImage)->Bool{
        let alpha:CGImageAlphaInfo? = image.cgImage?.alphaInfo
        return (alpha == CGImageAlphaInfo.first || alpha == CGImageAlphaInfo.last  || alpha == CGImageAlphaInfo.premultipliedLast || alpha == CGImageAlphaInfo.premultipliedFirst)
        
    }
    
    func base64() -> String? {
        var imageData:Data?
        var mimeType:String?
        if self.imageHasAlpha(image: self) {
            imageData = self.pngData()
            mimeType = "image/png"
        }else{
            
            imageData = self.jpegData(compressionQuality: 1.0)
            mimeType = "image/jpeg"
        }
        QSLog(mimeType)
        return imageData?.base64EncodedString(options: .endLineWithCarriageReturn)
    }
    
    func qs_drawRectWithRoundedCorner(radius: CGFloat, _ sizetoFit: CGSize) -> UIImage {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: sizetoFit)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        UIGraphicsGetCurrentContext()?.addPath(UIBezierPath(roundedRect: rect, byRoundingCorners: UIRectCorner.allCorners,
                                      cornerRadii: CGSize(width: radius, height: radius)).cgPath)
        UIGraphicsGetCurrentContext()?.clip()
        
        self.draw(in: rect)
        UIGraphicsGetCurrentContext()?.drawPath(using: .fillStroke)
        let output = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return output!
    }

}
