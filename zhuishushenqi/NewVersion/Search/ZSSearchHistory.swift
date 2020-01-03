//
//  ZSSearchHistory.swift
//  zhuishushenqi
//
//  Created by caony on 2020/1/3.
//  Copyright © 2020 QS. All rights reserved.
//

import UIKit

class ZSSearchHistory:Equatable , NSCoding{
    
    var word:String = ""
    var timeInterval:TimeInterval = 0
    
    func encode(with coder: NSCoder) {
        coder.encode(word, forKey: "word")
        coder.encode(timeInterval, forKey: "timeInterval")
    }
    
    init() {
        
    }

    required init?(coder: NSCoder) {
        word = coder.decodeObject(forKey: "word") as? String ?? ""
        timeInterval = coder.decodeDouble(forKey: "timeInterval")
    }
    
    static func == (lhs: ZSSearchHistory, rhs: ZSSearchHistory) -> Bool {
        return lhs.word == rhs.word && lhs.timeInterval == rhs.timeInterval
    }
    
}

class ZSHistoryManager {
    static let share = ZSHistoryManager()
    
    var historyList:[ZSSearchHistory] = []
    
    private let saveFileName = "history"
        
    private init() {
        unpack()
    }
    
    func add(word:String) {
        let date = Date().timeIntervalSince1970
        let history = ZSSearchHistory()
        history.word = word
        history.timeInterval = date
        if historyList.contains(where: { (model) -> Bool in
            return model.word == history.word
        }) {
            if let index = historyList.firstIndex(of: history) {
                historyList.remove(at: index)
            }
        }
        historyList.append(history)
        DispatchQueue.global().async {
            self.pack()
        }
    }
    
    func remove(word:String) {
        let date = Date().timeIntervalSince1970
        let history = ZSSearchHistory()
        history.word = word
        history.timeInterval = date
        if let index = historyList.firstIndex(of: history) {
            historyList.remove(at: index)
            DispatchQueue.global().async {
                self.pack()
            }
        }
    }
    
    private func unpack() {
        let savePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!.appending("/history/")
        let saveFilePath = savePath.appending(saveFileName.md5())
        if let historyList = NSKeyedUnarchiver.unarchiveObject(withFile: saveFilePath) as? [ZSSearchHistory] {
            self.historyList = historyList
        }
    }
    
    private func pack() {
        let savePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!.appending("/history/")
        let saveFilePath = savePath.appending(saveFileName.md5())
        if !FileManager.default.fileExists(atPath: savePath, isDirectory: nil) {
            try? FileManager.default.createDirectory(atPath: savePath, withIntermediateDirectories: true, attributes: nil)
        }
        NSKeyedArchiver.archiveRootObject(historyList, toFile: saveFilePath)
    }
}
