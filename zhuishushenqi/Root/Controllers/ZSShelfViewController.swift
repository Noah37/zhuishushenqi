//
//  ZSShelfViewController.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2018/7/31.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit
import RxSwift

class ZSShelfViewController: BaseViewController,Refreshable,UITableViewDataSource,UITableViewDelegate {
    
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
    
    let viewModel = ZSShelfViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupSubviews(){
        let header = initRefreshHeader(tableView) {
            self.viewModel.fetchShelvesBooks(completion: { (_) in
                self.tableView.reloadData()
            })
            self.viewModel.fetchShelfMessage(completion: { (_) in
                self.tableView.reloadData()
            })
        }
        headerRefresh = header
        headerRefresh?.beginRefreshing()
        viewModel
            .autoSetRefreshHeaderStatus(header: header, footer: nil)
            .disposed(by: disposeBag)
        
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        if viewModel.localBooks.count > 0 {
            return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.localBooks.count > 0 {
            if section == 0 {
                return 1
            }
            return viewModel.books.count
        }
        return viewModel.books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SwipableCell.reuseIdentifier, for: indexPath) as! SwipableCell
        if viewModel.localBooks.count > 0 {
            if indexPath.section == 0 {
                cell.title?.text = "本地书架"
                return cell
            }
            let id = viewModel.booksID[indexPath.row]
            if let item = viewModel.books[id] as? BookDetail {
                cell.configureCell(model: item)
            }
        } else {
            let id = viewModel.booksID[indexPath.row]
            if let item = viewModel.books[id] as? BookDetail {
                cell.configureCell(model: item)
            }
        }
        return cell
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if viewModel.localBooks.count > 0 {
            if section == 0 {
                if let message = viewModel.shelfMessage {
                    let title = message.postMessage()
                    shelfMsg.setTitle(title.1, for: .normal)
                    shelfMsg.setTitleColor(title.2, for: .normal)
                    return shelfMsg
                }
            }
        } else {
            if section == 0 {
                if let message = viewModel.shelfMessage {
                    let title = message.postMessage()
                    shelfMsg.setTitle(title.1, for: .normal)
                    shelfMsg.setTitleColor(title.2, for: .normal)
                    return shelfMsg
                }
            }
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if viewModel.localBooks.count > 0 {
            if section == 0 {
                if let _ = viewModel.shelfMessage?.postLink {
                    return kHeaderBigHeight
                }
            }
        } else {
            if section == 0 {
                if let _ = viewModel.shelfMessage?.postLink {
                    return kHeaderBigHeight
                }
            }
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if viewModel.localBooks.count > 0 {
            if indexPath.section == 0 {
                let localVC = ZSLocalShelfViewController()
                SideVC.navigationController?.pushViewController(localVC, animated: true)
                return
            }
        }
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

}
