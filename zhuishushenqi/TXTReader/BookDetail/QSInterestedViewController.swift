//
//  QSInterestedViewController.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2017/6/26.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit

class QSInterestedViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {
    var books:[Book] = []
    
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 64, width: ScreenWidth, height: ScreenHeight - 64), style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderHeight = CGFloat.leastNormalMagnitude
        tableView.sectionFooterHeight = CGFloat.leastNormalMagnitude
        tableView.rowHeight = 93
        tableView.qs_registerCellNib(TopDetailCell.self)
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubview()
    }
    
    func initSubview(){
        self.title = "你可能感兴趣"
        view.addSubview(self.tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TopDetailCell? = tableView.qs_dequeueReusableCell(TopDetailCell.self)
        cell?.backgroundColor = UIColor.white
        cell?.selectionStyle = .none
        cell!.model = books[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tableView.sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let id = books[indexPath.row]._id ?? ""
        self.navigationController?.pushViewController(QSBookDetailRouter.createModule(id: id), animated: true)
    }
}
