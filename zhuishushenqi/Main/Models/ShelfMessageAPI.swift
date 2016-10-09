//
//  ShelfMessageAPI.swift
//  zhuishushenqi
//
//  Created by caonongyun on 16/9/17.
//  Copyright © 2016年 CNY. All rights reserved.
//

import UIKit

class ShelfMessageAPI: XYCBaseRequest {
    override func requestUrl() -> String {
        return "/notification/shelfMessage"
    }
    
    override func requestMethod() -> XYCRequestMethod? {
        return XYCRequestMethod.Get
    }
    
    override func requestArgument() -> AnyObject? {
        return ["platform":"ios"]
    }
}
