//
//  ZSBaseCellAdapter.swift
//  zhuishushenqi
//
//  Created by caony on 2018/8/27.
//  Copyright © 2018年 QS. All rights reserved.
//

import Foundation

class ZSBaseCellAdapter:NSObject ,ZSCellAdapterProtocol {

    var dataSource:[Any] = []
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        if let cls = registerCellClasses().first {
            cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(cls))

        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    init(_ tableView:UITableView,dataSource:[Any]) {
        super.init()
        self.dataSource = dataSource
        for cls in registerCellClasses() {
            tableView.register(cls, forCellReuseIdentifier: NSStringFromClass(cls))
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func registerCellClasses() ->[AnyClass] {
        
        return []
    }
}
