//
//  BookManager.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2017/8/9.
//  Copyright © 2017年 QS. All rights reserved.
//

import Foundation

// 书籍信息保存类
public class ZSBookManager:NSObject {
    
    // 策略
    // 书架信息:保存书架书籍的所有id的list到本地
    // 根据id从本地文件中查询是否存在该书籍,如果不存在,从list中删除该id,如果存在,在内存中保存信息
    
    // 书架中书籍的id保存为list的key,对key取md5即为保存的文件名
    let ZSBookShelfIDSKey = "ZSBookShelfIDSKey"
    let ZSReadHistorySaveKey = "ZSReadHistorySaveKey"
    
    fileprivate static var _ids:[String] = []
    fileprivate static var _books:[String:BookDetail] = [:]
    
    // 书架的所有书籍的id
    var ids:[String] {
        get {
            let idsArr = booksID()
            return idsArr
        }
        set {
            saveBooksID(booksID: newValue)
        }
    }
    
    // 书架中的所有书籍的model,请勿使用set方法
    var books:[String:BookDetail] {
        get {
            let booksInfo = self.booksInfo()
            return booksInfo
        }
        set {
            saveBooks(books: newValue)
        }
    }
    
    var _diskQueue:DispatchQueue!
    
    static let shared = ZSBookManager()
    
    private override init() {
        super.init()
        ZSBookManager.calTime {
            QSLog(self.ids)
            QSLog(self.books)
        }
    }
    
    // 是否存在book
    func existBook(book:BookDetail) -> Bool {
        var exist:Bool = false
        for id in self.ids {
            if book._id == id {
                exist = true
            }
        }
        return exist
    }
    
    //MARK: - 添加,默认添加到尾部
    func addBook(book:BookDetail) {
        if existBook(book: book) {
            QSLog("\(book.title)已存在")
            return
        }
        self.ids.append(book._id)
        self.books[book._id] = book
    }
    
    //MARK: - 删除
    func deleteBook(book:BookDetail) {
        if !existBook(book: book) {
            QSLog("\(book.title)不存在")
            return
        }
        self.books.removeValue(forKey: book._id)
    }
    
    func update(updateInfo:[UpdateInfo]) {
        for update in updateInfo {
            if let book = self.books[update._id ?? ""] {
                if let updateStr = update.updated {
                    if updateStr != book.updateInfo?.updated {
                        book.isUpdated = true
                    }
                }
                book.updateInfo = update
                self.updateBook(book: book)
            }
        }
    }
    
    //MARK: - 更新
    func updateBook(book:BookDetail) {
        if !existBook(book: book) {
            QSLog("\(book.title)不存在")
            return
        }
        QSLog("\(book.title)更新成功")
        self.books[book._id] = book
    }
    
    //MARK: - books
    // 保存书籍信息
    fileprivate func saveBooks(books:[String:BookDetail]) {
//        var change:Bool = false
//        if books.count == ZSBookManager._books.count {
//            for (id,book) in books {
//                let boook = ZSBookManager._books[id]
//                if book.record?.chapter != boook?.record?.chapter || book.record?.page != boook?.record?.page {
//                    change = true
//                }
//            }
//            if !change {
//                return
//            }
//        }
        ZSBookManager._books = books
        for book in books {
            let path = NSHomeDirectory().appending("/Documents/ZSBookShelf/Books")
            let data = NSKeyedArchiver.archivedData(withRootObject: book.value)
            try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            let filePath = path.appending("/\(book.key.md5())")
            let success = FileManager.default.createFile(atPath: filePath, contents: data, attributes: nil)
            if success {
                QSLog("保存'\(book.value.title)'成功@_@")
            }
        }
    }
    
