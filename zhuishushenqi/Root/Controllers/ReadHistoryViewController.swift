//
//  ReadHistoryViewController.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2017/6/17.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit

class ReadHistoryViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {

    var models:[BookDetail] = []
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 64, width: ScreenWidth, height: ScreenHeight - 64), style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderHeight = CGFloat.leastNormalMagnitude
        tableView.sectionFooterHeight = CGFloat.leastNormalMagnitude
        tableView.rowHeight = 93
        tableView.qs_registerCellNib(ReadHistoryCell.self)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubview()
    }
    
    func initSubview(){
        self.title = "浏览记录"
        fetchHistoryList()
        view.addSubview(self.tableView)
    }
    
    func fetchHistoryList(){
        // local list
        models = BookManager.shared.readHistory()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ReadHistoryCell? = tableView.qs_dequeueReusableCell(ReadHistoryCell.self)
        cell?.backgroundColor = UIColor.white
        cell?.selectionStyle = .none
        cell?.configureCell(model: models[indexPath.row])
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tableView.sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = models[indexPath.row]
        self.navigationController?.pushViewController(QSBookDetailRouter.createModule(id: model._id ), animated: true)
    }
}
