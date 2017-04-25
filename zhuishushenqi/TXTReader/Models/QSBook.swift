//
//  QSBook.swift
//  TXTReader
//
//  Created by Nory Cao on 2017/4/14.
//  Copyright © 2017年 masterY. All rights reserved.
//

import UIKit

class QSBook: NSObject {
    //可选，下载过则存在，未下载过置空
    var chapters:[QSChapter]?{
        didSet{
            if let chaptersTmp = chapters {
                self.setAttribute(chapters: chaptersTmp)
            }
        }
    }
    var totalChapters:Int = 0
    var bookID:String = "" //bookID为在追书中的ID
    var bookName:String?
    var resources:[ResourceModel]?//书籍来源，这里面有所有的来源id
    var curRes:Int = 0 //dhqm选择来源
    //约束，这个约束是全局的，只要设置有变化，所有的书籍都随之变化
    var attribute:NSDictionary = [NSFontAttributeName:UIFont.systemFont(ofSize: 20)] {
        didSet{
            if let chaptersTmp = self.chapters {
                self.setAttribute(chapters: chaptersTmp)
            }
        }
    }
    
    private func setAttribute(chapters:[QSChapter]){
        let font:UIFont = attribute[NSFontAttributeName] as! UIFont
        let attributes = getAttributes(with: 10, font: font)
        for item in 0..<chapters.count {
            let chapter = chapters[item]
            chapter.attribute = attributes
            if  chapter.content == ""{
                continue
            }
            let size = CGSize(width:UIScreen.main.bounds.size.width - 40,height: UIScreen.main.bounds.size.height - 40)
            chapter.ranges = self.pageWithAttributes(attrubutes: attributes, constrainedToSize: size, string: chapter.content) as? [String]
        }
    }
    
    private func pageWithAttributes(attrubutes:NSDictionary,constrainedToSize size:CGSize,string:String)->NSArray{
        let resultRange = NSMutableArray(capacity: 5)
        let rect = CGRect(x:0,y: 0,width: size.width,height: size.height)
        let attributedString = NSAttributedString(string:string , attributes: attrubutes as? [String : AnyObject])
        let date = NSDate()
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
        let millionSecond = NSDate().timeIntervalSince(date as Date)
        QSLog("耗时：\(millionSecond)")
        
        return resultRange
    }
    
}
