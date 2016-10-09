//
//  AddBookAPI.swift
//  zhuishushenqi
//
//  Created by caonongyun on 16/10/5.
//  Copyright © 2016年 CNY. All rights reserved.
//

import UIKit

class AddBookAPI: XYCBaseRequest {
    
    var id:String?
    override func requestUrl() -> String {
        return "/user/bookshelf"
    }
    
    override func requestMethod() -> XYCRequestMethod? {
        return XYCRequestMethod.Post
    }
    
    override func requestArgument() -> AnyObject? {
        return ["token":"iGbZwXqxxsf1A8duVXyyReLq","books":id ?? ""]
    }
}
