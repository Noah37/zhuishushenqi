//
//  ZSShelfManager.swift
//  zhuishushenqi
//
//  Created by caony on 2020/1/8.
//  Copyright © 2020 QS. All rights reserved.
//

import UIKit
import HandyJSON
import YungCache

class ZSShelfManager {
    
    private let shelfBooksPath = "bookshelf"
    private let shelfBooksPathKey = "shelfBooksPathKey"
    private let shelfBooksHistoryPath = "bookshelf/history"
    
    static let share = ZSShelfManager()
    
    let booksCache:Cache<Data>
    let shelfsCache:Cache<Data>
    
    // 每个book的localPath
    var books:[String] = [] {
        didSet {
            booksCache.setObjs(books, forKey: shelfBooksPath)
        }
    }

    var aikanBooks:[String:ZSAikanParserModel] = [:]
    
    var localBooks:[ZSShelfModel] = []
    
    let helper = MonitorFileChangeHelp()
    
    var isScanning:Bool = false
    
    var queue:DispatchQueue = DispatchQueue(label: "com.shelf.update")
    
    private init(){
        booksCache = Cache<Data>(path: shelfBooksPath)
        shelfsCache = Cache<Data>(path: "\(shelfBooksPath)/books")
        createPath()
        unpackBooksFile()
        local()
    }
    
    func unpackBooksFile() {
        if let books:[String] = booksCache.getObj(forKey: shelfBooksPath) {
            self.books = books.filterDuplicates({$0})
            for bookPath in books {
                let fullPath = shelfModelPath(url: bookPath)
                let _:ZSShelfModel? = shelfsCache.getObj(forKey: fullPath)
            }
        }
    }
    
    func saveShelfModel(shelf:ZSShelfModel) {
        shelfsCache.setObj(shelf, forKey: "\(shelf.bookUrl)")
    }
    
    func getShelfModel(bookPath:String)->ZSShelfModel? {
        if let shelf:ZSShelfModel = shelfsCache.getObj(forKey: "\(bookPath)") {
           return shelf
        }
        return nil
    }
    
    func removeBook(bookPath:String) {
        let bookPath = shelfModelPath(url: bookPath)
        shelfsCache.removeObject(forKey: bookPath.asNSString())
    }
    
    func refresh() {
        let path = ZSShelfConstant.inboxPath
        scanPath(path: path)
    }
    
    func local() {
        let path = ZSShelfConstant.inboxPath
        let localPath = ZSShelfConstant.localBooksPath
        let isDirectory:UnsafeMutablePointer<ObjCBool>? = UnsafeMutablePointer.allocate(capacity: 1)
        let localPathExist = FileManager.default.fileExists(atPath: localPath, isDirectory: isDirectory)
        if !localPathExist {
            try? FileManager.default.createDirectory(atPath: localPath, withIntermediateDirectories: true, attributes: nil)
        }
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
        if let items = try? FileManager.default.contentsOfDirectory(atPath: path)  {
            for item in items {
                let filePath = path.appending("\(item)")
                let txtPathExtension = ".txt"
                if filePath.hasSuffix(txtPathExtension) {
                    let fileFullName = filePath.nsString.lastPathComponent.replacingOccurrences(of: txtPathExtension, with: "")
                    let bookUrl = "\(ZSShelfConstant.inboxPath)\(fileFullName)\(txtPathExtension)"
                    let localBookUrl = "\(ZSShelfConstant.localBooksPath)\(fileFullName)\(txtPathExtension)"
                    if !FileManager.default.fileExists(atPath: localBookUrl) {
                        
                        try? FileManager.default.copyItem(atPath: bookUrl, toPath: localBookUrl)
                    }
                }
            }
        }
        localBooks.removeAll()
        let localPath = ZSShelfConstant.localBooksPath
        guard let localItems = try? FileManager.default.contentsOfDirectory(atPath: localPath) else {
            isScanning = false
            return
        }
        for item in localItems {
            let filePath = path.appending("\(item)")
            let txtPathExtension = ".txt"
            if filePath.hasSuffix(txtPathExtension) {
                let fileFullName = filePath.nsString.lastPathComponent.replacingOccurrences(of: txtPathExtension, with: "")
                let localBookUrl = "\(ZSShelfConstant.localBooks)\(fileFullName)\(txtPathExtension)"
                let shelf = ZSShelfModel()
                shelf.bookType = .local
                shelf.bookName = fileFullName
                shelf.bookUrl = localBookUrl
                if !localBooks.contains(shelf) {
                    localBooks.append(shelf)
                }
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
                return model == bookUrl
            }
            try? FileManager.default.removeItem(atPath:"\(NSHomeDirectory())\(bookUrl)")
            save()
            refresh()
        }
    }
    
    @discardableResult
    func add(_ book:ZSShelfModel) ->Bool {
        if !exist(book.bookUrl) {
            books.append(book.bookUrl)
            saveShelfModel(shelf: book)
            return true
        }
        return false
    }
    
