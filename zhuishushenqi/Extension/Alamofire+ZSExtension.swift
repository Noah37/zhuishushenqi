//
//  Alamofire+ZSExtension.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2018/7/31.
//  Copyright © 2018年 QS. All rights reserved.
//

import Foundation
import Alamofire

public func zs_get(_ urlStr: String,parameters: Parameters? = nil) -> DataRequest {
    return request(urlStr, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
}

public func zs_post(_ urlStr: String,parameters: Parameters? = nil) -> DataRequest {
    return request(urlStr, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
}
