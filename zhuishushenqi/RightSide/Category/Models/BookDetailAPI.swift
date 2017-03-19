//
//  BookDetailAPI.swift
//  zhuishushenqi
//
//  Created by Nory Chao on 16/10/4.
//  Copyright © 2016年 QS. All rights reserved.
//

import UIKit

class BookDetailAPI: XYCBaseRequest {
    var id:NSString = ""
    
    override func requestUrl() -> String {
        return "/book/\(id)"
    }
    
    override func requestMethod() -> XYCRequestMethod? {
        return XYCRequestMethod.get
    }
    
    override func requestArgument() -> NSDictionary? {
        return ["":""]
    }
}
