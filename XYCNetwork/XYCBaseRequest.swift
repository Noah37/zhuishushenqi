//
//  XYCBaseRequest.swift
//  CNYNetworking
//
//  Created by caonongyun on 16/7/14.
//  Copyright © 2016年 CNY. All rights reserved.
//

import UIKit
import Alamofire

public enum XYCRequestMethod:Int{
    case Get = 0
    case Post
}

public typealias XYCRequestCompletionBlock = (request:AnyObject) ->Void

public class XYCBaseRequest: NSObject {

    public var successCompletionBlock:XYCRequestCompletionBlock?
    public var failureCompletionBlock:XYCRequestCompletionBlock?
    
    public func baseUrl() ->String{
        return ""
    }
    
    public func requestUrl() ->String {
        return ""
    }
    
    public func requestArgument() ->AnyObject?{
        return nil
    }
    
    public func requestMethod() ->XYCRequestMethod?{
        return XYCRequestMethod.Get;
    }
    
    public func startWithCompletionBlockWithSuccess(successCompletionBlock:XYCRequestCompletionBlock,failureCompletionBlock:XYCRequestCompletionBlock){
        self.successCompletionBlock = successCompletionBlock
        self.failureCompletionBlock = failureCompletionBlock
        start()
    }
    
    public func startWithCompletionBlockWithHUD(successCompletionBlock:XYCRequestCompletionBlock,failureCompletionBlock:XYCRequestCompletionBlock){
        HUD.showProgressHud(false)
        startWithCompletionBlockWithSuccess(successCompletionBlock, failureCompletionBlock: failureCompletionBlock)
    }
    
    public func start(){
        XYCNetworkAgent.sharedInstance.addRequest(self)
    }
}

let RequestValidRespondKey:UnsafePointer<Void> = UnsafePointer(bitPattern: 12131)
let resultMap = "resultMap"

public extension XYCBaseRequest
{

    func transactionWithSuccess(success: XYCRequestCompletionBlock? = nil,failure:XYCRequestCompletionBlock? = nil){
        startWithCompletionBlockWithHUD({ (request) in
            let dict = request as? NSDictionary
            dict?.addAssociatedObject(request.objectForKey("resultMap")!)
            if success != nil {
                success!(request: dict!)
            }
            }) { (request) in
                if failure != nil{
                    failure!(request:request)
                }
        }
    }
    
}

public extension NSDictionary
{
    func addAssociatedObject(object:AnyObject){
        objc_setAssociatedObject(self, RequestValidRespondKey, object, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    //获取关联对象
    func resultMap() ->AnyObject{
        return objc_getAssociatedObject(self, RequestValidRespondKey)
    }
}

