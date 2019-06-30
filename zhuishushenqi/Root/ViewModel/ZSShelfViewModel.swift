//
//  ZSShelfViewModel.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2018/7/31.
//  Copyright © 2018年 QS. All rights reserved.
//

import Foundation
import RxSwift
import ZSAPI

class ZSShelfViewModel:ZSRefreshProtocol {
    
    internal var refreshStatus: Variable<ZSRefreshStatus> = Variable(.none)
    
    var localBooks:[String] = []
    let database = ZSDatabase()
    // 网络书籍
    var books:[String:BookDetail] {
        get {
           return ZSBookManager.shared.books
        }
        set {}
    }
    // 保存所有书籍的id,books存在时,他就存在
    var booksID:[String] {
        get {
            return ZSBookManager.shared.ids
        }
        set {}
    }
    
    var bookshelfBooks:[ZSUserBookshelf] = []
    
    var bookshelfs:[BookDetail] = []
    
    fileprivate let shelvesWebService = ZSShelfWebService()
    fileprivate let disposeBag = DisposeBag()
    
    @objc var shelfMessage:ZSShelfMessage?
    
    let helper = MonitorFileChangeHelp()

    init() {
        
        let path = "\(NSHomeDirectory())/Documents/Inbox/"
        scanPath(path: path)
        helper.watcher(forPath: path) { (type) in
            self.scanPath(path: path)
        }
        
        NotificationCenter.default
            .rx
            .notification(Notification.Name(rawValue:BOOKSHELF_ADD))
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { (noti) in
                // 更新内存中books的值与archive中的值
                if let book = noti.object as? BookDetail {
                    let result = self.database.insertBookshelf(book: book)
                    if result { }
                    ZSBookManager.shared.addBook(book: book)
                }
            })
            .disposed(by: disposeBag)
        NotificationCenter.default.rx.notification(Notification.Name(rawValue:BOOKSHELF_DELETE))
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { (noti) in
                // 更新内存中books的值与archive中的值
                if let book = noti.object as? BookDetail {
                    ZSBookManager.shared.deleteBook(book: book)
                }
            })
            .disposed(by: disposeBag)
        
        refreshStatus.value = .none
    }
    
    func scanPath(path:String){
        let path = "\(NSHomeDirectory())/Documents/Inbox/"
        if let items = try? FileManager.default.contentsOfDirectory(atPath: path) {
            localBooks = items
        }
    }
    
    func fetchBooks() ->[BookDetail] {
        if bookshelfs.count > 0 {
            return bookshelfs
        }
        let books = database.queryBookshelf()
        return books
    }
    
    func existBook(id:String) -> Bool {
        var exist = false
        for item in self.booksID {
            if item == id {
                exist = true
            }
        }
        return exist
    }
    
    func topBook(key:String) {
        ZSBookManager.shared.topBook(key: key)
    }
}

extension ZSShelfViewModel {
    func fetchShelvesBooks(completion:ZSBaseCallback<Void>?) {
        refreshStatus.value = .none
        if booksID.count > 0 {
            shelvesWebService.fetchShelvesUpdate(for: booksID) { (updateInfo) in
                self.refreshStatus.value = .headerRefreshEnd
                if let info = updateInfo as? [BookShelf] {
//                    for update in info {
//                        self.database.updateInfo(updateInfo: update)
//                    }
                    ZSBookManager.shared.update(bookshelfs: info)
//                    BookManager.shared.updateInfoUpdate(updateInfo: info)
                    completion?(nil)
                }
            }
        } else {
            self.refreshStatus.value = .headerRefreshEnd
        }
    }
    
    func fetchShelfMessage(completion:ZSBaseCallback<Void>?){
        shelvesWebService.fetchShelfMsg { (message) in
            self.shelfMessage = message
            completion?(nil)
        }
    }
    
    func fetchShelfDelete(books:[BookDetail], token:String, completion:@escaping ZSBaseCallback<[String:Any]>) {
        var booksID = ""
        for book in books {
            if booksID != "" {
                booksID.append(",")
            }
            booksID.append(book._id)
        }
        let api = ZSAPI.booksheldDelete(books: booksID, token: token)
        shelvesWebService.fetchShelfDelete(urlString: api.path, param: api.parameters) { (json) in
            completion(json)
        }
    }
    
    func fetchShelfAdd(books:[BookDetail], token:String, completion:@escaping ZSBaseCallback<[String:Any]>) {
        var booksID = ""
        for book in books {
            if booksID != "" {
                booksID.append(",")
            }
            booksID.append(book._id)
        }
        let api = ZSAPI.bookshelfAdd(books: booksID, token: token)
        shelvesWebService.fetchShelfAdd(urlString: api.path, param: api.parameters) { (json) in
            completion(json)
        }
    }
    
    func fetchUserBookshelf(token:String, completion:@escaping ZSBaseCallback<[ZSUserBookshelf]>) {
        shelvesWebService.fetchBookshelf(token: token) { (books) in
            if let models = books {
                self.bookshelfBooks = models
                self.fetchBooksInfo(books: models, completion: completion)
            }
        }
    }
    
    func fetchBooksInfo(books:[ZSUserBookshelf], completion:@escaping ZSBaseCallback<[ZSUserBookshelf]>) {
        for item in books {
            if !existBook(id: item.id) {
                self.shelvesWebService.fetchBookInfo(id: item.id, completion: { (book) in
                    // 获取到书记信息后加入到books中
                    self.lock(object: self.booksID as AnyObject, callback: {
                        if let bookDetail = book {
                            self.booksID.append(item.id)
                            self.books[item.id] = bookDetail
                            ZSBookManager.shared.addBook(book: bookDetail)
                            completion(books)
                        }
                    })
                })
            }
        }
    }
    
    func fetchBlessingBag(token:String, completion:@escaping ZSBaseCallback<[String:Any]>) {
        let api = ZSAPI.blessing_bag(token: token)
        shelvesWebService.fetchBlessingBag(urlString: api.path, param: api.parameters) { (json) in
            completion(json)
        }
    }
    
    func fetchJudgeIn(token:String, completion:@escaping ZSBaseCallback<[String:Any]>) {
        let api = ZSAPI.judgeSignIn(token: token)
        shelvesWebService.fetchJudgeIn(urlString: api.path, param: api.parameters) { (json) in
            completion(json)
        }
    }
    
    func fetchSignIn(token:String, activityId:String, version:String, type:String, completion:@escaping ZSBaseCallback<[String:Any]>) {
        let api = ZSAPI.signIn(token: token, activityId: activityId, version: version, type: type)
        shelvesWebService.fetchSignIn(urlString: api.path, param: api.parameters) { (json) in
            completion(json)
        }
    }
    
    // 下载章节到磁盘
//    func
    
    func lock(object:AnyObject, callback:()->Void) {
        print("\(object)开始加锁")
        objc_sync_enter(object)
        callback()
        print("\(object)结束加锁")
        objc_sync_exit(object)
    }
}
