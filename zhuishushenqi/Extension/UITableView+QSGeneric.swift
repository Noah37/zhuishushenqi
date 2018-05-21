//
//  UITableView+QSCreate.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/3/19.
//  Copyright © 2017年 QS. All rights reserved.
//

import Foundation
import UIKit

extension UITableView{
    
    private struct AssociatedKey {
        static var viewExtension = "viewExtension"
    }
    
    var tableHander: ZSBaseTableViewManger {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.viewExtension) as! ZSBaseTableViewManger
        }
        set {
            newValue.handleTableViewDatasourceAndDelegate(table: self)
            objc_setAssociatedObject(self, &AssociatedKey.viewExtension, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func qs_registerCellNib<T:UITableViewCell>(_ aClass:T.Type){
        let name = String(describing: aClass)
        let nib = UINib(nibName: name, bundle: nil)
        self.register(nib, forCellReuseIdentifier: name)
    }
    
    func qs_registerCellClass<T:UITableViewCell>(_ aClass:T.Type){
        let name = String(describing:aClass)
        self.register(aClass, forCellReuseIdentifier: name)
    }
    
    func qs_dequeueReusableCell<T:UITableViewCell>(_ aClass:T.Type)->T!{
        let name = String(describing:aClass)
        guard let cell = dequeueReusableCell(withIdentifier: name) as? T else {
            fatalError("\(name) is not registered")
        }
        return cell
    }
    
    func qs_registerHeaderFooterNib<T:UIView>(_ aClass:T.Type){
        let name = String(describing: aClass)
        let nib = UINib(nibName: name, bundle: nil)
        self.register(nib, forHeaderFooterViewReuseIdentifier: name)
    }
    
    func qs_registerHeaderFooterClass<T:UIView>(_ aClass:T.Type){
        let name = String(describing:aClass)
        self.register(aClass, forHeaderFooterViewReuseIdentifier: name)
    }
    
    func qs_dequeueReusableHeaderFooterView<T:UIView>(_ aClass:T.Type)->T!{
        let name = String(describing:aClass)
        guard let cell = dequeueReusableHeaderFooterView(withIdentifier: name) as? T else {
            fatalError("\(name) is not registered")
        }
        return cell
    }
}
