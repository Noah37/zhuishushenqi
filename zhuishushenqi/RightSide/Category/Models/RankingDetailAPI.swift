//
//  RankingDetailAPI.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 16/10/3.
//  Copyright © 2016年 QS. All rights reserved.
//

import UIKit

class RankingDetailAPI: XYCBaseRequest {
    
    var id:NSString = ""
    
    override func requestUrl() -> String {
        return "/ranking/\(id)"
    }
    
    override func requestMethod() -> XYCRequestMethod? {
        return XYCRequestMethod.get
    }
    
    override func requestArgument() -> NSDictionary? {
        return ["": ""]
    }
}
