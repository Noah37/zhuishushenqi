//
//  String+crypto.swift
//  zhuishushenqi
//
//  Created by Nory Chao on 2017/3/6.
//  Copyright © 2017年 XYC. All rights reserved.
//

import Foundation

extension String{
    func md5() ->String!{
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
    
    //Half open
    func sub(start:Int,end:Int)->String{
        if self == "" {
            return self
        }
        let startIndex = self.index(self.startIndex, offsetBy: start)
        let endIndex = self.index(self.startIndex, offsetBy: end)
        let range = startIndex..<endIndex
        let sub = self.substring(with: range)
        return sub
    }
    
    func sub(start:Int,length:Int)->String{
        if self == "" {
            return self
        }
        let startIndex = self.index(self.startIndex, offsetBy: start)
        let endIndex = self.index(self.startIndex, offsetBy: start + length)
        let range = startIndex..<endIndex
        let sub = self.substring(with: range)
        return sub
    }
    
    func subStr(from:Int)->String{
        if self == "" {
            return self
        }
        let startIndex = self.index(self.startIndex, offsetBy: from)
        let endIndex = self.endIndex
        let range = startIndex..<endIndex
        let sub = self.substring(with: range)
        return sub
    }
    
    func subStr(to:Int)->String{
        if self == "" {
            return self
        }
        let startIndex = self.startIndex
        let endIndex = self.index(self.startIndex, offsetBy: to)
        let range = startIndex..<endIndex
        let sub = self.substring(with: range)
        return sub
    }
}
