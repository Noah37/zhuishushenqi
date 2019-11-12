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
        let filePath = Bundle(for: ZSSourceManager.self).path(forResource: "HtmlParserModelData.dat", ofType: nil) ?? ""
        if let objs = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [AikanParserModel] {
            self.sources = objs
        }
    }
    
    private func save() {
        let filePath = Bundle(for: ZSSourceManager.self).path(forResource: "HtmlParserModelData_edit.dat", ofType: nil) ?? ""
        NSKeyedArchiver.archiveRootObject(self.sources, toFile: filePath)
    }
    
    func add(source:AikanParserModel) {
        sources.append(source)
        save()
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
    }
    
    func select(source:AikanParserModel) {
        source.checked = true
        replace(source: source)
    }

    func unselect(source:AikanParserModel) {
        source.checked = false
        replace(source: source)
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
