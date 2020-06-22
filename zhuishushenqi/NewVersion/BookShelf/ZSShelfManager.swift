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
    
    var aikanBooks:[String:ZSAikanParserModel] = [:]
    
    var localBooks:[ZSShelfModel] = []
    
    let helper = MonitorFileChangeHelp()
    
    var isScanning:Bool = false
    
    var queue:DispatchQueue = DispatchQueue(label: "com.shelf.update")
    
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
                let bookUrl = "\(NSHomeDirectory())/Documents/Inbox/\(fileFullName)\(txtPathExtension)"
                let localBookUrl = "\(NSHomeDirectory())/Documents/LocalBooks/\(fileFullName)\(txtPathExtension)"
                if !FileManager.default.fileExists(atPath: localBookUrl) {
                    try? FileManager.default.copyItem(atPath: bookUrl, toPath: localBookUrl)
                }
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
        let shelfModel = book.transformShelf()
        if add(shelfModel) {
            saveAikan(book)
        } else if modify(shelfModel) {
            saveAikan(book)
        }
    }
    
    func removeAikan(_ book:ZSAikanParserModel) {
        let shelfModel = book.transformShelf()
        if remove(shelfModel) {
            // save aikan
            saveAikan(book)
        }
    }
    
    func removeAikan(bookUrl:String) {
        let aikanFilePath = aikansPath(url: bookUrl)
        ZSShelfStorage.share.delete(path: aikanFilePath)
    }
    
    func modifyAikan(_ book:ZSAikanParserModel) {
        let shelfModel = book.transformShelf()
        if modify(shelfModel) {
            saveAikan(book)
        }
    }
    
    func aikan(_ shelf:ZSShelfModel, block: @escaping (_ aikan:ZSAikanParserModel?)->Void) {
        let aikanFilePath = aikansPath(url: shelf.bookUrl)
        if let aikanBook = aikanBooks[shelf.bookUrl] {
            if aikanBook.bookType == .local && aikanBook.chaptersModel.count == 0 {
                block(nil)
            } else {
                block(aikanBook)
            }
        } else {
            ZSShelfStorage.share.unarchive(path: aikanFilePath, block: { [weak self] result in
                if let aikanModel = result as? ZSAikanParserModel {
                    self?.aikanBooks[shelf.bookUrl] = aikanModel
                    block(aikanModel)
                } else {
                    block(nil)
                }
            })
        }
    }
    
    func history(_ bookUrl:String, block:@escaping (_ history:ZSReadHistory?)->Void) {
        let aikanFilePath = historyStorePath(url: bookUrl)
        ZSShelfStorage.share.unarchive(path: aikanFilePath, block: { result in
            if let history = result as? ZSReadHistory  {
                block(history)
            } else {
                block(nil)
            }
        })
    }
    
    func addHistory(_ history:ZSReadHistory)  {
        let aikanFilePath = historyStorePath(url: history.chapter.bookUrl)
        ZSShelfStorage.share.archive(obj: history, path: aikanFilePath)
    }
    
    func removeHistory(_ history:ZSReadHistory) {
        let aikanFilePath = historyStorePath(url: history.chapter.bookUrl)
        ZSShelfStorage.share.delete(path: aikanFilePath)
    }
    
    func removeHistory(bookUrl:String) {
        let aikanFilePath = historyStorePath(url: bookUrl)
        ZSShelfStorage.share.delete(path: aikanFilePath)
    }
    
    private func saveAikan(_ book:ZSAikanParserModel) {
        let aikanFilePath = aikansPath(url: book.bookUrl)
        ZSShelfStorage.share.archive(obj: book, path: aikanFilePath)
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
        let booksP = booksPath()
        ZSShelfStorage.share.archive(obj: self.books, path: booksP)
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
    
    private func aikansPath(url:String) ->String {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
        let booksPath = documentPath.appending("/\(shelfBooksPath)/")
        let aikanFileName = url.md5()
        let aikanFilePath = booksPath.appending(aikanFileName)
        return aikanFilePath
    }
    
    private func booksPath() ->String {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
        let booksPath = documentPath.appending("/\(shelfBooksPath)/\(shelfBooksPathKey.md5())")
        return booksPath
    }
    
    private func historyStorePath(url:String) ->String {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
        let booksHistoryPath = documentPath.appending("/\(shelfBooksHistoryPath)/")
        let aikanFileName = url.md5()
        let aikanFilePath = booksHistoryPath.appending(aikanFileName)
        return aikanFilePath
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
