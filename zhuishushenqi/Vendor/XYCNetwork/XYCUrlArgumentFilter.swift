//
//  XYCUrlArgumentFilter.swift
//  QSNetworking
//
//  Created by Nory Cao on 16/7/14.
//  Copyright © 2016年 QS. All rights reserved.
//

import UIKit

open class XYCUrlArgumentFilter: NSObject,XYCUrlFilterProtocol{

    open var arguments:NSDictionary?
    public init(WithArguments _arguments:NSDictionary) {
        super.init()
        arguments = _arguments
    }
    
    open class func filterWithArguments(_ arguments:NSDictionary) ->XYCUrlArgumentFilter{
        let filter:XYCUrlArgumentFilter = XYCUrlArgumentFilter(WithArguments:arguments)
        return filter
    }
    
    open func filterUrl(_ originUrl:String,withRequest request:XYCBaseRequest) ->String
    {
        return XYCNetworkPrivate.urlStringWithOriginUrlString(originUrl, appendParameters: arguments)
    }
}
