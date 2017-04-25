//
//  BookShelfAPI.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 16/10/5.
//  Copyright © 2016年 QS. All rights reserved.
//

import UIKit

class BookShelfAPI: XYCBaseRequest {
    override func requestUrl() -> String {
        return "/user/BOOKSHELF"
    }
    
    override func requestMethod() -> XYCRequestMethod? {
        return XYCRequestMethod.get
    }
    
    override func requestArgument() -> NSDictionary? {
        return ["books":"","token":"pv4GJDGNlK6xomuTblrFSM5q"]
    }
}
