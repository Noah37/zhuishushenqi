//
//  XYCNetworkConfig.swift
//  CNYNetworking
//
//  Created by caonongyun on 16/7/14.
//  Copyright © 2016年 CNY. All rights reserved.
//

import UIKit

public protocol XYCUrlFilterProtocol {
    func filterUrl(originUrl:String,withRequest request:XYCBaseRequest) ->String
}

public class XYCNetworkConfig: NSObject {
    
    public var baseUrl:String?
    public var cdnUrl:String?
    public var urlFilters:NSMutableArray?
    
    private var cacheDirPathFilters = NSMutableArray()
    
    public func addfilter(filter:XYCUrlFilterProtocol){
        urlFilters!.addObject(filter as! AnyObject)
    }
    
    public static let sharedInstance = XYCNetworkConfig()
    private override init() {
        urlFilters = NSMutableArray()
    }

}
