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


final class ZSRootViewModel {
    

    struct ZSRootOut:ZSRefreshProtocol {
        var refreshStatus: Variable<ZSRefreshStatus>
    }
    
    var books:[BookDetail] = []
    
    fileprivate let shelvesWebService = ZSRootWebService()

    fileprivate let disposeBag = DisposeBag()

    func fetchShelvesBooks(_ completion: (() -> Void)? = nil){
        shelvesWebService.fetchShelvesUpdate(for: books)
            .bind(onNext: { (updates) in
                // 将更新信息放入books
                completion?()
            })
            .disposed(by: disposeBag)
    }
    
}
