//
//  ZSProtocol.swift
//  zhuishushenqi
//
//  Created by caony on 2018/6/11.
//  Copyright © 2018年 QS. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import MJRefresh

public enum ZSRefreshStatus {
    case none
    case headerRefreshing
    case headerRefreshEnd
    case footerRefreshing
    case footerRefreshEnd
    case noMoreData
}

public protocol ZSRefreshControl {
    var refreshStatus:ZSRefreshStatus { get }
}

extension ZSRefreshControl {
    func autoSetRefreshHeaderStatus(header:MJRefreshHeader?,footer:MJRefreshFooter?) {
        
    }
}

public protocol ZSRefreshProtocol {
    var refreshStatus:Variable<ZSRefreshStatus>{ get }
}

public extension ZSRefreshProtocol {
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

public protocol Refreshable {
    
}

public extension Refreshable where Self : UIViewController{
    
    @discardableResult
    func initRefreshHeader(_ scrollView: UIScrollView,_ action:@escaping () ->Void) -> MJRefreshHeader{
        scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: { action() })
        return scrollView.mj_header
    }
    
    @discardableResult
    func initRefreshFooter(_ scrollView: UIScrollView,_ action:@escaping () ->Void) -> MJRefreshFooter{
        scrollView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            action()
        })
        return scrollView.mj_footer
    }
}

public extension Refreshable where Self : UIScrollView {
    
    @discardableResult
    func initRefreshHeader(_ action:@escaping () ->Void) -> MJRefreshHeader{
        mj_header = MJRefreshNormalHeader(refreshingBlock: { action() })
        return mj_header
    }
    
    @discardableResult
    func initRefreshFooter(_ action:@escaping () ->Void) -> MJRefreshFooter{
        mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            action()
        })
        return mj_footer
    }
}


public extension Refreshable where Self : UIView{
    
    @discardableResult
    func initRefreshHeader(_ scrollView: UIScrollView,_ action:@escaping () ->Void) -> MJRefreshHeader{
        scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: { action() })
        return scrollView.mj_header
    }
    
    @discardableResult
    func initRefreshFooter(_ scrollView: UIScrollView,_ action:@escaping () ->Void) -> MJRefreshFooter{
        scrollView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            action()
        })
        return scrollView.mj_footer
    }
}
