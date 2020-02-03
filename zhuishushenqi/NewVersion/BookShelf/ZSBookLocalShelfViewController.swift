//
//  ZSBookLocalShelfViewController.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2020/1/25.
//  Copyright © 2020 QS. All rights reserved.
//

import UIKit

class ZSBookLocalShelfViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {
    
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.qs_registerCellClass(ZSShelfTableViewCell.self)
        tableView.rowHeight = ZSBookLocalShelfViewController.kCellHeight
        tableView.estimatedRowHeight = ZSBookLocalShelfViewController.kCellHeight
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    static let kCellHeight:CGFloat = 60

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kNavgationBarHeight)
        }
        setupNavItem()
        title = "本地书架"
        NotificationCenter.default.addObserver(self, selector: #selector(localChangeNoti(noti:)), name: NSNotification.Name.LocalShelfChanged, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        
    }
    
    private func setupNavItem() {
        let addItem = UIBarButtonItem(title: "导入本地书籍", style: UIBarButtonItem.Style.done, target: self, action: #selector(addAction))
       navigationItem.rightBarButtonItem = addItem
    }
    
    @objc
    private func addAction() {
        let importVC = ZSImportBookViewController()
        navigationController?.pushViewController(importVC, animated: true)
    }
    
    //MARK: - local handler
    @objc
    private func localChangeNoti(noti:Notification) {
        tableView.reloadData()
    }
    
    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ZSShelfManager.share.localBooks.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return ZSLocalShelfViewController.kCellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.qs_dequeueReusableCell(ZSShelfTableViewCell.self)
        cell?.configure(model: ZSShelfManager.share.localBooks[indexPath.row])
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showActivityView()
        let shelf = ZSShelfManager.share.localBooks[indexPath.row]
        if let aikan = ZSShelfManager.share.aikan(shelf) {
            jumpReader(book: aikan, indexPath: indexPath)
        } else if let book = QSReaderParse.parse(shelf: shelf) {
            ZSShelfManager.share.addAikan(book)
            jumpReader(book: book, indexPath: indexPath)
        }
        hideActivityView()
    }
    
    private func jumpReader(book:ZSAikanParserModel, indexPath:IndexPath) {
        let readerVC = ZSReaderController(chapter: nil, book, bookType: book.bookType)
        readerVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(readerVC, animated: true)
        move(from: indexPath, to: IndexPath(row: 0, section: 0))
    }

    //MARK: - changeIndex
    private func move(from:IndexPath, to:IndexPath) {
        ZSShelfManager.share.change(from: from.row, to: to.row)
        tableView.reloadData()
    }
}
