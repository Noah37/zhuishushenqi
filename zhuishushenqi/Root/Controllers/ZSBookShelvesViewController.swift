//
//  ZSBookShelvesViewController.swift
//  zhuishushenqi
//
//  Created by caony on 2018/6/7.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit
import Then
import RxCocoa
import RxSwift
import QSPullToRefresh
import MJRefresh

class ZSBookShelvesViewController: BaseViewController ,UITableViewDelegate,Refreshable{
    
    var shelfMsg = UIButton(type: .custom).then {
        $0.frame = CGRect.zero
        $0.backgroundColor = UIColor ( red: 1.0, green: 1.0, blue: 1.0, alpha: 0.7 )
        $0.setTitleColor(UIColor.gray, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 13)
    }
    
    var tableView:UITableView = UITableView(frame: CGRect.zero, style: .grouped).then {
        $0.qs_registerCellClass(SwipableCell.self)
        $0.rowHeight = kCellHeight
        $0.estimatedRowHeight = kCellHeight
    }
    
    fileprivate let kHeaderBigHeight:CGFloat = 44
    static let kCellHeight:CGFloat = 60
    fileprivate let disposeBag = DisposeBag()
    var headerRefresh:MJRefreshHeader?
    
    let viewModel = ZSRootViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableDataSource()
        configureNavigateOnRowClick()
    }
    
    func configureTableDataSource(){
        
        let books = Observable.just(viewModel.books.map{ $0 })
        
        books.bind(to: tableView.rx.items(cellIdentifier: SwipableCell.reuseIdentifier, cellType: SwipableCell.self)) {  (row,element,cell)  in
            cell.textLabel?.text = ""
        }
        .disposed(by: disposeBag)
        
        
        let header = initRefreshHeader(tableView) {
            self.viewModel.fetchShelvesBooks({
                
            })
        }
        headerRefresh = header
    }
    
    func configureNavigateOnRowClick(){
        tableView.rx.modelSelected(BookDetail.self)
                    .asDriver()
            .drive(onNext: { (book) in
                
            })
            .disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    

}
