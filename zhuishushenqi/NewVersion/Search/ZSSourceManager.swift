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
    
    var sources:[AikanParserModel] = []
    
    static let selectedSourceKey = "selectedSourceKey"
    
    static let share = ZSSourceManager()
    private init() {
        unpack()
    }
    
    private func unpack() {
        let modifyfilePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!.appending("/source/HtmlParserModelData_edit.dat")
        let originialfilePath = Bundle(for: ZSSourceManager.self).path(forResource: "HtmlParserModelData.dat", ofType: nil) ?? ""
        if let objs = NSKeyedUnarchiver.unarchiveObject(withFile: modifyfilePath) as? [AikanParserModel] {
            self.sources = objs
        } else if let objs = NSKeyedUnarchiver.unarchiveObject(withFile: originialfilePath) as? [AikanParserModel] {
            self.sources = objs
            save()
        }
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
    
    func add(source:AikanParserModel) {
        sources.append(source)
        DispatchQueue.global().async {
            self.save()
        }
    }
    
    func modify(source:AikanParserModel) {
        var index = 0
        let ts = sources.copy
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
    
    func delete(source:AikanParserModel) {
        var index = 0
        let ts = sources.copy
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
    
    func select(source:AikanParserModel) {
        source.checked = true
        replace(source: source)
        DispatchQueue.global().async {
            self.save()
        }
    }

    func unselect(source:AikanParserModel) {
        source.checked = false
        replace(source: source)
        DispatchQueue.global().async {
            self.save()
        }
    }
    
    private func replace(source:AikanParserModel) {
        var index = 0
        let ts = sources.copy
        for ss in ts {
            if ss.host == source.host {
                sources[index] = source
                break
            }
            index += 1
        }
    }
}
