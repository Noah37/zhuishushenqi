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
    @objc internal var books:[String:Any] = BookManager.shared.books
    // 保存所有书籍的id,books存在时,他就存在
    var booksID:[String] = []
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
                    self.books[book._id] = book
                    self.booksID = self.books.allKeys()
                    BookManager.shared.addBook(book: book)
                    // 添加新的书籍之后需要刷新更新信息
                }
            })
            .disposed(by: disposeBag)
        
        booksID = books.allKeys()
        refreshStatus.value = .none
    }
    
    func scanPath(path:String){
        let path = "\(NSHomeDirectory())/Documents/Inbox/"
        if let items = try? FileManager.default.contentsOfDirectory(atPath: path) {
            localBooks = items
        }
    }
}

extension ZSShelfViewModel {
    func fetchShelvesBooks(completion:ZSBaseCallback<Void>?) {
        refreshStatus.value = .none
        shelvesWebService.fetchShelvesUpdate(for: books.allKeys()) { (updateInfo) in
            if let info = updateInfo {
                self.refreshStatus.value = .headerRefreshEnd
                BookManager.shared.updateInfoUpdate(updateInfo: info)
                completion?(nil)
            }
        }
    }
    
    func fetchShelfMessage(completion:ZSBaseCallback<Void>?){
        shelvesWebService.fetchShelfMsg { (message) in
            self.shelfMessage = message
            completion?(nil)
        }
    }
}
