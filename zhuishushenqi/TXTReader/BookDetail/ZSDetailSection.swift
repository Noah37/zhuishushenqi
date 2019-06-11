//
//  ZSDetailSection.swift
//  zhuishushenqi
//
//  Created by caony on 2019/5/9.
//  Copyright © 2019年 QS. All rights reserved.
//

import Foundation

enum ZSDetailSection {
    case info(ZSDetailInfo)
    case people(ZSDetailPeople)
    case tag(ZSDetailTag)
    case intro(ZSDetailIntro)
}

// section
struct ZSDetailSectionModel {
    var secions:[ZSDetailSection] = []
    init(_ sections:[ZSDetailSection] = []) {
        self.secions = sections
    }
}

struct ZSDetailInfo:ZSDetailSectionProtocol {
    var rows:[ZSDetailInfoModel] = []
}

struct ZSDetailPeople:ZSDetailSectionProtocol {
    
}

struct ZSDetailTag:ZSDetailSectionProtocol {
    
}

struct ZSDetailIntro:ZSDetailSectionProtocol {
    
}

protocol ZSDetailSectionProtocol {
    
}

struct ZSDetailInfoModel {
    var id:String = ""
    var title:String = ""
    var updated:String = ""
    var wordCount:Int64 = 0
    var author:String = ""
    var majorCateV2:String = ""
    var cover:String = ""
}
