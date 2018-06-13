//
//  ZSRootViewModel.swift
//  zhuishushenqi
//
//  Created by caony on 2018/6/7.
//  Copyright © 2018年 QS. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import MJRefresh
import Differentiator

struct HomeSection {
    
    var items: [Item]
}

extension HomeSection: SectionModelType {
    
    typealias Item = BookDetail
    
    init(original: HomeSection, items: [HomeSection.Item]) {
        self = original
        self.items = items
    }
}

final class ZSRootViewModel:NSObject,ZSRefreshProtocol {
    
    // dataSource,监听
    var section:Driver<[HomeSection]>?
    // 首页的刷新命令，入参是当前的分类
    let refreshCommand = ReplaySubject<Any>.create(bufferSize: 1)
    // 书架广告信息
    @objc var shelfMessage:ZSShelfMessage?
    fileprivate var bricks:BehaviorSubject<[BookDetail]>?
    internal var refreshStatus: Variable<ZSRefreshStatus> = Variable(.none)
    @objc internal var books:[String:Any] = BookManager.shared.books
    // 保存所有书籍的id,books存在时,他就存在
    fileprivate var booksID:[String] = []
    fileprivate let shelvesWebService = ZSRootWebService()
    fileprivate let disposeBag = DisposeBag()
    
    override init() {
        super.init()
        
        bricks = BehaviorSubject<[BookDetail]>(value: books.allValues() as! [BookDetail])
        section = bricks?
            .asObservable()
            .map({ (bricks) ->[HomeSection] in
                // bricks 发送on(.next(response.allValues() as! [BookDetail] ) 会回调到这里
                return [HomeSection(items: bricks)]
            })
            .asDriver(onErrorJustReturn: [])
        // 详情页添加书籍信息
        NotificationCenter.default.rx.notification(Notification.Name(rawValue:BOOKSHELF_ADD))
        .observeOn(MainScheduler.asyncInstance)
        .subscribe(onNext: { (noti) in
            // 更新内存中books的值与archive中的值
            if let book = noti.object as? BookDetail {
                self.books[book._id] = book
                self.booksID = self.books.allKeys()
                BookManager.shared.addBook(book: book)
                // 添加新的书籍之后需要刷新更新信息
                self.refreshCommand.onNext([:])
            }
        })
        .disposed(by: disposeBag)
        
        refreshCommand
            .flatMapLatest { query in
                self.shelvesWebService.fetchShelvesUpdate(for: self.books.allKeys()).asDriver(onErrorJustReturn: [:])
            }
            .subscribe({ (event) in
                switch event {
                case let .next(response):
                    self.refreshStatus.value = .headerRefreshEnd
                    self.bricks?.on(.next(response.allValues() as! [BookDetail] ))
                    break
                case let .error(error):
                    self.refreshStatus.value = .headerRefreshEnd
                    QSLog(error)
                    break
                case .completed:
                    break
                }
            })
            .disposed(by: disposeBag)
        //========初始化==========
        booksID = books.allKeys()
        refreshStatus.value = .none
    }
}

extension ZSRootViewModel{
    func fetchShelvesBooks(_ completion: (() -> Void)? = nil){
        refreshStatus.value = .none
        shelvesWebService.fetchShelvesUpdate(for: books.allKeys())
            .observeOn(MainScheduler.instance)
            .catchErrorJustReturn(self.books)
            .bind(onNext: { (updates) in
                // 将更新信息放入books
                self.refreshStatus.value = .headerRefreshEnd
                completion?()
            })
            .disposed(by: disposeBag)
    }
    
    func fetchShelfMessage(_ completion: (() -> Void)? = nil){
        shelvesWebService.fetchShelvesMsg()
            .bind(onNext:{ (message) in
                self.shelfMessage = message
                completion?()
            })
            .disposed(by: disposeBag)
    }
}

