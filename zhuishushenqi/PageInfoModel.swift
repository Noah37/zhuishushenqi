//
//  PageInfoModel.swift
//  PageViewController
//
//  Created by caonongyun on 16/10/10.
//  Copyright © 2016年 CNY. All rights reserved.
//

import UIKit

enum ReaderType:Int {
    case Online = 10000
    case Local = 10001
}

class PageInfoModel: NSObject ,NSCoding{
    
    var pageIndex:Int = 0
    var chapter:Int = 0
    var chapters:[ChapterModel]?
    var bookName:String = ""
    var type:ReaderType = .Local
    
    static let userPath:String? = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
    var filePath:String? = "\(userPath!)/\(NSStringFromClass(PageInfoModel.self))"
    func encodeWithCoder(aCoder: NSCoder){
        aCoder.encodeObject(self.chapters, forKey: "chapters")
        aCoder.encodeObject(self.chapter, forKey: "chapter")
        aCoder.encodeObject(self.pageIndex, forKey: "pageIndex")
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init()
        self.pageIndex = aDecoder.decodeObjectForKey("pageIndex") as! Int
        self.chapter = aDecoder.decodeObjectForKey("chapter") as! Int
        self.chapters = aDecoder.decodeObjectForKey("chapters") as? [ChapterModel]
    }
    
    override init() {
        
    }
    
    //MARK: - 阅读本地 TXT 时，获取保存的 model
    func getLocalModel(content:String)->PageInfoModel{
        let model:PageInfoModel? = PageInfoModel()
        if self.chapters?.count == 0 || self.chapters == nil {
            var modelll = NSKeyedUnarchiver.unarchiveObjectWithFile("\(filePath!).archive") as? PageInfoModel ?? nil
            if modelll == nil {
                modelll = model
            }
            if modelll?.chapters?.count == 0 || modelll?.chapters == nil {
                return getChapter(WithContent: content,model: modelll!)
            }
            return modelll!
        }
        return getChapter(WithContent: content,model: model!)
    }
    
    //MARK: - 在线阅读时，读取本地已经下载过的章节
    func getLocalModel(content:String,name:String)->PageInfoModel{
        let model:PageInfoModel? = PageInfoModel()
        model?.type = .Online
        self.bookName = name
        if self.chapters?.count == 0 || self.chapters == nil {
            var modelll = NSKeyedUnarchiver.unarchiveObjectWithFile("\(filePath!)\(self.bookName).archive") as? PageInfoModel ?? nil
            if modelll == nil {
                modelll = model
            }
            if modelll?.chapters?.count == 0 || modelll?.chapters == nil {
                return getChapter(WithContent: content,model: modelll!)
            }else{
                let contentStr:NSMutableString = NSMutableString()
                for index in 0..<modelll!.chapters!.count {
                    contentStr.appendString("\((modelll!.chapters![index] as ChapterModel).content!)")
                }
                contentStr.appendString(content)
                modelll = getChapter(WithContent: contentStr as String,model: modelll!)
                for item in (modelll?.chapters)! {
                    let chapterModel:ChapterModel = item
                    
                    print("\(chapterModel.title)")
                }
            }
            return modelll!
        }
        return getChapter(WithContent: content,model: model!)
    }

    func getModelWithContent(content:String,bookName:String)->PageInfoModel{
        if type == .Online {
            let pageModel = getLocalModel(content,name: bookName)
            return pageModel
        }else if type == .Local {
            let pageModel = getLocalModel(content)
            return pageModel
        }
        return PageInfoModel()
    }
    
    func getChapter(WithContent content:String,model:PageInfoModel)->PageInfoModel{
        //章节名过滤，只有特定的名称才能识别，不过可以更改正则，做更多的的适配
        let parten = "第[0-9一二三四五六七八九十百千]*[章回].*"
        do{
            let reg = try NSRegularExpression(pattern: parten, options: .CaseInsensitive)
            let match = reg.matchesInString(content, options: .ReportCompletion, range: NSMakeRange(0, (content as NSString).length))
            if match.count != 0 {
                let model = model
                model.bookName = self.bookName
                var lastRange:NSRange?
                let chapterArr:NSMutableArray = NSMutableArray()
                for index in 0...match.count {
                    var range = match[index == 0 ? index:index - 1].range
                    let chapterModel = ChapterModel()
                    if match.count == 1 {
                        if index == 0 {
                            chapterModel.title = (content as NSString).substringWithRange(range)
                            chapterModel.content = self.trim((content as NSString).substringWithRange(NSMakeRange(range.location , (content as NSString).length)))
                            chapterArr.addObject(chapterModel)
                        }
                    } else{
                        if index != 0 && index != match.count {
                            range = match[index].range
                            chapterModel.title = (content as NSString).substringWithRange(lastRange!)
                            
                            chapterModel.content = self.trim((content as NSString).substringWithRange(NSMakeRange(lastRange!.location, range.location - lastRange!.location)))
                            chapterArr.addObject(chapterModel)
                        }else if index == match.count {
                            chapterModel.title = (content as NSString).substringWithRange(lastRange!)
                            chapterModel.content = self.trim((content as NSString).substringWithRange(NSMakeRange(lastRange!.location, (content as NSString).length - lastRange!.location)))
                            chapterArr.addObject(chapterModel)
                        }
                    }
                    lastRange = range
                }
                model.chapters = chapterArr.copy() as? [ChapterModel]
                updateModel(WithModel: model)
                return model
            }
        }catch{
            
        }
        return PageInfoModel()
    }
    
    func updateModel(WithModel model:PageInfoModel){
        
        let success = NSKeyedArchiver.archiveRootObject(model, toFile: "\(filePath!)\(self.bookName).archive")
        if success {
            print("更新成功")
        }
    }
    
    //去掉章节结尾的多余的空格，防止产生空白页
    func trim(str:String)->String{
        let mStr = NSMutableString(string: str)
        let ocStr = str as NSString
        for item in  0..<ocStr.length {
            let last = ocStr.length - 1 - item
            if (str as NSString).substringFromIndex(last) == " " || (str as NSString).substringFromIndex(last) == "\n" {
                mStr.deleteCharactersInRange(NSMakeRange(last, 1))
            }else{
                break;
            }
        }
        return mStr.copy() as! String
    }
}
