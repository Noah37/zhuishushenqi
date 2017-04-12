//
//  XYCBaseRequest.swift
//  QSNetworking
//
//  Created by Nory Chao on 16/7/14.
//  Copyright © 2016年 QS. All rights reserved.
//

import UIKit


public enum XYCRequestMethod:Int{
    case get = 0
    case post
}

public typealias XYCRequestCompletionBlock = (_ request:AnyObject) ->Void

open class XYCBaseRequest: NSObject {

    open var successCompletionBlock:XYCRequestCompletionBlock?
    open var failureCompletionBlock:XYCRequestCompletionBlock?
    
    open func BASEURL() ->String{
        return ""
    }
    
    open func requestUrl() ->String {
        return ""
    }
    
    open func requestArgument() ->NSDictionary?{
        return nil
    }
    
    open func requestMethod() ->XYCRequestMethod?{
        return XYCRequestMethod.get;
    }
    
    open func startWithCompletionBlockWithSuccess(_ successCompletionBlock:@escaping XYCRequestCompletionBlock,failureCompletionBlock:@escaping XYCRequestCompletionBlock){
        self.successCompletionBlock = successCompletionBlock
        self.failureCompletionBlock = failureCompletionBlock
        start()
    }
    
    open func startWithCompletionBlockWithHUD(_ successCompletionBlock:@escaping XYCRequestCompletionBlock,failureCompletionBlock:@escaping XYCRequestCompletionBlock){
//        HUD.showProgressHud(false)
        startWithCompletionBlockWithSuccess(successCompletionBlock, failureCompletionBlock: failureCompletionBlock)
    }
    
    open func start(){
//        XYCNetworkAgent.sharedInstance.addRequest(self)
    }
}

let RequestValidRespondKey:UnsafeRawPointer = UnsafeRawPointer(bitPattern: 12131)!
let resultMap = "resultMap"

public extension XYCBaseRequest
{

//    func transactionWithSuccess(_ success: XYCRequestCompletionBlock? = nil,failure:XYCRequestCompletionBlock? = nil){
//        startWithCompletionBlockWithHUD({ (request) in
//            let dict = request as? NSDictionary
//            dict?.addAssociatedObject(request.object(forKey: "resultMap")!)
//            if success != nil {
//                success!(dict!)
//            }
//            }) { (request) in
//                if failure != nil{
//                    failure!(request)
//                }
//        }
//    }
}


public extension NSDictionary
{
    func addAssociatedObject(_ object:AnyObject){
        objc_setAssociatedObject(self, RequestValidRespondKey, object, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    //获取关联对象
    func resultMap() ->AnyObject{
        return objc_getAssociatedObject(self, RequestValidRespondKey) as AnyObject
    }
}

