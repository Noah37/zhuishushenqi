//
//  QSReaderParse.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2018/2/6.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit

class QSReaderParse: NSObject {
    
    //从本地目录中获取书籍内容并解析
    public class func fetchBook(path:String,completion:((BookDetail?)->Void)?){
//        unsigned long encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);

        let encode = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))
        let url = URL(fileURLWithPath: path)
        if let content = try? String(contentsOf: url, encoding: String.Encoding(rawValue: encode)) {
            let book = self.chapterInfo(text: content, path: path)
            completion?(book)
        } else if let content = try? String(contentsOf: url, encoding: .utf8) {
            let book = self.chapterInfo(text: content, path: path)
            completion?(book)
        } else if let content = try? String(contentsOf: url, encoding: .unicode) {
            let book = self.chapterInfo(text: content, path: path)
            completion?(book)
        }
    }
    
    @discardableResult
    public class func chapterInfo(text:String,path:String) ->BookDetail?{
        //章节名过滤，只有特定的名称才能识别，不过可以更改正则，做更多的的适配
        let parten = "第[0-9一二三四五六七八九十百千]*[章回].*"
        let content = text as NSString
        let reg = try? NSRegularExpression(pattern: parten, options: .caseInsensitive)
        if let match = reg?.matches(in: text, options: .reportCompletion, range: NSMakeRange(0, content.length)) {
            let book = BookDetail()
            if match.count > 0 {
                book.title = (path as NSString).lastPathComponent
                var lastRange:NSRange?
                var chapters:[QSChapter] = []
                for index in 0..<match.count {
                    var range = match[index == 0 ? index:index - 1].range
                    let chapter = QSChapter()
                    if match.count == 1 {
                        if index == 0 {
                            chapter.title = content.substring(with: range)
                            chapter.content = self.trim(str: (text as NSString).substring(with: NSMakeRange(range.location, content.length)))
                            chapter.curChapter = index 
                            chapter.getPages()
                            chapters.append(chapter)
                        }
                    } else {
                        if index != 0 && index != match.count {
                            range = match[index].range
                            chapter.title = content.substring(with:lastRange!)
                            chapter.content = self.trim(str: content.substring(with: NSMakeRange(lastRange!.location, range.location - lastRange!.location)))
                            chapter.curChapter = index - 1
                            chapter.getPages()
                            chapters.append(chapter)
                        } else if index == match.count {
                            chapter.title = content.substring(with: lastRange!)
                            chapter.content = self.trim(str: content.substring(with: NSMakeRange(lastRange!.location, content.length - lastRange!.location)))
                            chapter.curChapter = index - 1
                            chapter.getPages()
                            chapters.append(chapter)
                        }
                    }
                    lastRange = range
                }
                book.book.localChapters = chapters
                return book
            } else {
                book.title = (path as NSString).lastPathComponent
                var chapters:[QSChapter] = []
                let chapter = QSChapter()
                chapter.title = ""
                chapter.content = text
                chapter.getPages()
                chapters.append(chapter)
                book.book.localChapters = chapters
                return book
            }
        }
        return nil
    }
    
    //去掉章节开头跟结尾的多余的空格，防止产生空白页
    public class func trim(str:String)->String{
        var spaceStr:String = str
        spaceStr = spaceStr.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return spaceStr
    }
    
    //耗时操作，只在显示章节时才去计算,计算完成将会缓存，在改变约束，或者换源时重置
    public class func pageWithAttributes(attrubutes:[NSAttributedString.Key:Any]?,constrainedToFrame frame:CGRect,string:String)->[NSRange]{
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
