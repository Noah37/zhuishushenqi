//
//  Response.swift
//  QSNetwork
//
//  Created by caonongyun on 16/12/26.
//  Copyright © 2016年 masterY. All rights reserved.
//

import UIKit

open class Response: NSObject {
    public var request:URLRequest? { return task?.originalRequest }
    public var response:URLResponse?
    public var data:Data?
    public var error:Error?
    public var task:URLSessionTask?
    public var encoding = String.Encoding.utf8
    public var json:AnyObject?
    public var JSONReadingOptions = JSONSerialization.ReadingOptions(rawValue: 0)
    init(data:Data?,response:URLResponse?,error:Error?,task:URLSessionTask?) {
        super.init()
        self.data = data
        self.response = response
        self.error = error
        self.task = task
        jsonT()
    }
    
    func jsonT() -> Void {
        do{
            if let jsonData = self.data {
                let jsonDict:AnyObject? =  try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? AnyObject
                if let jsonD = jsonDict {
                    self.json = jsonD
                }
            }
        }catch{
            
        }
    }
}
