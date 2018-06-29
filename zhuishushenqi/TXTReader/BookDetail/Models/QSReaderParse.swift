//
//  QSReaderParse.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2018/2/6.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit

class QSReaderParse: NSObject {
    
    //去掉章节开头跟结尾的多余的空格，防止产生空白页
    public class func trim(str:String)->String{
        var spaceStr:String = str
        spaceStr = spaceStr.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return spaceStr
    }
    
    //耗时操作，只在显示章节时才去计算,计算完成将会缓存，在改变约束，或者换源时重置
    public class func pageWithAttributes(attrubutes:[NSAttributedStringKey:Any]?,constrainedToFrame frame:CGRect,string:String)->[NSRange]{
        // 记录
        let date = NSDate()
        var rangeArray:[NSRange] = []
        
        // 拼接字符串
        let attrString = NSMutableAttributedString(string: string, attributes: attrubutes)
        
        let frameSetter = CTFramesetterCreateWithAttributedString(attrString as CFAttributedString)
        
        let path = CGPath(rect: frame, transform: nil)
        
        var range = CFRangeMake(0, 0)
        
        var rangeOffset:NSInteger = 0
        
        repeat{
            
            let frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(rangeOffset, 0), path, nil)
            
            range = CTFrameGetVisibleStringRange(frame)
            
            rangeArray.append(NSMakeRange(rangeOffset, range.length))
            
            rangeOffset += range.length
            
        }while(range.location + range.length < attrString.length)
        
        
        let millionSecond = NSDate().timeIntervalSince(date as Date)
        QSLog("耗时：\(millionSecond)")
        
        return rangeArray
    }

}
