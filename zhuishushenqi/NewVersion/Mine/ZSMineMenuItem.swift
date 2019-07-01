//
//  ZSMineMenuItem.swift
//  zhuishushenqi
//
//  Created by caony on 2019/7/1.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit

enum ZSMineMenuItemType {
    case account
    case vip
    case id
    case level
    case message
    case history
    case booklist
    case topic
    case question
    case comment
    case feedback
    case darkmode
    case setting
}

enum ZSMineMenuItemDisclosureType {
    case none
    case controller
    case controllerWithDisclosureText
    case controllerWithTitle
    case externalLink
    case swtch
    case titleButton
}

class ZSMineMenuItem {

    var type:ZSMineMenuItemType = .account
    var title:String?
    var icon:String?
    var detailTitle:String?
    var disclosureText:String?
    var disclosureType:ZSMineMenuItemDisclosureType = .none
    var isSwitchOn:Bool = false
    var cellType:ZSDetailButtonCellType = .none
    
    init(type:ZSMineMenuItemType, disclosureType:ZSMineMenuItemDisclosureType,
        cellType:ZSDetailButtonCellType,
        isSwitchOn:Bool,
        title:String?,
        icon:String?,
        detailTitle:String?,
        disclosureText:String?) {
        
        self.type = type
        self.disclosureType = disclosureType
        self.cellType = cellType
        self.isSwitchOn = isSwitchOn
        self.title = title
        self.icon = icon
        self.detailTitle = detailTitle
        self.disclosureText = disclosureText
    }
}
