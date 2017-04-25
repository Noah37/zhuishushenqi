//
//  RankingAPI.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 16/10/1.
//  Copyright © 2016年 QS. All rights reserved.
//

import UIKit

class RankingAPI: XYCBaseRequest{
    override func requestUrl() -> String {
        return "/ranking/gender"
    }
    
    override func requestMethod() -> XYCRequestMethod? {
        return XYCRequestMethod.get
    }
    
    override func requestArgument() -> NSDictionary? {
        return ["":""]
    }
}
