//
//  UICollectionView+QSExtension.swift
//  zhuishushenqi
//
//  Created by yung on 2017/8/22.
//  Copyright © 2017年 QS. All rights reserved.
//

import Foundation
import UIKit

protocol ReusableView: class {
    static var reuseId: String {get}
}

extension ReusableView where Self: UIView {
    static var reuseId: String {
        return String(describing: self)
    }
}

extension UICollectionReusableView: ReusableView {
    
}

extension UICollectionView {
    func qs_registerCellNib<T:UICollectionViewCell>(_ aClass:T.Type){
        let name = String(describing: aClass)
        let nib = UINib(nibName: name, bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: name)
    }
    
    func qs_registerCellClass<T:UICollectionViewCell>(_ aClass:T.Type){
        let name = String(describing:aClass)
        self.register(aClass, forCellWithReuseIdentifier: name)
    }
    
    func qs_dequeueReusableCell<T:UICollectionViewCell>(_ aClass:T.Type, for indexPath:IndexPath)->T where T:ReusableView{
        let name = String(describing:aClass)
        guard let cell = dequeueReusableCell(withReuseIdentifier: name, for: indexPath) as? T else {
            fatalError("\(name) is not registered")
        }
        return cell
    }
    
//    func qs_registerHeaderFooterNib<T:UIView>(_ aClass:T.Type){
//        let name = String(describing: aClass)
//        let nib = UINib(nibName: name, bundle: nil)
//        self.register(nib, forHeaderFooterViewReuseIdentifier: name)
//    }
//    
//    func qs_registerHeaderFooterClass<T:UIView>(_ aClass:T.Type){
//        let name = String(describing:aClass)
//        self.register(aClass, forHeaderFooterViewReuseIdentifier: name)
//    }
//    
//    func qs_dequeueReusableHeaderFooterView<T:UIView>(_ aClass:T.Type)->T!{
//        let name = String(describing:aClass)
//        guard let cell = dequeueReusableHeaderFooterView(withIdentifier: name) as? T else {
//            fatalError("\(name) is not registered")
//        }
//        return cell
//    }
}
