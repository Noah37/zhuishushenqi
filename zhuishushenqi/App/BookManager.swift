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
    let ZSReadHistorySaveIDKey = "ZSReadHistorySaveKey"
    let ZSReadHistoryBooksKey = "ZSReadHistoryBooksKey"
    
    fileprivate static var _ids:[String] = []
    fileprivate static var _books:[String:BookDetail] = [:]
    fileprivate static var _historyIds:[String] = []
    fileprivate static var _historyBooks:[String:BookDetail] = [:]
    
    // 书架的所有书籍的id
    var ids:[String] {
        get {
            return booksID()
        }
        set {}
    }
    
    // 书架中的所有书籍的model,请勿使用set方法
    var books:[String:BookDetail] {
        get {
            return booksInfo()
        }
        set {}
    }
    
    /// 阅读历史
    var historyBooks:[String:BookDetail] {
        get {
            return historyBooksInfo()
        }
        set {}
    }
    
    var historyIds:[String] {
        get {
            return historyBooksID()
        }
        set {}
    }
    
    var _diskQueue:DispatchQueue!
    
    static let shared = ZSBookManager()
    
    private override init() {
        super.init()
        ZSBookManager.calTime {
            ZSBookManager._ids = ZSBookManager._ids.filterDuplicates({$0})
            let ids = ZSBookManager._ids
            var index = 0
            for id in ids {
                if id == "" {
                    ZSBookManager._ids.remove(at: index)
                }
                index += 1
            }
            if ZSBookManager._ids.count > 0 {
                self.saveBooksID(booksID: ZSBookManager._ids)
            }
        }
    }
    
    //MARK: - 置顶
    func topBook(key:String) {
        var book_index = 0
        for index in 0..<ids.count {
            if ids[index] == key {
                book_index = index
            }
        }
        ZSBookManager._ids.remove(at: book_index)
        ZSBookManager._ids.insert(key, at: 0)
        saveBooksID(booksID: ZSBookManager._ids)
    }
    
    //MARK: - 添加,默认添加到尾部
    func addBook(book:BookDetail) {
        addBookId(book: book)
        addBookInfo(book: book)
    }
    
    //MARK: - 添加多本书籍,一般推荐书籍或者从远程拉取大量书籍时使用
    func addBooks(books:[BookDetail]) {
        for book in books {
            addBook(book: book)
        }
    }
    
    //MARK: - 删除指定书籍
    func deleteBook(book:BookDetail) {
        if !existBookId(bookId: book._id) {
            QSLog("\(book.title)不存在")
            return
        }
        clearId(id: book._id)
        clearBook(book: book)
    }
    
    //MARK: - 更新书架信息
    func update(bookshelfs:[BookShelf]) {
        for bookshelf in bookshelfs {
            guard let book = ZSBookManager._books[bookshelf._id ?? ""] else { return }
            if let updateStr = bookshelf.updated {
                if updateStr != book.updateInfo?.updated {
                    book.isUpdated = true
                    book.updateInfo = bookshelf
                    self.updateBook(book: book)
                }
            }
        }
    }
    
    //MARK: - 更新
    func updateBook(book:BookDetail) {
        if !existBookInfo(book: book) {
            QSLog("\(book.title)不存在")
            // 不存在,添加
            addBook(book: book)
        }
        QSLog("\(book.title)更新成功")
        ZSBookManager._books["\(book._id)"] = book
        saveBooks(book:book)
    }
    
    /// id数组中是否存在该id
    func existBookId(bookId:String) -> Bool {
        var exist_id:Bool = false
        for id in ZSBookManager._ids {
            if bookId == id {
                exist_id = true
            }
        }
        return exist_id
    }
    
    
    //MARK: - 浏览记录
    fileprivate func existHistoryId(id:String) ->Bool {
        var exist_id:Bool = false
        for historyId in ZSBookManager._historyIds {
            if historyId == id {
                exist_id = true
            }
        }
        return exist_id
    }
    
    func addHistory(book:BookDetail) {
        addHistoryId(id: book._id)
        addHistoryBook(book: book)
    }
    
    fileprivate func addHistoryId(id:String) {
        if existHistoryId(id: id) {
            return
        }
        if id == "" {
            return
        }
        ZSBookManager._historyIds.append(id)
        let path = ZSCacheHelper.historyPath
        let idString = ZSBookManager._historyIds.joined(separator: ",")
        let success = ZSCacheHelper.shared.storage(obj: idString, for: ZSReadHistorySaveIDKey, cachePath: path)
        if success {
            QSLog("阅读历史保存成功")
        }
    }
    
    fileprivate func addHistoryBook(book:BookDetail) {
        if book._id == "" {
            return
        }
        ZSBookManager.calTime {
            let path = ZSCacheHelper.historyPath
            let success = ZSCacheHelper.shared.storage(obj: book, for: book._id, cachePath: path)
            if success {
                QSLog("保存'\(book.title)'的阅读记录成功@_@")
            }
        }
    }
    
    /// 删除id数组中的该书id与本地id
    fileprivate func clearId(id:String) {
        var index = 0
        for bookId in ZSBookManager._ids {
            if id == bookId {
                break
            }
            index += 1
        }
        ZSBookManager._ids.remove(at: index)
        saveBooksID(booksID: ZSBookManager._ids)
    }
    
    /// 书籍数组中是否存在该书籍
    fileprivate func existBookInfo(book:BookDetail) -> Bool {
        var book_exist = false
        for item in ZSBookManager._books {
            if item.key == book._id {
                book_exist = true
            }
        }
        return book_exist
    }
    
    /// 添加书籍的id到id数组中
    private func addBookId(book:BookDetail) {
        if book._id == "" {
            // 为空,不添加
            return
        }
        if existBookId(bookId: book._id) {
            // 书架中已存在,不添加
            return
        }
        ZSBookManager._ids.append(book._id)
        saveBooksID(booksID: ZSBookManager._ids)
    }
    
    /// 添加书籍到书籍数组中
    private func addBookInfo(book:BookDetail) {
        if book._id == "" {
            // 为空,不添加
            return
        }
        if existBookInfo(book: book) {
            // 书架中已存在,不添加
            return
        }
        ZSBookManager._books["\(book._id)"] = book
        saveBooks(book: book)
    }
    
    //MARK: - 保存该书籍信息到本地
    fileprivate func saveBooks(book:BookDetail) {
        ZSBookManager._books = books
        // 只更新这本书,防止多次重复无用更新
        ZSBookManager.calTime {
            let cachePath = ZSCacheHelper.bookshelfBooksPath
            let success = ZSCacheHelper.shared.storage(obj: book, for: book._id, cachePath: cachePath)
            if success {
                QSLog("保存'\(book.title)'成功@_@")
            }
        }
    }
    
    //MARK: - 保存id数组到本地
    fileprivate func saveBooksID(booksID:[String]) {
        ZSBookManager._ids = booksID
        let path = ZSCacheHelper.bookshelfPath
        let idString = booksID.joined(separator: ",")
        let success = ZSCacheHelper.shared.storage(obj: idString, for: ZSBookShelfIDSKey, cachePath: path)
        if success {
            QSLog("书架List保存成功")
        }
    }
    
    /// 清除本地书籍信息
    fileprivate func clearBook(book:BookDetail) {
        ZSBookManager.calTime {
            let path = ZSCacheHelper.bookshelfBooksPath
            ZSCacheHelper.shared.clear(for: book._id, cachePath: path)
        }
    }
    
    //MARK: - 历史信息
    fileprivate func historyBooksInfo() -> [String:BookDetail] {
        if ZSBookManager._historyBooks.count > 0 {
            return ZSBookManager._historyBooks
        }
        var models:[String:BookDetail] = [:]
        for id in self.historyIds {
            let path = ZSCacheHelper.historyPath
            if let obj = ZSCacheHelper.shared.cachedObj(for: id, cachePath: path) as? BookDetail {
                models[id] = obj
            }
        }
        ZSBookManager._historyBooks = models
        return models
    }
    
    fileprivate func historyBooksID() ->[String] {
        if ZSBookManager._historyIds.count > 0 {
            return ZSBookManager._historyIds
        }
        let path = ZSCacheHelper.historyPath
        if let ids = ZSCacheHelper.shared.cachedObj(for: ZSReadHistorySaveIDKey, cachePath: path) as? String {
            let idArr = ids.components(separatedBy: ",")
            ZSBookManager._historyIds = idArr
            return idArr
        }
        ZSBookManager._historyIds = []
        return []
    }
    
    /// 获取本地保存的所有的书籍信息
    fileprivate func booksInfo() -> [String:BookDetail] {
        if ZSBookManager._books.count > 0 {
            
            return ZSBookManager._books
        }
        var models:[String:BookDetail] = [:]
        for id in self.ids {
            let path = ZSCacheHelper.bookshelfBooksPath
            if let obj = ZSCacheHelper.shared.cachedObj(for: id, cachePath: path) as? BookDetail {
                models[id] = obj
            }
        }
        ZSBookManager._books = models
        return models
    }
    
    // 如果ids存在,返回ids,如果不存在,读文件后保存到ids中,修改时页需要更新ids中的内容
    fileprivate func booksID() ->[String] {
        if ZSBookManager._ids.count > 0 {
            return ZSBookManager._ids.filter{ return $0 != "" }
        }
        let key = ZSBookShelfIDSKey
        let path = ZSCacheHelper.bookshelfPath
        if let ids = ZSCacheHelper.shared.cachedObj(for: key, cachePath: path) as? String {
            let idArr = ids.components(separatedBy: ",").filter{ $0 != "" }
            ZSBookManager._ids = idArr
            return idArr
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
    func updateInfoUpdate(updateInfo:[BookShelf]){
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
    func updateToModel(updateModels:[BookShelf]){
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
    
    func anyUpdate(bookInfo:BookShelf?,updateInfo:BookShelf)->Bool{
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
