//
//  ZSShelfManager.swift
//  zhuishushenqi
//
//  Created by caony on 2020/1/8.
//  Copyright © 2020 QS. All rights reserved.
//

import UIKit
import HandyJSON

class ZSShelfManager {
    
    private let shelfBooksPath = "bookshelf"
    private let shelfBooksPathKey = "shelfBooksPathKey"
    private let shelfBooksHistoryPath = "bookshelf/history"
    
    static let share = ZSShelfManager()
    
    var books:[ZSShelfModel] = []
    
    var localBooks:[ZSShelfModel] = []
    
    let helper = MonitorFileChangeHelp()
    
    var isScanning:Bool = false
    
    private init(){
        createPath()
        unpack()
        local()
    }
    
    func refresh() {
        let path = "\(NSHomeDirectory())/Documents/Inbox/"
        scanPath(path: path)
    }
    
    func local() {
        let path = "\(NSHomeDirectory())/Documents/Inbox/"
        scanPath(path: path)
        helper.watcher(forPath: path) { [weak self] (type) in
            self?.scanPath(path: path)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(localChangeNoti(noti:)), name: NSNotification.Name.LocalShelfChanged, object: nil)
    }
    
    func scanPath(path:String){
        if isScanning {
            return
        }
        isScanning = true
        guard let items = try? FileManager.default.contentsOfDirectory(atPath: path) else { return }
        for item in items {
            let filePath = path.appending("\(item)")
            let txtPathExtension = ".txt"
            if filePath.hasSuffix(txtPathExtension) {
                let fileFullName = filePath.nsString.lastPathComponent.replacingOccurrences(of: txtPathExtension, with: "")
                let bookUrl = "/Documents/Inbox/\(fileFullName)\(txtPathExtension)"
                let localBookUrl = "/Documents/LocalBooks/\(fileFullName)\(txtPathExtension)"
                try? FileManager.default.copyItem(atPath: bookUrl, toPath: localBookUrl)
            }
        }
        let localPath = "\(NSHomeDirectory())/Documents/LocalBooks/"
        guard let localItems = try? FileManager.default.contentsOfDirectory(atPath: localPath) else { return }
        for item in localItems {
            let filePath = path.appending("\(item)")
            let txtPathExtension = ".txt"
            if filePath.hasSuffix(txtPathExtension) {
                let fileFullName = filePath.nsString.lastPathComponent.replacingOccurrences(of: txtPathExtension, with: "")
                let localBookUrl = "/Documents/LocalBooks/\(fileFullName)\(txtPathExtension)"
                if !exist(localBookUrl) {
                    let shelf = ZSShelfModel()
                    shelf.bookType = .local
                    shelf.bookName = fileFullName
                    shelf.bookUrl = localBookUrl
                    books.append(shelf)
                }
            }
        }
        
        
        localBooks.removeAll()
        for book  in books {
            if book.bookType == .local {
                localBooks.append(book)
            }
        }
        isScanning = false
        NotificationCenter.default.post(name: .ShelfChanged, object: nil)
    }
    
    //MARK: - local handler
    @objc
    private func localChangeNoti(noti:Notification) {
        refresh()
    }
    
    func removeLocalBook(bookUrl:String) {
        if exist(bookUrl) {
            books.removeAll { (model) -> Bool in
                return model.bookUrl == bookUrl
            }
            try? FileManager.default.removeItem(atPath:"\(NSHomeDirectory())\(bookUrl)")
            save()
            refresh()
        }
    }
    
    @discardableResult
    func add(_ book:ZSShelfModel) ->Bool {
        if !exist(book) {
            books.append(book)
            save()
            return true
        }
        return false
    }
    
    @discardableResult
    func remove(_ book:ZSShelfModel) ->Bool {
        let exitIndex = index(book)
        if exitIndex >= 0 && exitIndex < books.count {
            books.remove(at: exitIndex)
            save()
            return true
        }
        return false
    }
    
    @discardableResult
    func remove(_ bookUrl:String) ->Bool {
        var index = 0
        for book in books {
            if book.bookUrl == bookUrl {
                books.remove(at: index)
                break
            }
            index += 1
        }
        return true
    }
    
    @discardableResult
    func modify(_ book:ZSShelfModel) ->Bool {
        let exitIndex = index(book)
        if exitIndex >= 0 && exitIndex < books.count {
            books.remove(at: exitIndex)
            books.insert(book, at: exitIndex)
            save()
            return true
        }
        return false
    }
    
    func change(from:Int, to:Int) {
        if from >= books.count || from < 0 {
            return
        }
        if to >= books.count || to < 0 {
            return
        }
        if from == to {
            return
        }
        let book = books[from]
        if remove(book) {
            books.insert(book, at: to)
            save()
        }
    }
    
