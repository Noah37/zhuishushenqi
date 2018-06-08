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

enum ZSRefreshStatus {
    case none
    case headerRefreshing
    case headerRefreshEnd
    case footerRefreshing
    case footerRefreshEnd
    case noMoreData
}

protocol ZSRefreshProtocol {
    var refreshStatus:Variable<ZSRefreshStatus>{ get }
}

extension ZSRefreshProtocol {
    func autoSetRefreshHeaderStatus(header:MJRefreshHeader?,footer:MJRefreshFooter?) -> Disposable{
        return refreshStatus.asObservable().subscribe(onNext: { (status) in
            switch status {
            case .headerRefreshing:
                header?.beginRefreshing()
            case .headerRefreshEnd:
                header?.endRefreshing()
            case .footerRefreshing:
                footer?.beginRefreshing()
            case .footerRefreshEnd:
                footer?.endRefreshing()
            case .noMoreData:
                footer?.endRefreshingWithNoMoreData()
            default:
                break
            }
        })
    }
}

protocol Refreshable {
    
}

extension Refreshable where Self : UIViewController{
    func initRefreshHeader(_ scrollView: UIScrollView,_ action:@escaping () ->Void) -> MJRefreshHeader{
        scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: { action() })
        return scrollView.mj_header
    }
    
    func initRefreshFooter(_ scrollView: UIScrollView,_ action:@escaping () ->Void) -> MJRefreshFooter{
        scrollView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            action()
        })
        return scrollView.mj_footer
    }
}

extension Refreshable where Self : UIScrollView {
    func initRefreshHeader(_ action:@escaping () ->Void) -> MJRefreshHeader{
        mj_header = MJRefreshNormalHeader(refreshingBlock: { action() })
        return mj_header
    }
    
    func initRefreshFooter(_ action:@escaping () ->Void) -> MJRefreshFooter{
        mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            action()
        })
        return mj_footer
    }
}


final class ZSRootViewModel:NSObject,ZSRefreshProtocol {
    

    var refreshStatus: Variable<ZSRefreshStatus> = Variable(.none)
    
    @objc dynamic var books:[String:Any] = BookManager.shared.books
    
    // 保存所有书籍的id,books存在时,他就存在
    var booksID:[String] = []
    
    @objc dynamic var shelfMessage:ZSShelfMessage?
    
    fileprivate let shelvesWebService = ZSRootWebService()

    fileprivate let disposeBag = DisposeBag()
    
    override init() {
        super.init()
        booksID = books.allKeys()
        refreshStatus.value = .none
        
        self.rx.observeWeakly(ZSRootViewModel.self, #keyPath(ZSRootViewModel.books)).subscribe(onNext: { (vm) in
            // 后续的booksID需要按照书架书籍阅读顺序进行排序
            self.booksID = self.books.allKeys()
        })
        .disposed(by: disposeBag)
    }

    func fetchShelvesBooks(_ completion: (() -> Void)? = nil){
        refreshStatus.value = .none
        shelvesWebService.fetchShelvesUpdate(for: books.allKeys())
            .bind(onNext: { (updates) in
                // 将更新信息放入books
                self.refreshStatus.value = .headerRefreshEnd
                completion?()
            })
            .disposed(by: disposeBag)
    }
    
    func fetchShelfMessage(_ completion: (() -> Void)? = nil){
        shelvesWebService.fetchShelvesMsg()
            .bind { (message) in
                self.shelfMessage = message
            completion?()
        }
        .disposed(by: disposeBag)
    }
}