    // 获取所有的书籍信息
    fileprivate func booksInfo() -> [String:BookDetail] {
        if ZSBookManager._books.count > 0 {
            return ZSBookManager._books
        }
        var models:[String:BookDetail] = [:]
        for id in self.ids {
            let path = NSHomeDirectory().appending("/Documents/ZSBookShelf/Books").appending("/\(id.md5())")
            let url = URL(fileURLWithPath: path)
            if let data = try? Data(contentsOf: url, options: Data.ReadingOptions.alwaysMapped) {
                if let obj = NSKeyedUnarchiver.unarchiveObject(with: data) as? BookDetail {
                    models[id] = obj
                }
            }
        }
        ZSBookManager._books = models
        return models
    }
    
    //MARK: - ids
    // 保存书架List信息
    fileprivate func saveBooksID(booksID:[String]) {
        if booksID == ZSBookManager._ids  {
            return
        }
        ZSBookManager._ids = booksID
        let path = NSHomeDirectory().appending("/Documents/ZSBookShelf")
        let idString = booksID.joined(separator: ",")
        let data = idString.data(using: .utf8)
        try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        let filePath = path.appending("/\(ZSBookShelfIDSKey.md5())")
        let success = FileManager.default.createFile(atPath: filePath, contents: data, attributes: nil)
        if success {
            QSLog("书架List保存成功")
        }
    }
    
    // 如果ids存在,返回ids,如果不存在,读文件后保存到ids中,修改时页需要更新ids中的内容
    fileprivate func booksID() ->[String] {
        if ZSBookManager._ids.count > 0 {
            return ZSBookManager._ids
        }
        let path = NSHomeDirectory().appending("/Documents/ZSBookShelf").appending("/\(ZSBookShelfIDSKey.md5())")
        let url = URL(fileURLWithPath: path)
        if let data = try? Data(contentsOf: url, options: Data.ReadingOptions.alwaysMapped) {
            if let ids = String(data: data, encoding: .utf8) {
                let idArr = ids.components(separatedBy: ",")
                ZSBookManager._ids = idArr
                return idArr
            }
        }
        ZSBookManager._ids = []
        return []
    }
    
    // 计算耗时的方法
    static func calTime(_ action: @escaping () ->Void){
        let startTime = CFAbsoluteTimeGetCurrent()
        action()
        let linkTime = (CFAbsoluteTimeGetCurrent() - startTime)
        QSLog("Linked in \(linkTime * 1000.0) ms")
    }
    
   
}

// 由于采用数组时，每次遍历的时间会很长，无法快速保存，因此采用NSDictionary来保存书架中的书籍，key为对应的书籍的_id
// 书架信息只保存_id 数组，这样可以对书籍进行排序
// 根据_id从本地保存的数据中取出NSDictionary
// 每 一本书籍单独保存，避免读取时影响速度
// 该类为书架书籍管理类，管理书架上的书籍的信息，缓存等
public class BookManager:NSObject {
    let bookshelfSaveKey = "bookshelfSaveKey"
    let readHistorySaveKey = "readHistorySaveKey"
    
    let zsbookshelvesSaveKey = "zsbookshelvesSaveKey"
    let zshistorysavekey = "zshistorysavekey"

    var _diskQueue:DispatchQueue!
    
    static let shared = BookManager()
    
    private override init() {
        super.init()
        
        BookManager.calTime {
            //在这写入要计算时间的代码
            self.booksID = self.bookshelf()
            
            self.books = [String:Any]()
            for bookId in self.booksID {
                let bookInfo = self.bookInfo(id: bookId)
                self.books[bookId] = bookInfo
            }
        }
    }
    
    static func calTime(_ action: @escaping () ->Void){
        let startTime = CFAbsoluteTimeGetCurrent()
        action()
        let linkTime = (CFAbsoluteTimeGetCurrent() - startTime)
        QSLog("Linked in \(linkTime * 1000.0) ms")
    }
    
    // key为_id,value 为BookDetail
    var books:[String:Any]!
    
    // booksID 为所有的书籍的id
    var booksID:[String]!
    
