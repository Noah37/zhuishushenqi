//
//  ZSDiscoverItem.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2019/7/7.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit

enum ZSDiscoverMenuItemType {
    case vip
    case free
    case manhua
    case audio
    case random
    case personal
    case hunt
}

class ZSDiscoverItem {
    var type:ZSDiscoverMenuItemType = .vip
    var title:String?
    var icon:String?
    
    init(type:ZSDiscoverMenuItemType,
         title:String?,
        icon:String?) {
        self.type = type
        self.title = title
        self.icon = icon
    }
}
