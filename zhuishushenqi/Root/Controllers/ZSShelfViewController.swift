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
        
//        let books = ZSBookManager.shared.books
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
                self.view.showTip(tip: "更新了几本书")
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
    
    //MARK: - UITableView
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
        cell.delegate = self
        if viewModel.localBooks.count > 0 {
            if indexPath.section == 0 {
                cell.title?.text = "本地书架"
                return cell
            }
            let id = viewModel.booksID[indexPath.row]
            if let item = viewModel.books[id] {
                cell.configureCell(model: item)
            }
        } else {
            let id = viewModel.booksID[indexPath.row]
            if let item = viewModel.books[id]  {
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
        if let model =  books[viewModel.booksID[indexPath.row]] {
            let viewController = ZSReaderViewController()
            viewController.viewModel.book = model
            self.present(viewController, animated: true, completion: nil)
            self.tableView.reloadRow(at: indexPath, with: .automatic)
        }
        
    }
}

extension ZSShelfViewController:SwipableCellDelegate {
    func swipeCell(clickAt: Int,model:BookDetail,cell:SwipableCell,selected:Bool) {
        if clickAt == 0 {
            if selected == false {
                // 取消下载
                
                return
            }
            let indexPath = tableView.indexPath(for: cell)
            // 选择一种缓存方式后，缓存按钮变为选中状态，小说图标变为在缓存中
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let firstAcion = UIAlertAction(title: "全本缓存", style: .default, handler: { (action) in
                self.hudAddTo(view: self.view, text: "暂不支持当前功能,敬请期待...", animated: true)
            })
            let secondAction = UIAlertAction(title: "从当前章节缓存", style: .default, handler: { (action) in
                self.hudAddTo(view: self.view, text: "暂不支持当前功能,敬请期待...", animated: true)
            })
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
                
            })
            alert.addAction(firstAcion)
            alert.addAction(secondAction)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }
        else if clickAt == 3 {
            self.removeBook(book: model)
            self.tableView.reloadData()
        } else {
            self.hudAddTo(view: self.view, text: "暂不支持当前功能,敬请期待...", animated: true)
        }
    }
    
    func removeBook(book:BookDetail){
        let books = self.viewModel.booksID
        var index = 0
        for bookid in books {
            if book._id == bookid {
                self.viewModel.booksID.remove(at: index)
                self.viewModel.books.removeValue(forKey: bookid)
                BookManager.shared.deleteBook(book: book)
            }
            index += 1
        }
    }
}