    func bookExist(book:BookDetail?) ->Bool {
        if books[book?._id ?? ""] != nil {
            return true
        }
        return false
    }
    
    // 更新bookdetail的信息,bookdetail的数组与updateinfo数组是一一对应的
    func updateInfoUpdate(updateInfo:[UpdateInfo]){
        if updateInfo.count != books.allKeys().count {
            return
        }
        for index in 0..<books.allKeys().count {
            let key = books.allKeys()[index]
            if let bookDetail = books[key] as? BookDetail {
                let updateObj = updateInfo[index]
                if anyUpdate(bookInfo: bookDetail.updateInfo, updateInfo: updateObj) {
                    bookDetail.isUpdated = true
                }
                bookDetail.updateInfo = updateInfo[index]
            }
        }
    }
    
    //需要将对应的update信息赋给model
    func updateToModel(updateModels:[UpdateInfo]){
        for updateModel in updateModels {
            let id = updateModel._id ?? ""
            let book:BookDetail? = books[id] as? BookDetail
            if let model = book  {
                // 如果updateInfo已存在，则比较是否有更新
                if anyUpdate(bookInfo: model.updateInfo, updateInfo: updateModel) {
                    model.isUpdated = true
                }
                model.updateInfo = updateModel
                books[model._id] = model
            }
        }
    }
    
    func anyUpdate(bookInfo:UpdateInfo?,updateInfo:UpdateInfo)->Bool{
        if let updatedString = bookInfo?.updated {
            if updatedString != updateInfo.updated {
                return true
            }
        }
        return false
    }
    
    // 删除书籍时，只删除记录，缓存的书籍信息保留
    func deleteBook(book:BookDetail){
        removeBook(book: book)
        saveBooksID()
    }
    
    func removeBook(book:BookDetail){
        if let books:[String] = self.booksID {
            var index = 0
            for bookid in books {
                if book._id == bookid {
                    self.booksID?.remove(at: index)
                    self.books?.removeValue(forKey: bookid)
                }
                index += 1
            }
        }
    }
    
    // 更新书架中保存的书籍信息，从内存更新
    @discardableResult
    func modifyBookshelf(book:BookDetail)->[String:Any]{
        var tmpBook = books["\(book._id)"]
        if let _ = tmpBook{
            tmpBook = book
            books["\(book._id)"] = tmpBook!
        } else {
            // 书籍不存在，则添加
            books["\(book._id)"] = book
        }
        DispatchQueue.global().async {
            // 持久化时，章节内容置为空
            book.book.chapters = [QSChapter()]
            self.addBookInfo(info: book)
        }
        return books
    }
    
    // 更新书架中保存的书籍信息,当用户同意添加到书架时才会调用这个方法
    // 首次安装推荐时获取的书籍列表
    func modifyBookshelf(books:[BookDetail]?){
        if let models = books {
            for model in models {
                modifyBookshelf(book: model)
            }
        }
    }
    
    // 更新书籍的记录
    func modifyRecord(_ book:BookDetail,_ chapter:Int?,_ page:Int?) {
        modifyRecord(book, chapter, page, nil)
    }
    
    func modifyRecord(_ book:BookDetail,_ chapter:Int?,_ page:Int?,_ bookId:String?) {
        books[book._id] = book
        DispatchQueue.global().async {
            // 持久化时，章节内容置为空,避免内容过大
            book.book.chapters = [QSChapter()]
            self.saveBookInfo(info: book)
        }
    }
    
    // 数据持久化
    func saveBookshelf(shelf:BookDetail){
        self.booksID.append(shelf._id)
        let data = NSKeyedArchiver.archivedData(withRootObject: shelf)
        setData(data: data, forKey: bookshelfSaveKey)
    }
    
    public func bookshelf()->[String]{
        let data = qs_data(forKey: bookshelfSaveKey)
        if let bookData = data {
            
            let obj = NSKeyedUnarchiver.unarchiveObject(with: bookData) as? [String]
            return obj ?? []
        }
        return []
    }
    
