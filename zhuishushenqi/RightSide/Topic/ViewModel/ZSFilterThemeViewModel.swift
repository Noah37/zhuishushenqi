//
//  ZSFilterThemeViewModel.swift
//  zhuishushenqi
//
//  Created by caony on 2019/3/22.
//  Copyright © 2019年 QS. All rights reserved.
//

import Foundation
import ZSAPI

class ZSFilterThemeViewModel {
    
    var items:[ZSFilterThemeModel] = []
    
    func request(_ handler:ZSBaseCallback<Void>?) {
        let api = ZSAPI.tagType("" as AnyObject)
        zs_get(api.path, parameters: nil) { (response) in
            guard let books = response?["data"] as? [Any] else {
                handler?(nil)
                return
            }
            if let items = [ZSFilterThemeModel].deserialize(from: books) as? [ZSFilterThemeModel] {
                self.items = []
                var item = ZSFilterThemeModel()
                item.name = ""
                item.tags = ["全部书单"]
                self.items.append(item)
                var itemGender = ZSFilterThemeModel()
                itemGender.name = "性别"
                itemGender.tags = ["男","女"]
                self.items.append(itemGender)
                self.items.append(contentsOf: items)
            }
            handler?(nil)
        }
    }
}
