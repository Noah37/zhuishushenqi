//
//  ChapterModel.swift
//  PageViewController
//
//  Created by caonongyun on 16/10/10.
//  Copyright © 2016年 CNY. All rights reserved.
//

import UIKit

class ChapterModel: NSObject ,NSCoding{

    var title:String = ""
    var content:String?{
        didSet{
            self.ranges = self.pageWithAttributes([NSFontAttributeName:UIFont.systemFontOfSize(20)], constrainedToSize: CGSizeMake(UIScreen.mainScreen().bounds.size.width - 40, UIScreen.mainScreen().bounds.size.height - 40), string: content!)
            self.pageCount = self.ranges!.count
        }
    }
    
    var pageCount:Int = 0
    var ranges:NSArray?
    
    func encodeWithCoder(aCoder: NSCoder){
        aCoder.encodeObject(self.title, forKey: "title")
        aCoder.encodeObject(self.content, forKey: "content")
        aCoder.encodeObject(self.pageCount, forKey: "pageCount")
        aCoder.encodeObject(self.ranges, forKey: "ranges")

    }
    
    required init?(coder aDecoder: NSCoder){
        super.init()
        self.pageCount = aDecoder.decodeObjectForKey("pageCount") as! Int
        self.title = aDecoder.decodeObjectForKey("title") as! String
        self.content = aDecoder.decodeObjectForKey("content") as? String
        self.ranges = aDecoder.decodeObjectForKey("ranges") as? NSArray
    }
    
    override init() {
        
    }
    
    func pageWithAttributes(attrubutes:NSDictionary,constrainedToSize size:CGSize,string:String)->NSArray{
        let resultRange = NSMutableArray(capacity: 5)
        let rect = CGRectMake(0, 0, size.width, size.height)
        let attributedString = NSAttributedString(string:string , attributes: attrubutes as? [String : AnyObject])
        let date = NSDate()
        var rangeIndex = 0
        repeat{
            let length = min(750, attributedString.length - rangeIndex)
            let childString = attributedString.attributedSubstringFromRange(NSMakeRange(rangeIndex, length))
            let childFramesetter = CTFramesetterCreateWithAttributedString(childString)
            let bezierPath = UIBezierPath(rect: rect)
            let frame = CTFramesetterCreateFrame(childFramesetter, CFRangeMake(0, 0), bezierPath.CGPath, nil)
            let range = CTFrameGetVisibleStringRange(frame)
            let r:NSRange = NSMakeRange(rangeIndex, range.length)
            if r.length > 0 {
                resultRange.addObject(NSStringFromRange(r))
            }
            rangeIndex += r.length
            
        }while (rangeIndex < attributedString.length  && Int(attributedString.length) > 0 )
        let millionSecond = NSDate().timeIntervalSinceDate(date)
        print("耗时：\(millionSecond)")
        
        return resultRange
    }
    
    func stringOfPage(page:Int)->String{
        if self.ranges?.count <= page || page < 0 {
            return ""
        }
        let str = (content! as NSString).substringWithRange(NSRangeFromString(self.ranges![page] as! String))
        return str
    }

}
