//
//  ZSBaseTableViewController.swift
//  zhuishushenqi
//
//  Created by caony on 2018/6/7.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit

class ZSBaseTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.white
        self.tableView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        navigationController?.navigationBar.tintColor = UIColor.red
        navigationController?.navigationBar.barTintColor = UIColor.white
        register()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    
    override var prefersStatusBarHidden : Bool {
        return false
    }
    
    private func register(){
        let classes = registerCellClasses()
        for cls in classes {
            self.tableView.qs_registerCellClass(cls as! UITableViewCell.Type)
        }
        let nibClasses = registerCellNibs()
        for cls in nibClasses {
            self.tableView.qs_registerCellNib(cls as! UITableViewCell.Type)
        }
        
        let headerClasses = registerHeaderViewClasses()
        for cls in headerClasses {
            self.tableView.qs_registerHeaderFooterClass(cls as! UITableViewHeaderFooterView.Type)
        }
        let footerClasses = registerFooterViewClasses()
        for cls in footerClasses {
            self.tableView.qs_registerHeaderFooterClass(cls as! UITableViewHeaderFooterView.Type)
        }
    }
    
    func registerHeaderViewClasses() -> Array<AnyClass> {
        return []
    }
    
    func registerFooterViewClasses() -> Array<AnyClass> {
        return []
    }

    func registerCellClasses() -> Array<AnyClass> {
        return []
    }
    
    func registerCellNibs() -> Array<AnyClass> {
        return []
    }
}
