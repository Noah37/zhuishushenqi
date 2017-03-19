//
//  XYCNetworkAgent.swift
//  QSNetworking
//
//  Created by Nory Chao on 16/7/14.
//  Copyright © 2016年 QS. All rights reserved.
//

import UIKit


open class XYCNetworkAgent: NSObject {

    fileprivate var config:XYCNetworkConfig?
    
    func addRequest(_ request:XYCBaseRequest){
        DispatchQueue(label: "com.XYC.XYCnetwork.request.processing", attributes: []).async { 
            self.XYC_addRequst(request)
        }
    }
    
    func buildRequestUrl(_ request:XYCBaseRequest) ->String{
        var detailUrl:String = request.requestUrl()
        if detailUrl.hasPrefix("http") == true {
            return detailUrl;
        }
        let filters = config?.urlFilters
        for f in filters! {
            detailUrl = (f as! XYCUrlArgumentFilter).filterUrl(detailUrl,withRequest:request)
        }
        var baseUrl = ""
        if (request.baseUrl() as NSString).length > 0{
            baseUrl = request.baseUrl()
        }else{
            baseUrl = config?.baseUrl ?? ""
        }
        print("\(baseUrl)\(detailUrl)")
        return "\(baseUrl)\(detailUrl)"
    }
    
    func XYC_addRequst(_ request:XYCBaseRequest){
        let url = self.buildRequestUrl(request)
        let param = request.requestArgument()
        let method:XYCRequestMethod = request.requestMethod()!
        DispatchQueue.main.async { 
            
//            HUD.showProgressHud(true)
        }
        if method == .post {
//            Alamofire.request(.POST, url, parameters: param as? [String:String])
//                .validate()
//                .responseJSON { response in
//                    HUD.hide()
//                    print("request:\(response.request)")  // original URL request
//                    print("response:\(response.response)") // URL response
//                    print("data:\(response.data)")     // server data
//                    print("result:\(response.result)")   // result of response serialization
//                    HUD.hide()
//                    switch response.result {
//                    case .Success:
//                        print("Validation Successful")
//                        if request.successCompletionBlock != nil{
//                            request.successCompletionBlock!(request:response.data as! AnyObject)
//                        }
//                    case .Failure(let error):
//                        print(error)
//                        if request.failureCompletionBlock != nil{
//                            request.failureCompletionBlock!(request: error as AnyObject)
//                        }
//                    }
//            }
//        }else{
//            Alamofire.request(.GET, url, parameters: param as? [String:String])
//                .validate()
//                .responseJSON { response in
//                    HUD.hide()
//                    print("request:\(response.request)")  // original URL request
//                    print("response:\(response.response)") // URL response
//                    print("data:\(response.data)")     // server data
//                    print("result:\(response.result.value)")   // result of response serialization
//                    HUD.hide()
//                    switch response.result {
//                    case .Success:
//                        print("Validation Successful")
//                        if request.successCompletionBlock != nil{
//                            request.successCompletionBlock!(request:response.result.value!)
//                        }
//                    case .Failure(let error):
//                        print(error)
//                        if request.failureCompletionBlock != nil{
//                            request.failureCompletionBlock!(request: error as AnyObject)
//                        }
//                    }
//            }
        }
    }
    let sharedInstance = XYCNetworkAgent()
//    private init() {
//        config = XYCNetworkConfig.sharedInstance
//    }
}
