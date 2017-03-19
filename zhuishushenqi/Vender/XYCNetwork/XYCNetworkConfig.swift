//
//  XYCNetworkConfig.swift
//  CNYNetworking
//
//  Created by caonongyun on 16/7/14.
//  Copyright © 2016年 CNY. All rights reserved.
//

import UIKit

public protocol XYCUrlFilterProtocol {
    func filterUrl(_ originUrl:String,withRequest request:XYCBaseRequest) ->String
}

open class XYCNetworkConfig: NSObject {
    
    open var baseUrl:String?
    open var cdnUrl:String?
    open var urlFilters:NSMutableArray?
    
    fileprivate var cacheDirPathFilters = NSMutableArray()
    
    open func addfilter(_ filter:XYCUrlFilterProtocol){
        urlFilters!.add(filter as AnyObject)
    }
    
    open static let sharedInstance = XYCNetworkConfig()
    fileprivate override init() {
        urlFilters = NSMutableArray()
    }

}
