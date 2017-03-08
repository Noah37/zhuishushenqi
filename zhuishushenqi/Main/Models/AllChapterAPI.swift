//
//  AllChapterAPI.swift
//  zhuishushenqi
//
//  Created by caonongyun on 16/10/11.
//  Copyright © 2016年 XYC. All rights reserved.
//

import UIKit

class AllChapterAPI: XYCBaseRequest {
    var id:NSString = ""
    
    override func requestUrl() -> String {
        return "/ctoc/\(id)"
    }
    
    override func requestMethod() -> XYCRequestMethod? {
        return XYCRequestMethod.get
    }
    
    override func requestArgument() -> NSDictionary? {
        return ["view":"chapters"]
    }
}
