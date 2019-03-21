//
//  ZSCatelogModel.swift
//  zhuishushenqi
//
//  Created by caony on 2019/3/18.
//  Copyright © 2019年 QS. All rights reserved.
//

import Foundation
import HandyJSON

struct ZSCatelogItem:HandyJSON {
    var name:String
    var bookCount:Int
    var monthlyCount:Int
    var icon:String
    var bookCover:[String]
    
    init() {
        self.name = ""
        self.bookCount = 0
        self.monthlyCount = 0
        self.icon = ""
        self.bookCover = []
    }
}

struct ZSCatelogModel:HandyJSON {
    var female:[ZSCatelogItem]
    var male:[ZSCatelogItem]
    var picture:[ZSCatelogItem]
    var press:[ZSCatelogItem]
    var code:Bool
    init() {
        self.female = []
        self.male = []
        self.picture = []
        self.press = []
        self.code = false
    }
    
    func sections() ->Int {
        var count = 0
        if self.female.count > 0 {
            count += 1
        }
        if self.male.count > 0 {
            count += 1
        }
        if self.picture.count > 0 {
            count += 1
        }
        if self.press.count > 0 {
            count += 1
        }
        return count
    }
    
    func items(at index:Int) ->[ZSCatelogItem] {
        var items:[ZSCatelogItem] = []
        switch index {
        case 0:
            items = self.male
            break
        case 1:
            items = self.female
            break
        case 2:
            items = self.picture
            break
        case 3:
            items = self.press
        default:
            items = []
        }
        return items
    }
    
    func gender(for section:Int) ->String {
        var gender:String = ""
        switch section {
        case 0:
            gender = "male"
            break
        case 1:
            gender = "female"
            break
        case 2:
            gender = "picture"
            break
        case 3:
            gender = "press"
            break
        default:
            gender = ""
        }
        return gender
    }
    
    func name(for section:Int) ->String {
        var name:String = ""
        switch section {
        case 0:
            name = "男生"
            break
        case 1:
            name = "女生"
            break
        case 2:
            name = "漫画"
            break
        case 3:
            name = "出版"
            break
        default:
            name = ""
        }
        return name
    }
}
