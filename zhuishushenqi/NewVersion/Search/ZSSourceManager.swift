//
//  ZSSourceManagerr.swift
//  zhuishushenqi
//
//  Created by caony on 2019/11/11.
//  Copyright © 2019 QS. All rights reserved.
//
// 书籍来源管理类
import UIKit

class ZSSourceManager {
    
    var sources:[ZSAikanParserModel] = []
    
    static let selectedSourceKey = "selectedSourceKey"
    
    static let share = ZSSourceManager()
    private init() {
        unpack()
    }
    
    private func unpack() {
        let modifyfilePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!.appending("/source/HtmlParserModelData_edit.dat")
        let originialfilePath_edit = Bundle(for: ZSSourceManager.self).path(forResource: "HtmlParserModelData_edit.dat", ofType: nil) ?? ""
        let originialfilePath = Bundle(for: ZSSourceManager.self).path(forResource: "HtmlParserModelData.dat", ofType: nil) ?? ""
        if let objs = NSKeyedUnarchiver.unarchiveObject(withFile: modifyfilePath) as? [ZSAikanParserModel] {
            self.sources = objs
        } else if let objs = NSKeyedUnarchiver.unarchiveObject(withFile: modifyfilePath) as? [AikanParserModel] {
            self.sources = self.transform(models: objs)
        } else if let objs = NSKeyedUnarchiver.unarchiveObject(withFile: originialfilePath_edit) as? [ZSAikanParserModel] {
            self.sources = objs
            save()
        } else if let objs = NSKeyedUnarchiver.unarchiveObject(withFile: originialfilePath_edit) as? [AikanParserModel] {
            self.sources = self.transform(models: objs)
            save()
        }
        else if let objs = NSKeyedUnarchiver.unarchiveObject(withFile: originialfilePath) as? [ZSAikanParserModel] {
            self.sources = objs
            save()
        } else if let objs = NSKeyedUnarchiver.unarchiveObject(withFile: originialfilePath) as? [AikanParserModel] {
            self.sources = self.transform(models: objs)
            save()
        }
    }
    
    private func transform(models:[AikanParserModel]) ->[ZSAikanParserModel] {
        var aikans:[ZSAikanParserModel] = []
        for model in models {
            let aikan = ZSAikanParserModel()
//            aikan.errDate = model.errDate
            aikan.searchUrl = model.searchUrl
            aikan.name = model.name
            aikan.type = Int64(model.type)
            aikan.enabled = model.enabled
            aikan.checked = model.checked
            aikan.searchEncoding = model.searchEncoding
            aikan.host = model.host
            aikan.contentReplace = model.contentReplace
            aikan.contentRemove = model.contentRemove
            aikan.content = model.content
            aikan.chapterUrl = model.chapterUrl
            aikan.chapterName = model.chapterName
            aikan.chapters = model.chapters
            aikan.chaptersModel = model.chaptersModel as? [ZSBookChapter] ?? []
            aikan.detailBookIcon = model.detailBookIcon
            aikan.detailChaptersUrl = model.detailChaptersUrl
            aikan.bookLastChapterName = model.bookLastChapterName
            aikan.bookUpdateTime = model.bookUpdateTime
            aikan.bookUrl = model.bookUrl
            aikan.bookIcon = model.bookIcon
            aikan.bookDesc = model.bookDesc
            aikan.bookCategory = model.bookCategory
            aikan.bookAuthor = model.bookAuthor
            aikan.bookName = model.bookName
            aikan.books = model.books
            aikan.chaptersReverse = model.chaptersReverse
            aikan.detailBookDesc = model.detailBookDesc
            aikans.append(aikan)
        }
        return aikans
    }
    
    private func save() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!.appending("/source/")
        let filePath = path.appending("HtmlParserModelData_edit.dat")
        let isDirectory:UnsafeMutablePointer<ObjCBool>? = UnsafeMutablePointer.allocate(capacity: 1)
        if !FileManager.default.fileExists(atPath: path, isDirectory: isDirectory) {
            try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        NSKeyedArchiver.archiveRootObject(self.sources, toFile: filePath)
    }
    
    func add(source:ZSAikanParserModel) {
        if sources.contains(source) {
            modify(source: source)
        } else {
            sources.append(source)
            DispatchQueue.global().async {
                self.save()
            }
        }
    }
    
    func modify(source:ZSAikanParserModel) {
        var index = 0
        let ts = sources
        for ss in ts {
            if ss.host == source.host {
                sources[index] = source
                break
            }
            index += 1
        }
        DispatchQueue.global().async {
            self.save()
        }
    }
    
    func delete(source:ZSAikanParserModel) {
        var index = 0
        let ts = sources
        for ss in ts {
            if ss.host == source.host {
                sources.remove(at: index)
                break
            }
            index += 1
        }
        DispatchQueue.global().async {
            self.save()
        }
    }
    
    func select(source:ZSAikanParserModel) {
        source.checked = true
        replace(source: source)
        DispatchQueue.global().async {
            self.save()
        }
    }

    func unselect(source:ZSAikanParserModel) {
        source.checked = false
        replace(source: source)
        DispatchQueue.global().async {
            self.save()
        }
    }
    
    private func replace(source:ZSAikanParserModel) {
        var index = 0
        let ts = sources
        for ss in ts {
            if ss.host == source.host {
                sources[index] = source
                break
            }
            index += 1
        }
    }
}
