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
            self.tableView.register(cls, forCellReuseIdentifier: NSStringFromClass(cls))
        }
    }

    func registerCellClasses() -> Array<AnyClass> {
        return []
    }
}