    func localBookInfo(key:String)->BookDetail?{
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last?.appending("/\(key)")
        let url = URL(fileURLWithPath: path ?? "www.baidu.com")
        if let data = try? Data(contentsOf: url, options: Data.ReadingOptions.mappedIfSafe) {
            let obj = NSKeyedUnarchiver.unarchiveObject(with: data) as? BookDetail
            return obj
        }
        return nil
    }
    
    // 从本地根据id获取书籍的信息
    func bookInfo(id:String) ->BookDetail?{
        let data = qs_data(forKey: id)
        if let bookData = data {
            let obj = NSKeyedUnarchiver.unarchiveObject(with: bookData) as? BookDetail
            books[id] = obj
            return obj
        }
        return nil
    }
    
    //MARK: - 浏览记录
    func readHistory()->[BookDetail]{
        if let data = qs_data(forKey: readHistorySaveKey) {
            if let books = NSKeyedUnarchiver.unarchiveObject(with: data) as? [BookDetail] {
                return books
            }
        }
        return []
    }
    
    // 数组中是否存在当前书籍，以id作为标志
    func bookExist(book:BookDetail,at:[BookDetail])->Bool{
        var exist = false
        for model in at {
            if model._id == book._id {
                exist = true
            }
        }
        return exist
    }
    
    func addReadHistory(book:BookDetail){
        // 先匹配
        var history = readHistory()
        if !bookExist(book: book, at: history) {
            history.insert(book, at: 0)
            let data = NSKeyedArchiver.archivedData(withRootObject: history)
            setData(data: data, forKey: readHistorySaveKey)
        }
    }
    
    //MARK: - 添加书籍保存
    func addBook(book:BookDetail){
        addBookID(book: book)
        addBookInfo(info: book)
    }
    
    func addBookID(book:BookDetail){
        if book._id != ""{
            self.booksID.append(book._id)
            saveBooksID()
        }
    }
    
    // 将书籍对应的BookDetail 模型存储到沙盒
    func addBookInfo(info:BookDetail){
        if info._id != ""{
            self.books[info._id] = info
            saveBookInfo(info: info)
        }
    }
    
    func saveBookInfo(info:BookDetail) {
        let data = NSKeyedArchiver.archivedData(withRootObject: info)
        setData(data: data, forKey: info._id)
    }
    
    func saveBooksID(){
        let booksData = NSKeyedArchiver.archivedData(withRootObject: self.booksID)
        setData(data: booksData, forKey: bookshelfSaveKey)
    }
    
    //MARK: -  数据持久化方法
    func qs_data(forKey:String) ->Data?{
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last?.appending("/\(forKey.md5())")
        let url = URL(fileURLWithPath: path ?? "www.baidu.com")
        let data = try? Data(contentsOf: url, options: Data.ReadingOptions.mappedIfSafe)
        return data
    }
    
    func setData(data:Data,forKey:String){
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last?.appending("/\(forKey.md5())")
        if _diskQueue == nil {
            let label = "com.norycao.zhuishushenqi.disk"
            let qos =  DispatchQoS.default
            let attributes = DispatchQueue.Attributes.concurrent
            let autoreleaseFrequency:DispatchQueue.AutoreleaseFrequency!
            if #available(iOS 10.0, *) {
                autoreleaseFrequency = DispatchQueue.AutoreleaseFrequency.never
            } else {
                // Fallback on earlier versions
                autoreleaseFrequency = DispatchQueue.AutoreleaseFrequency.inherit
            }
            _diskQueue = DispatchQueue(label: label, qos: qos, attributes: attributes, autoreleaseFrequency: autoreleaseFrequency, target: nil)
        }

        _diskQueue.async {
            let url = URL(fileURLWithPath: path ?? "www.baidu.com")
            do{
                try data.write(to: url)
            }catch let error {
                QSLog(error)
            }
        }
    }
    
}
