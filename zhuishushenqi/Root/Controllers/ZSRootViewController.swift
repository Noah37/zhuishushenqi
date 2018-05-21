//
//  ZSRootViewController.swift
//  zhuishushenqi
//
//  Created by caony on 2018/5/21.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit

class ZSRootViewController: UIViewController {

    var tableView:UITableView!
    fileprivate let kCellHeight:CGFloat = 60

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        
    }
    
    private func configureTableView() {
        tableView.estimatedRowHeight = kCellHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    private func bindViewModel() {
        
    }

}
