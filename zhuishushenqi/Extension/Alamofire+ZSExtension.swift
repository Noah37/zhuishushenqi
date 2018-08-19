//
//  Alamofire+ZSExtension.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2018/7/31.
//  Copyright © 2018年 QS. All rights reserved.
//

import Foundation
import Alamofire

@discardableResult
func zs_get(_ urlStr: String,parameters: Parameters? = nil) -> DataRequest {
    return zs_get(urlStr, parameters: parameters, nil)
}

public func zs_post(_ urlStr: String,parameters: Parameters? = nil) -> DataRequest {
    return request(urlStr, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
}

@discardableResult
func zs_get(_ urlStr: String,parameters: Parameters? = nil,_ handler:ZSBaseCallback<[String:Any]>?) -> DataRequest {
    let req = request(urlStr, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
        if let data = response.data {
            if let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any] {
                handler?(json)
            }
        }
    }
    return req
}
