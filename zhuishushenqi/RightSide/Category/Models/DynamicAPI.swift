//
//  DynamicAPI.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 16/10/22.
//  Copyright © 2016年 QS. All rights reserved.
//

import UIKit

class DynamicAPI: XYCBaseRequest {
    var id:NSString = "57ac9879c12b61e826bd7221"
    
    override func requestUrl() -> String {
        return "/user/twitter/timeline/\(id)"
    }
    
    override func requestMethod() -> XYCRequestMethod? {
        return XYCRequestMethod.get
    }
    
    override func requestArgument() -> NSDictionary? {
        return ["token":"EsIH3Jn6Pn4md8Pe7uEc8GFA"]
    }
}
