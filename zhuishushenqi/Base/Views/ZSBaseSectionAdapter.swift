
//
//  ZSBaseSectionAdapter.swift
//  zhuishushenqi
//
//  Created by caony on 2018/8/27.
//  Copyright © 2018年 QS. All rights reserved.
//

import Foundation


class ZSBaseSectionAdapter: ZSBaseCellAdapter,ZSSectionAdapterProtocol {
    
    
    var sectionTitle:String = ""
    var sectionHeight:CGFloat = 0
    
    var cellAdapter:ZSCellAdapterProtocol?
    
    override init(_ tableView: UITableView, dataSource: [Any]) {
        super.init(tableView, dataSource: dataSource)
    }
    
//    init(_ sectionTitle:String,_ sectionHeight:CGFloat) {
//        super.init(<#UITableView#>, dataSource: <#[Any]#>)
//        self.sectionTitle = sectionTitle
//        self.sectionHeight = sectionHeight
//    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?  {
        return nil
    }// custom view for header. will be adjusted to default or specified header height
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }// custom view for footer. will be adjusted to default or specified footer height
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        if let cls = registerCellClasses().first {
            cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(cls))
            
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self))
        }
        return cell
    }
    
    override func responds(to aSelector: Selector!) -> Bool {
        var responds = super.responds(to: aSelector)
        if !responds {
            responds = (self.cellAdapter?.responds(to: aSelector))!
        }
        return responds
    }
}