    func exist(_ bookUrl:String) ->Bool {
        var exist = false
        for bk in self.books {
            if bk.bookUrl == bookUrl {
                exist = true
                break
            }
        }
        return exist
    }
    
    func exist(_ bookUrl:String, at:[ZSShelfModel]) ->Bool {
        var exist = false
        for bk in at {
            if bk.bookUrl == bookUrl {
                exist = true
                break
            }
        }
        return exist
    }
    
    func exist(_ book:ZSShelfModel) -> Bool {
        var exist = false
        for bk in self.books {
            if bk.bookUrl == book.bookUrl {
                exist = true
                break
            }
        }
        return exist
    }
    
    func addAikan(_ book:ZSAikanParserModel) {
        let shelfModel = ZSShelfModel()
        shelfModel.icon = book.bookIcon.length > 0 ? book.bookIcon:book.detailBookIcon
        shelfModel.bookName = book.bookName
        shelfModel.author = book.bookAuthor
        shelfModel.bookUrl = book.bookUrl
        shelfModel.bookType = book.bookType
        if add(shelfModel) {
            saveAikan(book)
        } else if modify(shelfModel) {
            saveAikan(book)
        }
    }
    
    func removeAikan(_ book:ZSAikanParserModel) {
        let shelfModel = ZSShelfModel()
        shelfModel.icon = book.bookIcon.length > 0 ? book.bookIcon:book.detailBookIcon
        shelfModel.bookName = book.bookName
        shelfModel.author = book.bookAuthor
        shelfModel.bookUrl = book.bookUrl
        shelfModel.bookType = book.bookType
        if remove(shelfModel) {
            // save aikan
            saveAikan(book)
        }
    }
    
    func removeAikan(bookUrl:String) {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
        let booksPath = documentPath.appending("/\(shelfBooksPath)/")
        let aikanFileName = bookUrl.md5()
        let aikanFilePath = booksPath.appending(aikanFileName)
        try? FileManager.default.removeItem(atPath: aikanFilePath)
    }
    
    func modifyAikan(_ book:ZSAikanParserModel) {
        let shelfModel = ZSShelfModel()
        shelfModel.icon = book.bookIcon.length > 0 ? book.bookIcon:book.detailBookIcon
        shelfModel.bookName = book.bookName
        shelfModel.author = book.bookAuthor
        shelfModel.bookUrl = book.bookUrl
        shelfModel.bookType = book.bookType
        shelfModel.update = book.update
        shelfModel.latestChapterName = book.latestChapterName
        if modify(shelfModel) {
            saveAikan(book)
        }
    }
    
