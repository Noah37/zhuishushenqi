//
//  ZSShelfViewController.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2018/7/31.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit
import RxSwift
import SafariServices

class ZSShelfViewController: BaseViewController,Refreshable,UITableViewDataSource,UITableViewDelegate {
    
    lazy var shelfMsg:UIButton = {
        
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 44)
        btn.backgroundColor = UIColor ( red: 1.0, green: 1.0, blue: 1.0, alpha: 0.7 )
        btn.setTitleColor(UIColor.gray, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        return btn
    }()
    
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.qs_registerCellClass(SwipableCell.self)
        tableView.rowHeight = ZSShelfViewController.kCellHeight
        tableView.estimatedRowHeight = ZSShelfViewController.kCellHeight
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    fileprivate let kHeaderBigHeight:CGFloat = 44
    static let kCellHeight:CGFloat = 60
    fileprivate let disposeBag = DisposeBag()
    var headerRefresh:MJRefreshHeader?
    
    let viewModel = ZSShelfViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupSubviews()
        
        NotificationCenter.qs_addObserver(observer: self, selector: #selector(loginSuccessAction), name: LoginSuccess, object: nil)
        NotificationCenter.qs_addObserver(observer: self, selector: #selector(addBookToShelf(noti:)), name: BOOKSHELF_ADD, object: nil)
        loginSuccessAction()
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
        
        view.addSubview(tableView)
        
        viewModel.fetchBlessingBag(token: ZSLogin.share.token) { (json) in
            print(json)
        }
        
        viewModel.fetchJudgeIn(token: ZSLogin.share.token) { (json) in
            if json?["ok"] as? Bool == true {
                if let activityId = json?["activityId"] as? String {
                    self.viewModel.fetchSignIn(token: ZSLogin.share.token, activityId: activityId, version: "2", type: "2", completion: { (json) in
                        if json?["ok"] as? Bool == true {
                            print("签到成功")
                            let amount = json?["amount"] as? Int ?? 0
                            self.view.showTip(tip: "自动签到获得\(amount)书券")
                        }
                    })
                }
            }
        }
        
        shelfMsg.addTarget(self, action: #selector(openSafari), for: .touchUpInside)
    }
    
    @objc
    func openSafari() {
        if let message = viewModel.shelfMessage {
            let title = message.postMessage()
            if title.0.hasPrefix("http") {
                if let url = URL(string: title.0) {
                    let safariVC = SFSafariViewController(url: url)
                    self .present(safariVC, animated: true, completion: nil)
                }
            } else {
                // 不是url就是post
                let id = title.0
                let comment = BookComment()
                comment._id = id
                let commentVC = ZSBookCommentViewController(style: .grouped)
                commentVC.viewModel.model = comment
                SideVC.navigationController?.pushViewController(commentVC, animated: true)
            }
        }
    }
    
    @objc
    func loginSuccessAction() {
        viewModel.fetchShelfAdd(books: viewModel.books.allValues() as! [BookDetail], token: ZSLogin.share.token) { (json) in
            if json?["ok"] as? Bool == true {
                self.view.showTip(tip: "书架书籍上传成功")
            } else {
                self.view.showTip(tip: "书架书籍上传失败")
            }
        }
        viewModel.fetchUserBookshelf(token: ZSLogin.share.token) { (bookshelf) in
            self.viewModel.fetchShelvesBooks(completion: { (_) in
                self.view.showTip(tip: "更新了几本书")
                self.tableView.reloadData()
            })
            self.tableView.reloadData()
        }

    }
    
    @objc
    func addBookToShelf(noti:Notification) {
        if let book = noti.object as? BookDetail {
            if ZSLogin.share.hasLogin() {
                viewModel.fetchShelfAdd(books: [book], token: ZSLogin.share.token) { (json) in
                    if json?["ok"] as? Bool == true {
                        self.view.showTip(tip: "添加到书架成功")
                        self.headerRefresh?.beginRefreshing()
                    } else {
                        self.view.showTip(tip: "添加到书架失败")
                    }
                }
            } else {
                self.view.showTip(tip: "添加到书架成功")
                self.headerRefresh?.beginRefreshing()
            }
        }
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        if let url = URL(string: "IFlySpeechPlus://?version=1.006&businessType=1&callType=0") {
//            UIApplication.shared.openURL(url)
//            return
//        }
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
                self.viewModel.fetchShelfDelete(books: [book], token: ZSLogin.share.token) { (json) in
                    if json?["ok"] as? Bool == true {
                        self.view.showTip(tip: "\(book.title)已从书架中删除")
                    } else {
                        self.view.showTip(tip: "\(book.title)从书架中删除失败")
                    }
                }
            }
            index += 1
        }
    }
}
