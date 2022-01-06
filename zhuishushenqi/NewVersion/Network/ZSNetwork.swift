//
//  ZSNetwork.swift
//  zhuishushenqi
//
//  Created by yung on 2022/1/6.
//  Copyright © 2022 QS. All rights reserved.
//

import Foundation
import Alamofire

class ZSNet {
    
    @discardableResult
    public class func GET(_ urlStr: String,parameters: Parameters? = nil,_ handler:@escaping ZSBaseCallback<Any?>) -> DataRequest {
        var headers = SessionManager.defaultHTTPHeaders
        headers["User-Agent"] = YouShaQiUserAgent
        let req = request(urlStr, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            if let data = response.data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) {
                    handler(json)
                } else {
                    handler(nil)
                }
            } else {
                handler(nil)
            }
        }
        return req
    }
    
    @discardableResult
    public class func getJSON(_ urlStr: String,parameters: Parameters? = nil,_ handler:@escaping ZSBaseCallback<[String:Any]>) -> DataRequest {
        let req = GET(urlStr, parameters: parameters) { (data) in
            if let json = data as? [String:Any] {
                handler(json)
            } else {
                handler([:])
            }
        }
        return req
    }
    
    @discardableResult
    public class func getJSONArray(_ urlStr: String,parameters: Parameters? = nil,_ handler:@escaping ZSBaseCallback<[[String:Any]]>) -> DataRequest {
        let req = GET(urlStr, parameters: parameters) { (data) in
            if let json = data as? [[String:Any]] {
                handler(json)
            } else {
                handler([[:]])
            }
        }
        return req
    }
    
    @discardableResult
    public class func POST(_ urlStr: String,parameters: Parameters? = nil,_ handler:@escaping ZSBaseCallback<Any?>) -> DataRequest {
        var headers = SessionManager.defaultHTTPHeaders
        headers["User-Agent"] = YouShaQiUserAgent
        let req = request(urlStr, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            if let data = response.data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) {
                    handler(json)
                } else {
                    handler(nil)
                }
            } else {
                handler(nil)
            }
        }
        return req
    }
}
