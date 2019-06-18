//
//  UITableViewCell+ZSExtension.swift
//  zhuishushenqi
//
//  Created by caony on 2018/5/21.
//  Copyright © 2018年 QS. All rights reserved.
//

import Foundation


public extension UITableViewCell {
    class public func nibWithIdentifier(identifier: String) -> UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
    
    /**
     从nib文件中根据重用标识符注册UITableViewCell
     
     - parameter table:      table description
     - parameter identifier: identifier description
     */
    class public func registerTable(table: UITableView, nibIdentifier identifier: String) {
        return table.register(self.nibWithIdentifier(identifier: identifier), forCellReuseIdentifier: identifier)
    }
    
    /**
     配置UITableViewCell，设置UITableViewCell内容
     
     - parameter cell:      cell description
     - parameter obj:       obj description
     - parameter indexPath: indexPath description
     */
    public func configure(cell: UITableViewCell, customObj obj: AnyObject, indexPath: NSIndexPath) {
        // Rewrite this func in SubClass !
    }
    
    /**
     获取自定义对象的cell高度 (已集成UITableView+FDTemplateLayoutCell，现在创建的cell自动计算高度)
     
     - parameter obj:       obj description
     - parameter indexPath: indexPath description
     
     - returns: return value description
     */
    class public func getCellHeightWithCustomObj(obj: AnyObject?, indexPath: NSIndexPath) -> CGFloat {
        // Rewrite this func in SubClass if necessary
        return obj == nil ? 44.0 : 0.0   // default cell height 44.0
    }
}
