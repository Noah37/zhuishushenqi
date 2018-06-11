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
import RxDataSources

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
    
    // new
    var section:Driver<[HomeSection]>?
    
    var bricks:BehaviorRelay<[BookDetail]>?
    
    // 首页的刷新命令，入参是当前的分类
    let refreshCommand = ReplaySubject<Any>.create(bufferSize: 1)
    
    // 刷新当前的页面，和下拉操作一起绑定
    let refreshTrigger = ReplaySubject<Any>.create(bufferSize: 1)
    
    var refreshStatus: Variable<ZSRefreshStatus> = Variable(.none)
    
    @objc var books:[String:Any] = BookManager.shared.books 
    
    // 保存所有书籍的id,books存在时,他就存在
    var booksID:[String] = []
    
    @objc dynamic var shelfMessage:ZSShelfMessage?
    
    fileprivate let shelvesWebService = ZSRootWebService()

    fileprivate let disposeBag = DisposeBag()
    
    override init() {
        super.init()
        bricks = BehaviorRelay<[BookDetail]>(value: books.allValues() as! [BookDetail])
        section = bricks?.asObservable().map({ (bricks) ->[HomeSection] in
            return [HomeSection(items: bricks)]
        })
        .asDriver(onErrorJustReturn: [])
        NotificationCenter.default.rx.notification(Notification.Name(rawValue:BOOKSHELF_ADD))
        .observeOn(MainScheduler.asyncInstance)
        .subscribe(onNext: { (noti) in
            QSLog("noti:\(String(describing: noti.object))")
            // 更新内存中books的值与archive中的值
            if let book = noti.object as? BookDetail {
                self.books[book._id] = book
                BookManager.shared.addBook(book: book)
                self.bricks = BehaviorRelay<[BookDetail]>(value: self.books.allValues() as! [BookDetail])
                self.refreshCommand.onNext([:])
            }
        })
        .disposed(by: disposeBag)
        
        refreshCommand
            .flatMapLatest { query in
                self.shelvesWebService.fetchShelvesUpdate(for: self.books.allKeys())
            }
            .subscribe({ (event) in
                self.refreshTrigger.onNext(event)
                switch event {
                case let .next(response):
                    self.refreshStatus.value = .headerRefreshEnd
                    self.bricks?.value
                    self.bricks?.accept(response.allValues() as! [BookDetail])
//                    self.refresh()
                    print(response)
                    break
                case let .error(error):
                    print(error)
                    break
                case .completed:
                    
                    break
                }
            })
            .disposed(by: disposeBag)
        //==================
        booksID = books.allKeys()
        refreshStatus.value = .none
        
        self.rx.observeWeakly(ZSRootViewModel.self, #keyPath(ZSRootViewModel.books)).subscribe(onNext: { (vm) in
            // 后续的booksID需要按照书架书籍阅读顺序进行排序
            self.booksID = self.books.allKeys()
        })
        .disposed(by: disposeBag)
    }
    
    func refresh(){
        bricks = BehaviorRelay<[BookDetail]>(value: books.allValues() as! [BookDetail])
        section = bricks?.asObservable().map({ (bricks) ->[HomeSection] in
            return [HomeSection(items: bricks)]
        })
            .asDriver(onErrorJustReturn: [])

    }

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
            .bind{ (messsge) in
                self.shelfMessage = messsge
                completion?()
            }
            .disposed(by: disposeBag)
    }
}

