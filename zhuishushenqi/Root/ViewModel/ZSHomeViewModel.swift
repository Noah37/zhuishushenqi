//
//  ZSHomeViewModel.swift
//  zhuishushenqi
//
//  Created by caony on 2018/5/21.
//  Copyright © 2018年 QS. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift


protocol HomeBookCase {
    func books() -> Observable<[BookDetail]>
    func add(book: BookDetail) -> Observable<Void>
    func delete(book: BookDetail) -> Observable<Void>
}

final class ZSHomeViewModel {
    
    let books:Observable<[BookDetail]>
    let reloadData: Observable<Void>
    let selectedBook: Observable<BookDetail>?
    fileprivate let _books = BehaviorRelay<[BookDetail]>(value: [])

    
    private let disposeBag = DisposeBag()
    
    init(booksObservable:Observable<[BookDetail]>,selectedIndexPath: Observable<IndexPath>? = nil) {
        self.books = _books.asObservable()
        self.reloadData = _books.asObservable().map { _ in }
        self.selectedBook = selectedIndexPath?.withLatestFrom(_books.asObservable()) {$1[$0.row] }
        booksObservable
            .bind(to: _books)
            .disposed(by: disposeBag)
    }
}

extension ZSHomeViewModel:ValueCompatible {}

extension Value where Base == ZSHomeViewModel {
    var books:[BookDetail] {
        return base._books.value
    }
}
