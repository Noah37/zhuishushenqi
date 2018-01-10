//
//  ChapterInfo.swift
//  TXTReader
//
//  Created by Nory Cao on 16/11/24.
//  Copyright © 2016年 QS. All rights reserved.
//

import UIKit
import ObjectMapper

//@objc(ChapterInfo)
class ChapterInfo: Mappable ,NSCoding{

    //数据持久化标志，代表当前的章节，与小说对应章节可能不符
    var currentIndex:Int = 0
    //标题
    var title:String = ""
    //附加信息
    var body:String = "" {
        didSet{
            body = self.trim(str: body)
            if body == "" {
                return
            }
            self.ranges = self.pageWithAttributes(attrubutes: self.attribute!, constrainedToSize: CGSize(width:UIScreen.main.bounds.size.width - 40,height: UIScreen.main.bounds.size.height - 40), string: body) as? [String]
        }
    }
    //正文
    var cpContent:String? = "" {
        didSet{
            cpContent = self.trim(str: cpContent!)
            if cpContent == "" {
                return
            }
             self.ranges = self.pageWithAttributes(attrubutes: self.attribute!, constrainedToSize: CGSize(width:UIScreen.main.bounds.size.width - 40,height: UIScreen.main.bounds.size.height - 40), string: cpContent!) as? [String]
        }
    }
    //来源
    var resource:ResourceModel?
    //章节id，根据此id查询章节信息
    var id:String = ""
    //花费
    var currency:Int = 0
    //当前章节的划分的范围，即每一页的范围
    var ranges:[String]? = ["{0,0}"]
    //文字约束
    var attribute:NSDictionary? = ["size": 20] {
        didSet{
            //如果设置约束，则重新计算
            self.ranges = self.pageWithAttributes(attrubutes: [NSFontAttributeName:UIFont.systemFont(ofSize: 20)], constrainedToSize: CGSize(width:UIScreen.main.bounds.size.width - 40,height: UIScreen.main.bounds.size.height - 40), string: cpContent!) as? [String]
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.title,forKey:"title")
        aCoder.encode(self.body,forKey:"body")
        aCoder.encode(self.cpContent,forKey:"cpContent")
        aCoder.encode(self.id,forKey:"id")
        aCoder.encode(self.currency,forKey:"currency")
        aCoder.encode(self.ranges,forKey:"ranges")
        aCoder.encode(self.attribute,forKey:"attribute")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.title = aDecoder.decodeObject(forKey: "title") as! String
        self.body = aDecoder.decodeObject(forKey: "body") as! String
        self.cpContent = aDecoder.decodeObject(forKey: "cpContent") as? String
        self.id = aDecoder.decodeObject(forKey: "id") as! String
        self.currency = aDecoder.decodeObject(forKey: "currency") as! Int
        self.ranges = aDecoder.decodeObject(forKey: "ranges") as? [String]
        self.attribute = aDecoder.decodeObject(forKey: "attribute") as? NSDictionary
    }
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        title    <- map["title"]
        body         <- map["body"]
        cpContent <- map["cpContent"]
        id      <- map["id"]
        currency       <- map["currency"]
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
    
    //数据持久化，存储到document目录,以章节序号 + id的md5为key
    class func updateLocalModel(localModel:ChapterInfo,id:String) -> Void {
        let key = "QSTXTReaderKeyAt\(localModel.currentIndex)\(id)".md5()
        let jsonString = localModel.toJSON()
        let filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first?.appending("/\(key )")
        NSKeyedArchiver.archiveRootObject(jsonString, toFile: filePath!)
    }
    
    class func localModelWithKey(key:String) ->ChapterInfo?{
        let localKey = "QSTXTReaderKeyAt\(key)".md5()
        let filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first?.appending("/\(localKey )")
        var model:ChapterInfo?
        var file:[String:Any]?
        file = NSKeyedUnarchiver.unarchiveObject(withFile: filePath!) as? [String : Any]
        if file != nil {
            model = ChapterInfo(JSON: file!)
            QSLog(model?.cpContent)
        }
        return model
    }

    //去掉章节开头跟结尾的多余的空格，防止产生空白页
    func trim(str:String)->String{
        var spaceStr:String = str
        spaceStr = spaceStr.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return spaceStr
    }
}
