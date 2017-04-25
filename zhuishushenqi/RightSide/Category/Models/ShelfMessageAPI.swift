//
//  ShelfMessageAPI.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 16/9/17.
//  Copyright © 2016年 QS. All rights reserved.
//

import UIKit

class ShelfMessageAPI: XYCBaseRequest {
    override func requestUrl() -> String {
        return "/notification/shelfMessage"
    }
    
    override func requestMethod() -> XYCRequestMethod? {
        return XYCRequestMethod.get
    }
    
    override func requestArgument() -> NSDictionary? {
        return ["platform":"ios"]
    }
}
