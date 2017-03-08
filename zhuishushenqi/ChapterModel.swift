//
//  ChapterModel.swift
//  PageViewController
//
//  Created by caonongyun on 16/10/10.
//  Copyright © 2016年 CNY. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


class ChapterModel: NSObject ,NSCoding{

    var title:String = ""
    var content:String?{
        didSet{
            self.ranges = self.pageWithAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 20)], constrainedToSize: CGSize(width: UIScreen.main.bounds.size.width - 40, height: UIScreen.main.bounds.size.height - 40), string: content!)
            self.pageCount = self.ranges!.count
        }
    }
    
    var pageCount:Int = 0
    var ranges:NSArray?
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.content, forKey: "content")
        aCoder.encode(self.pageCount, forKey: "pageCount")
        aCoder.encode(self.ranges, forKey: "ranges")

    }
    
    required init?(coder aDecoder: NSCoder){
        super.init()
        self.pageCount = aDecoder.decodeObject(forKey: "pageCount") as! Int
        self.title = aDecoder.decodeObject(forKey: "title") as! String
        self.content = aDecoder.decodeObject(forKey: "content") as? String
        self.ranges = aDecoder.decodeObject(forKey: "ranges") as? NSArray
    }
    
    override init() {
        
    }
    
    func pageWithAttributes(_ attrubutes:NSDictionary,constrainedToSize size:CGSize,string:String)->NSArray{
        let resultRange = NSMutableArray(capacity: 5)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let attributedString = NSAttributedString(string:string , attributes: attrubutes as? [String : AnyObject])
        let date = Date()
        var rangeIndex = 0
        repeat{
            let length = min(750, attributedString.length - rangeIndex)
            let childString = attributedString.attributedSubstring(from: NSMakeRange(rangeIndex, length))
            let childFramesetter = CTFramesetterCreateWithAttributedString(childString)
            let bezierPath = UIBezierPath(rect: rect)
            let frame = CTFramesetterCreateFrame(childFramesetter, CFRangeMake(0, 0), bezierPath.cgPath, nil)
            let range = CTFrameGetVisibleStringRange(frame)
            let r:NSRange = NSMakeRange(rangeIndex, range.length)
            if r.length > 0 {
                resultRange.add(NSStringFromRange(r))
            }
            rangeIndex += r.length
            
        }while (rangeIndex < attributedString.length  && Int(attributedString.length) > 0 )
        let millionSecond = Date().timeIntervalSince(date)
        print("耗时：\(millionSecond)")
        
        return resultRange
    }
    
    func stringOfPage(_ page:Int)->String{
        if self.ranges?.count <= page || page < 0 {
            return ""
        }
        let str = (content! as NSString).substring(with: NSRangeFromString(self.ranges![page] as! String))
        return str
    }

}
