//
//  ZSCatelogDetailViewModel.swift
//  zhuishushenqi
//
//  Created by caony on 2019/3/18.
//  Copyright © 2019年 QS. All rights reserved.
//

import Foundation
import ZSAPI

class ZSCatelogViewModel  {
    
    var catelogModel:ZSCatelogModel = ZSCatelogModel()
    func request(_ handler:ZSBaseCallback<Void>?) {
        let api = ZSAPI.category("" as AnyObject)
        zs_get(api.path, parameters: api.parameters) { (response) in
            guard let books = response else {
                handler?(nil)
                return 
            }
            if let catelogModel = ZSCatelogModel.deserialize(from: books) {
                self.catelogModel = catelogModel
            }
            handler?(nil)
        }
    }
}