    @discardableResult
    func remove(_ book:ZSShelfModel) ->Bool {
        let exitIndex = index(book.bookUrl)
        if exitIndex >= 0 && exitIndex < books.count {
            books.remove(at: exitIndex)
            removeBook(bookPath: book.bookUrl)
            return true
        }
        return false
    }
    
    @discardableResult
    func remove(_ bookUrl:String) ->Bool {
        var index = 0
        for book in books {
            if book == bookUrl {
                books.remove(at: index)
                break
            }
            index += 1
        }
        return true
    }
    
    @discardableResult
    func modify(_ book:ZSShelfModel) ->Bool {
        let exitIndex = index(book.bookUrl)
        if exitIndex >= 0 && exitIndex < books.count {
            books.remove(at: exitIndex)
            books.insert(book.bookUrl, at: exitIndex)
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
        }
    }
    
    func exist(_ bookUrl:String) ->Bool {
        var exist = false
        for bk in self.books {
            if bk == bookUrl {
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
            if bk == book.bookUrl {
                exist = true
                break
            }
        }
        return exist
    }
    
    func addAikan(_ book:ZSAikanParserModel) {
        let shelfModel = book.transformShelf()
        if add(shelfModel) {
            setAikan(model: book) { (result) in
                
            }
        } else if modify(shelfModel) {
            setAikan(model: book) { (result) in
                
            }
        }
    }
    
    func removeAikan(_ book:ZSAikanParserModel) {
        let shelfModel = book.transformShelf()
        if remove(shelfModel) {
            // save aikan
            let aikanFilePath = aikansPath(url: book.bookUrl)
            booksCache.removeObject(forKey: aikanFilePath.asNSString())
        }
    }
    
    func removeAikan(bookUrl:String) {
        let aikanFilePath = aikansPath(url: bookUrl)
        booksCache.removeObject(forKey: aikanFilePath.asNSString())
    }
    
    func modifyAikan(_ book:ZSAikanParserModel) {
        let bookPath = shelfModelPath(url: book.bookUrl)
        func updateAikan(shelf:ZSShelfModel, book:ZSAikanParserModel) {
            if modify(shelf) {
                setAikan(model: book) { (result) in
                    
                }
            }
        }
        if let shelf:ZSShelfModel = shelfsCache.getObj(forKey: book.bookUrl) {
            let shelf = book.updateShelf(shelf: shelf)
            saveShelfModel(shelf: shelf)
            updateAikan(shelf: shelf, book: book)
        } else {
            let shelfModel = book.transformShelf()
            updateAikan(shelf: shelfModel, book: book)
        }
    }
    
    func getAikanModel(_ shelf:ZSShelfModel, block: @escaping (_ aikan:ZSAikanParserModel?)->Void)  {
        let queue = DispatchQueue(label: "com.getaikanQueue", qos: DispatchQoS.default, attributes: DispatchQueue.Attributes.concurrent)
        queue.async {
            let aikan:ZSAikanParserModel? = self.booksCache.getObj(forKey: shelf.bookUrl)
            DispatchQueue.main.async {
                block(aikan)
            }
        }
    }
    
    func setAikan(model: ZSAikanParserModel, block: @escaping (_ aikan:Bool)->Void) {
        booksCache.setObj(model, forKey: model.bookUrl)
        DispatchQueue.main.async {
            block(true)
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
    
    private func save() {
        let booksP = booksPath()
        let queue = DispatchQueue(label: "com.saveshelfQueue", qos: DispatchQoS.default, attributes: DispatchQueue.Attributes.concurrent)
        queue.async {
            self.booksCache.setObjs(self.books, forKey: booksP)
        }
    }
    
    private func index(_ bookPath:String) ->Int {
        var index = 0
        var exitIndex = -1
        for bk in self.books {
            if bk == bookPath {
                exitIndex = index
                break
            }
            index += 1
        }
        return exitIndex
    }
    
    private func shelfModelPath(url:String) ->String {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
        let booksPath = documentPath.appending("/\(shelfBooksPath)/books/")
        let aikanFileName = url.md5()
        let aikanFilePath = booksPath.appending(aikanFileName)
        if !FileManager.default.fileExists(atPath: booksPath, isDirectory: nil) {
            try? FileManager.default.createDirectory(atPath: booksPath, withIntermediateDirectories: true, attributes: nil)
        }
        return aikanFilePath
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

class ZSShelfConstant {
    static let inboxPath = "\(NSHomeDirectory())/Documents/Inbox/"
    static let localBooksPath = "\(NSHomeDirectory())/Documents/LocalBooks/"
    static let localBooks = "/Documents/LocalBooks/"
}

extension Array where Element:ZSShelfModel {
    func contains(_ element: Element) -> Bool {
        if self.count == 0 {
            return false
        }
        var contain:Bool = false
        for item in self {
            if item.bookUrl == element.bookUrl {
                contain = true
                break
            }
        }
        return contain
    }
}
