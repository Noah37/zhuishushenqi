//
//  String+crypto.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/3/6.
//  Copyright © 2017年 QS. All rights reserved.
//

import Foundation

extension String{
    
    //MARK: - crypto
    func md5() ->String{
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deinitialize()
        return String(format: hash as String)
    }
    
    //MARK: - Sub string Half open
    func qs_subStr(start:Int,end:Int)->String{
        if self == "" {
            return self
        }
        var ends = end
        if self.characters.count < ends {
            ends = self.characters.count
        }
        let startIndex = self.index(self.startIndex, offsetBy: start)
        let endIndex = self.index(self.startIndex, offsetBy: ends)
        let range = startIndex..<endIndex
        let sub = self[range]
        return String(sub)
    }
    
    func qs_subStr(start:Int,length:Int)->String{
        if self == "" {
            return self
        }
        let startIndex = self.index(self.startIndex, offsetBy: start)
        let endIndex = self.index(self.startIndex, offsetBy: start + length)
        let range = startIndex..<endIndex
        let sub = self[range]
        return String(sub)
    }
    
    func qs_subStr(from:Int)->String{
        if self == "" {
            return self
        }
        let startIndex = self.index(self.startIndex, offsetBy: from)
        let endIndex = self.endIndex
        let range = startIndex..<endIndex
        let sub = self[range]
        return String(sub)
    }
    
    func qs_subStr(to:Int)->String{
        if self == "" {
            return self
        }
        let startIndex = self.startIndex
        let endIndex = self.index(self.startIndex, offsetBy: to)
        let range = startIndex..<endIndex
        let sub = self[range]
        return String(sub)
    }
    
    func qs_subStr(range:CountableRange<Int>)->String{
        if  self == "" {
            return self
        }
        let startIndex = range.startIndex
        let endIndex = range.endIndex
        let sub = self.qs_subStr(start: startIndex, end: endIndex)
        return sub
    }
    
    func qs_subStr(range:NSRange)->String{
        if  self == "" {
            return self
        }
        let start = range.location
        let end = range.location + range.length
        return self.qs_subStr(start: start, end: end)
    }
    
    //MARK:- count
    func qs_width(_ font:UIFont,height:CGFloat) ->CGFloat
    {
        let dict = [NSAttributedStringKey.font:font]
        let sttt:NSString = self as NSString
        let rect:CGRect = sttt.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(height)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: dict, context: nil)
        return rect.size.width
    }
    
    func qs_height(_ font:UIFont,width:CGFloat) ->CGFloat
    {
        let dict = [NSAttributedStringKey.font:font]
        let sttt:NSString = self as NSString
        let rect:CGRect = sttt.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: dict, context: nil)
        return rect.size.height
    }
    
    func qs_width(_ fontSize:CGFloat,height:CGFloat) -> CGFloat{
        let dict = [NSAttributedStringKey.font:UIFont.systemFont(ofSize: fontSize)]
        let sttt:NSString = self as NSString
        let rect:CGRect = sttt.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(height)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: dict, context: nil)
        return rect.size.width
    }
    
    func qs_height(_ fontSize:CGFloat,width:CGFloat) ->CGFloat
    {
        let dict = [NSAttributedStringKey.font:UIFont.systemFont(ofSize: fontSize)]
        let sttt:NSString = self as NSString
        let rect:CGRect = sttt.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: dict, context: nil)
        return rect.size.height
    }

}
