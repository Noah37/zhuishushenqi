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
import SnapKit

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
        $0.estimatedSectionHeaderHeight = 0.01
    }
    
    fileprivate let kHeaderBigHeight:CGFloat = 44
    static let kCellHeight:CGFloat = 60
    fileprivate let disposeBag = DisposeBag()
    var headerRefresh:MJRefreshHeader?
    
    let viewModel = ZSRootViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.red
        configureTableDataSource()
        configureNavigateOnRowClick()
        configureShelfMessage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
    }
    
    func configureTableDataSource(){
        
        view.addSubview(tableView)
        
        let books = Observable.just(viewModel.books.map{ $0 })
        
        books.bind(to: tableView.rx.items(cellIdentifier: SwipableCell.reuseIdentifier, cellType: SwipableCell.self)) {  (row,element,cell)  in
            cell.configureCell(model: element.value as! BookDetail)
            QSLog("")
        }
        .disposed(by: disposeBag)
        
        let header = initRefreshHeader(tableView) {
            self.viewModel.fetchShelvesBooks()
            self.viewModel.fetchShelfMessage()
        }
        headerRefresh = header
        headerRefresh?.beginRefreshing()
        viewModel.autoSetRefreshHeaderStatus(header: header, footer: nil).disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    func configureNavigateOnRowClick(){
        tableView.rx.itemSelected.bind { [unowned self] indexPath in
            self.tableView.deselectRow(at: indexPath, animated: true)
            let books = self.viewModel.books
            if let model =  books[books.allKeys()[indexPath.row]] as? BookDetail {
                let viewController = QSTextRouter.createModule(bookDetail: model, callback: { (book) in
                    BookManager.calTime {
                        // 计算本地数据存储用时
                        BookManager.shared.modifyBookshelf(book: book)
                        self.tableView.reloadRow(at: indexPath, with: .automatic)
                    }
                })
                self.present(viewController, animated: true, completion: nil)
            }
        }
        .disposed(by: disposeBag)
    }
    
    func configureShelfMessage(){
        viewModel.rx.observeWeakly(ZSRootViewModel.self, #keyPath(ZSRootViewModel.shelfMessage))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (vm) in
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
    }

    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let message = viewModel.shelfMessage {
            let title = message.postMessage()
            shelfMsg.setTitle(title.1, for: .normal)
            return shelfMsg
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let _ = viewModel.shelfMessage?.postLink {
            return kHeaderBigHeight
        }
        return 0.01
    }

}
