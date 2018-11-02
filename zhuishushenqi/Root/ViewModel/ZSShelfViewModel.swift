//
//  ZSShelfViewModel.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2018/7/31.
//  Copyright © 2018年 QS. All rights reserved.
//

import Foundation
import RxSwift

class ZSShelfViewModel:NSObject,ZSRefreshProtocol {
    
    internal var refreshStatus: Variable<ZSRefreshStatus> = Variable(.none)
    
    var localBooks:[String] = []
    // 网络书籍
    var books:[String:BookDetail] {
        get {
           return ZSBookManager.shared.books
        }
        set {
            ZSBookManager.shared.books = newValue
        }
    }
    // 保存所有书籍的id,books存在时,他就存在
    var booksID:[String] {
        get {
            return ZSBookManager.shared.ids
        }
        set {
            ZSBookManager.shared.ids = newValue
        }
    }
    
    var bookshelfBooks:[ZSUserBookshelf] = []
    
    fileprivate let shelvesWebService = ZSShelfWebService()
    fileprivate let disposeBag = DisposeBag()
    
    @objc var shelfMessage:ZSShelfMessage?
    
    let helper = MonitorFileChangeHelp()

    override init() {
        super.init()
        
        let path = "\(NSHomeDirectory())/Documents/Inbox/"
        scanPath(path: path)
        helper.watcher(forPath: path) { (type) in
            self.scanPath(path: path)
        }
        
        NotificationCenter.default.rx.notification(Notification.Name(rawValue:BOOKSHELF_ADD))
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { (noti) in
                // 更新内存中books的值与archive中的值
                if let book = noti.object as? BookDetail {
                    if !self.existBook(id: book._id) {
                        self.books[book._id] = book
                        self.booksID.append(book._id)
                        ZSBookManager.shared.addBook(book: book)
                    }
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
    
    func existBook(id:String) -> Bool {
        var exist = false
        for item in self.booksID {
            if item == id {
                exist = true
            }
        }
        return exist
    }
}

extension ZSShelfViewModel {
    func fetchShelvesBooks(completion:ZSBaseCallback<Void>?) {
        refreshStatus.value = .none
        if booksID.count > 0 {
            shelvesWebService.fetchShelvesUpdate(for: booksID) { (updateInfo) in
                if let info = updateInfo {
                    self.refreshStatus.value = .headerRefreshEnd
                    ZSBookManager.shared.update(updateInfo: info)
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
        let api = QSAPI.booksheldDelete(books: booksID, token: token)
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
        let api = QSAPI.bookshelfAdd(books: booksID, token: token)
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
                            completion(books)
                        }
                    })
                })
            }
        }
    }
    
    func fetchBlessingBag(token:String, completion:@escaping ZSBaseCallback<[String:Any]>) {
        let api = QSAPI.blessing_bag(token: token)
        shelvesWebService.fetchBlessingBag(urlString: api.path, param: api.parameters) { (json) in
            completion(json)
        }
    }
    
    func fetchJudgeIn(token:String, completion:@escaping ZSBaseCallback<[String:Any]>) {
        let api = QSAPI.judgeSignIn(token: token)
        shelvesWebService.fetchJudgeIn(urlString: api.path, param: api.parameters) { (json) in
            completion(json)
        }
    }
    
    func fetchSignIn(token:String, activityId:String, version:String, type:String, completion:@escaping ZSBaseCallback<[String:Any]>) {
        let api = QSAPI.signIn(token: token, activityId: activityId, version: version, type: type)
        shelvesWebService.fetchSignIn(urlString: api.path, param: api.parameters) { (json) in
            completion(json)
        }
    }
    
    func lock(object:AnyObject, callback:()->Void) {
        print("\(object)开始加锁")
        objc_sync_enter(object)
        callback()
        print("\(object)结束加锁")
        objc_sync_exit(object)
    }
}
