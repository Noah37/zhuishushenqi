//
//  RankingDetailAPI.swift
//  zhuishushenqi
//
//  Created by caonongyun on 16/10/3.
//  Copyright © 2016年 CNY. All rights reserved.
//

import UIKit

class RankingDetailAPI: XYCBaseRequest {
    
    var id:NSString = ""
    
    override func requestUrl() -> String {
        return "/ranking/\(id)"
    }
    
    override func requestMethod() -> XYCRequestMethod? {
        return XYCRequestMethod.Get
    }
    
    override func requestArgument() -> AnyObject? {
        return []
    }
}
