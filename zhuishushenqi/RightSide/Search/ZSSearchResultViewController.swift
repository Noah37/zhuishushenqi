//
//  ZSSearchResultViewController.swift
//  zhuishushenqi
//
//  Created by yung on 2018/7/1.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit

class ZSSearchResultViewController: ZSBaseTableViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 1.0, green: 0.98, blue: 0.82, alpha: 1.0)

        tableView.sectionHeaderHeight = CGFloat.leastNonzeroMagnitude
        tableView.rowHeight = 93
        tableView.qs_registerCellNib(TopDetailCell.self)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    var books:[Book]? {
        didSet{
            self.tableView.reloadData()
        }
    }
    var selectRow:DidSelectRow?
    
    var didSelectIndexPathAtRow:ZSBaseCallback<Book>?
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return books?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TopDetailCell? = tableView.qs_dequeueReusableCell(TopDetailCell.self)
        cell?.backgroundColor = UIColor.white
        cell?.selectionStyle = .none
        cell?.model = self.books?.count ?? 0 > indexPath.row ? books?[indexPath.row]:nil
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let select = selectRow {
            select(indexPath)
        }
        if let didSelect = didSelectIndexPathAtRow {
            didSelect(books?[indexPath.row])
        }
    }

}
