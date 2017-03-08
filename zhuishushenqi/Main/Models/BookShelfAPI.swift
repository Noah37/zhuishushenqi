//
//  BookShelfAPI.swift
//  zhuishushenqi
//
//  Created by caonongyun on 16/10/5.
//  Copyright © 2016年 CNY. All rights reserved.
//

import UIKit

class BookShelfAPI: XYCBaseRequest {
    override func requestUrl() -> String {
        return "/user/bookshelf"
    }
    
    override func requestMethod() -> XYCRequestMethod? {
        return XYCRequestMethod.get
    }
    
    override func requestArgument() -> NSDictionary? {
        return ["books":"","token":"pv4GJDGNlK6xomuTblrFSM5q"]
    }
}
