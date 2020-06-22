//
//  String+crypto.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/3/6.
//  Copyright © 2017年 QS. All rights reserved.
//

import Foundation
import CommonCrypto

extension String {
    
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
        result.deinitialize(count: digestLen)
        return String(format: hash as String)
    }
    
    //由于移动设备的内存有限,以下代码实现是将文件分块读出并且计算md5值的方法
    func fileMD5()->String? {
        let handler = FileHandle(forReadingAtPath: self)
        if handler == nil {
            return nil
        }
        let ctx = UnsafeMutablePointer<CC_MD5_CTX>.allocate(capacity: MemoryLayout<CC_MD5_CTX>.size)
        CC_MD5_Init(ctx)
        var done = false
        while !done {
            let fileData = handler?.readData(ofLength: 256)
            fileData?.withUnsafeBytes({ (bytes) -> Void in
                CC_MD5_Update(ctx, bytes, CC_LONG(fileData!.count))
            })
            if fileData?.count == 0 {
                done = true
            }
        }
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let digest = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5_Final(digest, ctx)
        var hash = ""
        for i in 0..<digestLen {
            hash += String(format:"%02x",(digest[i]))
        }
//        digest.deinitialize()
//        ctx.deinitialize()
        return hash
    }
    
    //MARK: - Sub string Half open
    func qs_subStr(start:Int,end:Int)->String{
        if self == "" {
            return self
        }
        var ends = end
        if self.count < ends {
            ends = self.count
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
        let dict = [NSAttributedString.Key.font:font]
        let sttt:NSString = self as NSString
        let rect:CGRect = sttt.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(height)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: dict, context: nil)
        return rect.size.width
    }
    
    func qs_height(_ font:UIFont,width:CGFloat) ->CGFloat
    {
        let dict = [NSAttributedString.Key.font:font]
        let sttt:NSString = self as NSString
        let rect:CGRect = sttt.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: dict, context: nil)
        return rect.size.height
    }
    
    func qs_width(_ fontSize:CGFloat,height:CGFloat) -> CGFloat{
        let dict = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: fontSize)]
        let sttt:NSString = self as NSString
        let rect:CGRect = sttt.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(height)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: dict, context: nil)
        return rect.size.width
    }
    
    func qs_height(_ fontSize:CGFloat,width:CGFloat) ->CGFloat
    {
        let dict = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: fontSize)]
        let sttt:NSString = self as NSString
        let rect:CGRect = sttt.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: dict, context: nil)
        return rect.size.height
    }
    
    
    //获取子字符串
    func substingInRange(_ r: Range<Int>) -> String? {
        if r.lowerBound < 0 || r.upperBound > self.count {
            return nil
        }
        let startIndex = self.index(self.startIndex, offsetBy:r.lowerBound)
        let endIndex   = self.index(self.startIndex, offsetBy:r.upperBound)
        return String(self[startIndex..<endIndex])
    }
    
    //MARK: - equal
    func isEqual(to string:String) ->Bool {
        if self == string {
            return true
        }
        return false
    }
    
    //MARK: - string
    func asNSString() ->NSString {
        return (self as NSString)
    }
    
    func isEmpty() ->Bool {
        if self == "" || self.count == 0 {
            return true
        }
        return false
    }
    
    //MARK: - transform
    var length:Int {
        return self.lengthOfBytes(using: .utf8)
    }
    
    var toArray:Array<[String:Any]>? {
        var json = self
        if json.contains("\\") {
            json = json.components(separatedBy: "\\").joined()
        }
        if let data = json.data(using: .utf8) {
            do {
                let arr = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.init(rawValue: 0)) as? Array<[String:Any]>
                return arr
            } catch let error {
                QSLog(error)
            }
        }
        return nil
    }
    
    var toDict:Dictionary<String,Any>? {
        var json = self
        if json.contains("\\") {
            json = json.components(separatedBy: "\\").joined()
        }
        if let data = json.data(using: .utf8) {
            do {
                let dict = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.init(rawValue: 0)) as? Dictionary<String,Any>
                guard let _ = dict?.first else {
                    return nil
                }
                return dict
            } catch let error {
                QSLog(error)
            }
        }
        return nil
    }
    var nsString:NSString {
        return (self as NSString)
    }

    static func stringFromDataDetectingEncoding(data: Data, suggestedEncodings: [String.Encoding] = []) -> (string: String, encoding: String.Encoding, lossy: Bool)? {
                
        var outString: NSString? = nil
        var lossyConversion: ObjCBool = false
                
        var suggestedEncodingsValues:[NSNumber] = []
        suggestedEncodingsValues = suggestedEncodings.map { (encode) -> NSNumber in
            return NSNumber.init(value: encode.rawValue)
        }
        
        let encoding = NSString.stringEncoding(for: data as Data, encodingOptions: [StringEncodingDetectionOptionsKey.suggestedEncodingsKey:suggestedEncodingsValues], convertedString: &outString, usedLossyConversion: &lossyConversion)
        
        guard let foundString = outString else { return nil }
        
        return (string: foundString as String, encoding: String.Encoding.init(rawValue: encoding), lossy: lossyConversion.boolValue)
    }
}

extension Optional {
    
}

extension String.Encoding {
    static var gbk:String.Encoding {
        let encode = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))
        return String.Encoding(rawValue: encode)
    }
    
    static func zs_encoding(str:String)->String.Encoding {
        switch str {
        case ".utf8":
            return .utf8
        case ".gbk":
            return gbk
        default:
            return .utf8
        }
    }
}
