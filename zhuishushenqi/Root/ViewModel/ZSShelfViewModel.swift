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
}
