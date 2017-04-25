//
//  QSSearchResultTable.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/4/12.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit

typealias DidSelectRow = (_ indexPath:IndexPath)->Void

class QSSearchResultTable: UIView,UITableViewDataSource,UITableViewDelegate {

    var books:[Book]? {
        didSet{
            self.tableView.reloadData()
        }
    }
    var selectRow:DidSelectRow?
    
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: self.bounds.height), style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderHeight = CGFloat.leastNonzeroMagnitude
        tableView.rowHeight = 93
        tableView.qs_registerCellNib(TopDetailCell.self)
        return tableView
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 1.0, green: 0.98, blue: 0.82, alpha: 1.0)
        self.addSubview(self.tableView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return books?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TopDetailCell? = tableView.qs_dequeueReusableCell(TopDetailCell.self)
        cell?.backgroundColor = UIColor.white
        cell?.selectionStyle = .none
        cell?.model = self.books?.count ?? 0 > indexPath.row ? books?[indexPath.row]:nil
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let select = selectRow {
            select(indexPath)
        }
    }
}
