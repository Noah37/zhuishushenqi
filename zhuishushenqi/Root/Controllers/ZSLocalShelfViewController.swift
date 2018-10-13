//
//  ZSLocalShelfViewController.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2018/7/31.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit
import SnapKit

class ZSLocalShelfViewController: BaseViewController ,UITableViewDataSource,UITableViewDelegate {
    
    var tableView:UITableView = UITableView(frame: CGRect.zero, style: .grouped).then {
        $0.qs_registerCellClass(SwipableCell.self)
        $0.rowHeight = kCellHeight
        $0.estimatedRowHeight = kCellHeight
        $0.estimatedSectionHeaderHeight = 0.01
    }
    
    static let kCellHeight:CGFloat = 60
    
    var viewModel = ZSLocalShelfViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "本地书架"
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
//        viewModel.fetchBook(path: <#T##String#>, completion: <#T##((BookDetail) -> Void)?##((BookDetail) -> Void)?##(BookDetail) -> Void#>)
//        viewModel.fetchBook(path: <#T##String#>, completion: <#T##((BookDetail) -> Void)?##((BookDetail) -> Void)?##(BookDetail) -> Void#>)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kNavgationBarHeight)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.paths.count
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
        let cell = tableView.dequeueReusableCell(withIdentifier: SwipableCell.reuseIdentifier, for: indexPath) as! SwipableCell
        cell.title?.text = ((viewModel.paths[indexPath.row] as NSString).lastPathComponent as NSString).deletingPathExtension
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showActivityView()
        let path = viewModel.paths[indexPath.row]
        viewModel.fetchBook(path: path) { (book) in
            self.hideActivityView()
            let viewController = QSTextRouter.createModule(bookDetail: book, callback: { (book) in
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
