//
//  ZSBaseTableViewManger.swift
//  zhuishushenqi
//
//  Created by caony on 2018/5/21.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit

/// 选中UITableViewCell的Block
typealias didSelectTableCellBlock = (IndexPath, AnyObject) -> Void

class ZSBaseTableViewManger: NSObject, UITableViewDataSource, UITableViewDelegate {

    
    lazy var myCellIdentifiers =  [String]()
    lazy var zs_dataArrayList = []
    var didSelectCellBlock: didSelectTableCellBlock?
    
    init(cellIdentifiers: [String], didSelectBlock: @escaping didSelectTableCellBlock) {
        super.init()
        self.myCellIdentifiers = cellIdentifiers
        self.didSelectCellBlock = didSelectBlock
    }
    
    
    /**
     设置UITableView的Datasource和Delegate为self
     
     - parameter table: UITableView
     */
    func handleTableViewDatasourceAndDelegate(table: UITableView) {
        
        table.dataSource = self
        table.delegate   = self
        
    }
    /**
     获取UITableView中Item所在的indexPath
     
     - parameter indexPath: indexPath
     
     - returns: return value description
     */
    func itemAtIndexPath(indexPath: NSIndexPath) -> AnyObject {
        return zs_dataArrayList[indexPath.row] as AnyObject;
    }
    
    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return zs_dataArrayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item: AnyObject? = itemAtIndexPath(indexPath: indexPath as NSIndexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: myCellIdentifiers.first!)
        if cell == nil {
            UITableViewCell.registerTable(table: tableView, nibIdentifier: myCellIdentifiers.first!)
        }
        cell?.configure(cell: cell!, customObj: item!, indexPath: indexPath as NSIndexPath)
        
        return cell!
    }
}
