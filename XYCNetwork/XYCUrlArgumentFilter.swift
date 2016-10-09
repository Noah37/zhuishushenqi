//
//  XYCUrlArgumentFilter.swift
//  CNYNetworking
//
//  Created by caonongyun on 16/7/14.
//  Copyright © 2016年 CNY. All rights reserved.
//

import UIKit

public class XYCUrlArgumentFilter: NSObject,XYCUrlFilterProtocol{

    public var arguments:NSDictionary?
    public init(WithArguments _arguments:NSDictionary) {
        super.init()
        arguments = _arguments
    }
    
    public class func filterWithArguments(arguments:NSDictionary) ->XYCUrlArgumentFilter{
        let filter:XYCUrlArgumentFilter = XYCUrlArgumentFilter(WithArguments:arguments)
        return filter
    }
    
    public func filterUrl(originUrl:String,withRequest request:XYCBaseRequest) ->String
    {
        return XYCNetworkPrivate.urlStringWithOriginUrlString(originUrl, appendParameters: arguments)
    }
}
