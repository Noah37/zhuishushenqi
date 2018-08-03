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
import MJRefresh
import SnapKit
import RxDataSources

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
        self.navigationController?.navigationBar.barTintColor = UIColor ( red: 0.7235, green: 0.0, blue: 0.1146, alpha: 1.0 )
    }
    
    func configureTableDataSource(){
        
        view.addSubview(tableView)
        
        //RxTableViewSectionedReloadDataSource的<S>必须遵循协议:SectionModelType
        let dataSource = RxTableViewSectionedReloadDataSource<HomeSection>(configureCell: { dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: SwipableCell.reuseIdentifier, for: indexPath) as! SwipableCell
            cell.configureCell(model: item)
            return cell
        })
        viewModel
            .section?
            .drive(tableView.rx.items(dataSource:dataSource))
            .disposed(by: disposeBag)

        let header = initRefreshHeader(tableView) {
            self.viewModel.refreshCommand.onNext([:])
            self.viewModel.fetchShelfMessage()
        }
        headerRefresh = header
        headerRefresh?.beginRefreshing()
        viewModel
            .autoSetRefreshHeaderStatus(header: header, footer: nil)
            .disposed(by: disposeBag)

        tableView
            .rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    func configureNavigateOnRowClick(){
        tableView
            .rx
            .itemSelected
            .bind { [unowned self] indexPath in
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
        viewModel
            .rx
            .observe(ZSRootViewModel.self, #keyPath(ZSRootViewModel.shelfMessage))
            .debug()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (model) in
                self.tableView.reloadData()
            }, onError: { (error) in
                QSLog("error:\(error)")
            }, onCompleted: {

            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let message = viewModel.shelfMessage {
            let title = message.postMessage()
            shelfMsg.setTitle(title.1, for: .normal)
            shelfMsg.setTitleColor(title.2, for: .normal)
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
