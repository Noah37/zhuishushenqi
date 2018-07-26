//
//  QSSearchAutoCompleteTable.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/4/13.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit

class ZSSearchAutoCompleteController: ZSBaseTableViewController ,UISearchResultsUpdating{
    
    var books:[String] = [] { didSet{ self.tableView.reloadData() } }
    
    var selectRow:DidSelectRow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 1.0, green: 0.98, blue: 0.82, alpha: 1.0)
        tableView.qs_registerCellClass(UITableViewCell.self)
//        automaticallyAdjustsScrollViewInsets = false
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .automatic
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return books.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell? = tableView.qs_dequeueReusableCell(UITableViewCell.self)
        cell?.backgroundColor = UIColor.white
        cell?.selectionStyle = .none
        cell?.textLabel?.text = self.books.count  > indexPath.row ? books[indexPath.row]:""
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let select = selectRow {
            select(indexPath)
        }
    }
    
    //MARK: - UISearchBarDelegate
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

class QSSearchAutoCompleteTable: UIView,UITableViewDataSource,UITableViewDelegate {
    
    var books:[String]? {
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
        tableView.rowHeight = 44
        tableView.qs_registerCellClass(UITableViewCell.self)
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
        let cell:UITableViewCell? = tableView.qs_dequeueReusableCell(UITableViewCell.self)
        cell?.backgroundColor = UIColor.white
        cell?.selectionStyle = .none
        cell?.textLabel?.text = self.books?.count ?? 0 > indexPath.row ? books?[indexPath.row]:""
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