    func aikan(_ shelf:ZSShelfModel) ->ZSAikanParserModel? {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
        let booksPath = documentPath.appending("/\(shelfBooksPath)/")
        let bookUrl = shelf.bookUrl
        let aikanFileName = bookUrl.md5()
        let aikanFilePath = booksPath.appending(aikanFileName)
        if let aikanModel = NSKeyedUnarchiver.unarchiveObject(withFile: aikanFilePath) as? ZSAikanParserModel {
            self.saveAikan(aikanModel)
            return aikanModel
        } else {
            let aikanURL = URL(fileURLWithPath: aikanFilePath)
            if let data = try? Data(contentsOf: aikanURL) {
                let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any]
                let aikanModel = ZSAikanParserModel.deserialize(from: json)
                return aikanModel
            }
        }
        return nil
    }
    
    func history(_ bookUrl:String) ->ZSReadHistory? {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
        let booksHistoryPath = documentPath.appending("/\(shelfBooksHistoryPath)/")
        let aikanFileName = bookUrl.md5()
        let aikanFilePath = booksHistoryPath.appending(aikanFileName)
        if let aikanModel = NSKeyedUnarchiver.unarchiveObject(withFile: aikanFilePath) as? ZSReadHistory {
            return aikanModel
        } else {
            let aikanURL = URL(fileURLWithPath: aikanFilePath)
            if let data = try? Data(contentsOf: aikanURL) {
                let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any]
                let readModel = ZSReadHistory.deserialize(from: json)
                return readModel
            }
        }
        return nil
    }
    
    func addHistory(_ history:ZSReadHistory)  {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
        let booksHistoryPath = documentPath.appending("/\(shelfBooksHistoryPath)/")
        let aikanFileName = history.chapter.bookUrl.md5()
        let aikanFilePath = booksHistoryPath.appending(aikanFileName)
        if let json = history.toJSON() {
            if let data:NSData = try? JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.fragmentsAllowed) as NSData {
                data.write(toFile: aikanFilePath, atomically: true)
            }
        }
    }
    
    func removeHistory(_ history:ZSReadHistory) {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
        let booksHistoryPath = documentPath.appending("/\(shelfBooksHistoryPath)/")
        let aikanFileName = history.chapter.bookUrl.md5()
        let aikanFilePath = booksHistoryPath.appending(aikanFileName)
        try? FileManager.default.removeItem(atPath: aikanFilePath)
    }
    
    func removeHistory(bookUrl:String) {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
        let booksHistoryPath = documentPath.appending("/\(shelfBooksHistoryPath)/")
        let aikanFileName = bookUrl.md5()
        let aikanFilePath = booksHistoryPath.appending(aikanFileName)
        try? FileManager.default.removeItem(atPath: aikanFilePath)
    }
    
    private func saveAikan(_ book:ZSAikanParserModel) {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
        let booksPath = documentPath.appending("/\(shelfBooksPath)/")
        let bookUrl = book.bookUrl
        let aikanFileName = bookUrl.md5()
        let aikanFilePath = booksPath.appending(aikanFileName)
        if let json = book.toJSON() {
            if let data:NSData = try? JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.fragmentsAllowed) as NSData {
                data.write(toFile: aikanFilePath, atomically: true)
            }
        }
    }
    
    private func unpack() {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
        let booksPath = documentPath.appending("/\(shelfBooksPath)/\(shelfBooksPathKey.md5())")
        if let objs = NSKeyedUnarchiver.unarchiveObject(withFile: booksPath) as? [ZSShelfModel] {
            self.books = objs
        } else {
            let booksUrl = URL(fileURLWithPath: booksPath)
            if let data = try? Data(contentsOf: booksUrl) {
                let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [[String:Any]]
                if let shelfs = [ZSShelfModel].deserialize(from: json) as? [ZSShelfModel] {
                    self.books = shelfs
                }
            }
        }
    }
    
    private func save() {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
        let booksPath = documentPath.appending("/\(shelfBooksPath)/\(shelfBooksPathKey.md5())")
        let json = self.books.toJson()
        if let data:NSData = try? JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.fragmentsAllowed) as NSData {
            data.write(toFile: booksPath, atomically: true)
        }
    }
    
    private func index(_ book:ZSShelfModel) ->Int {
        var index = 0
        var exitIndex = -1
        for bk in self.books {
            if bk.bookUrl == book.bookUrl {
                exitIndex = index
                break
            }
            index += 1
        }
        return exitIndex
    }
    
    private func createPath() {
        let fileManager = FileManager.default
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
        let booksPath = documentPath.appending("/\(shelfBooksPath)/")
        var pointer:UnsafeMutablePointer<ObjCBool>?
        if !fileManager.fileExists(atPath: booksPath, isDirectory: pointer) {
            try? fileManager.createDirectory(atPath: booksPath, withIntermediateDirectories: true, attributes: nil)
        }
        let historyPath = documentPath.appending("/\(shelfBooksHistoryPath)")
        if !fileManager.fileExists(atPath: historyPath, isDirectory: pointer) {
            try? fileManager.createDirectory(atPath: historyPath, withIntermediateDirectories: true, attributes: nil)
        }
        
    }
}

class ZSShelfModel: NSObject,NSCoding, HandyJSON {
    
    var icon:String = ""
    var bookName:String = ""
    var author:String = ""
    // 根据url查找对应的model
    var bookUrl:String = ""
    // 是否更新
    var update:Bool = false
    // 最近更新章节
    var latestChapterName:String = ""
    
    // 是否本地书籍
    var bookType:ZSReaderBookStyle = .online
    
    required override init() {
        
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.icon, forKey: "icon")
        coder.encode(self.bookName, forKey: "bookName")
        coder.encode(self.author, forKey: "author")
        coder.encode(self.bookUrl, forKey: "bookUrl")
        coder.encode(self.bookType.rawValue, forKey: "bookType")
        coder.encode(self.update, forKey: "update")
        coder.encode(self.latestChapterName, forKey: "latestChapterName")
    }
    
    required init?(coder: NSCoder) {
        self.icon = coder.decodeObject(forKey: "icon") as? String ?? ""
        self.bookName = coder.decodeObject(forKey: "bookName") as? String ?? ""
        self.author = coder.decodeObject(forKey: "author") as? String ?? ""
        self.bookUrl = coder.decodeObject(forKey: "bookUrl") as? String ?? ""
        self.bookType = ZSReaderBookStyle(rawValue: coder.decodeInteger(forKey: "bookType")) ?? .online
        self.update = coder.decodeBool(forKey: "update")
        self.latestChapterName = coder.decodeObject(forKey: "latestChapterName") as? String ?? ""
    }
}
