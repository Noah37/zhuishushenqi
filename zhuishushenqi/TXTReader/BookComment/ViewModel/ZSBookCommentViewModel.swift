//
//  ZSBookCommentViewModel.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2018/6/17.
//  Copyright © 2018年 QS. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

struct ZSBookCommentSection {
    var items: [BookCommentDetail]
    
    var comment:BookComment?
    var best:[BookCommentDetail]?

}

extension ZSBookCommentSection: SectionModelType{
    init(original: ZSBookCommentSection, items: [BookCommentDetail]) {
        self = original
        self.items = items
    }
    
    typealias Item = BookCommentDetail
}

final class ZSBookCommentViewModel {
    // dataSource,监听
    var section:Driver<[ZSBookCommentSection]>?
    // 首页的刷新命令，入参是当前的分类
    let refreshCommand = ReplaySubject<Any>.create(bufferSize: 1)
    let requireMoreCommand = ReplaySubject<Any>.create(bufferSize: 1)

    fileprivate var bricks:BehaviorSubject<[BookCommentDetail]>?
    var refreshStatus: Variable<ZSRefreshStatus> = Variable(.none)
    fileprivate let disposeBag = DisposeBag()
    fileprivate var webService = ZSBookCommentService()
    
    init() {
        
        
        bricks = BehaviorSubject<[BookCommentDetail]>(value: [])
        section = bricks?
            .asObserver()
            .map({ (comment) -> [ZSBookCommentSection] in
                return [ZSBookCommentSection(items: comment, comment: BookComment(), best: comment)]
            })
            .asDriver(onErrorJustReturn: [])
        
        refreshCommand.subscribe(onNext: { (event) in
            let detail = self.webService.fetchCommentDetail(id: "", type: .normal)
            let best = self.webService.fetchCommentBest(id: "")
            detail.asObservable().subscribe({ (event) in
                switch event {
                case let .error(error):
                    QSLog(error)
                    break
                case let .next(response):
                    QSLog(response)
                    break
                case .completed:
                    break
                }
            }).disposed(by: self.disposeBag)
            best.asObservable().subscribe({ (event) in
                switch event {
                case let .error(error):
                    QSLog(error)
                    break
                case let .next(response):
                    QSLog(response)
                    break
                case .completed:
                    break
                }
            }).disposed(by: self.disposeBag)
        }, onError: { (error) in
            
        }).disposed(by: disposeBag)
    }
}
