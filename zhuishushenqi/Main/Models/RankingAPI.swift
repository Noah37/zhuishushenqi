//
//  RankingAPI.swift
//  zhuishushenqi
//
//  Created by caonongyun on 16/10/1.
//  Copyright © 2016年 CNY. All rights reserved.
//

import UIKit

class RankingAPI: XYCBaseRequest{
    override func requestUrl() -> String {
        return "/ranking/gender"
    }
    
    override func requestMethod() -> XYCRequestMethod? {
        return XYCRequestMethod.Get
    }
    
    override func requestArgument() -> AnyObject? {
        return []
    }
}
