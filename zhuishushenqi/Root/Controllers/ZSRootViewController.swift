//
//  ZSRootViewController.swift
//  zhuishushenqi
//
//  Created by caony on 2018/5/21.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit
import Then

class ZSRootViewController: UIViewController {
    
    static let kCellHeight:CGFloat = 60

    var tableView = UITableView(frame: CGRect.zero, style: .grouped).then {
        $0.estimatedRowHeight = kCellHeight
        $0.rowHeight = UITableViewAutomaticDimension
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func bindViewModel() {
        
    }

}
