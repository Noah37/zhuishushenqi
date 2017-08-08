//
//  QSNetwork.swift
//  QSNetwork
//
//  Created by Nory Cao on 16/12/26.
//  Copyright © 2016年 QS. All rights reserved.
//

import Foundation

//
public enum HTTPMethod: NSString {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

public struct HTTP {
    var type:HTTPMethodType;
    func result() -> String {
        var resultString:String = ""
        switch type {
        case .options:
            resultString = "OPTIONS"
        case .head:
            resultString = "HEAD"
        case .post:
            resultString = "POST"
        case .put:
            resultString = "PUT"
        case .patch:
            resultString = "PATCH"
        case .delete:
            resultString = "DELETE"
        case .trace:
            resultString = "TRACE"
        case .connect:
            resultString = "CONNECT"
        default:
            resultString = "GET"
        }
        return resultString;
    }
}

@objc public enum HTTPMethodType:Int{
    case options
    case get
    case head
    case post
    case put
    case patch
    case delete
    case trace
    case connect
}

public typealias Parameters = [String: Any]
public typealias HTTPHeaders = [String: String]


public class QSNetwork{
    
    //默认情况下编译器就是会去检查返回参数是否有被使用，没有的话就会给出警告。如果你不想要这个警告，可以自己手动加上 @discardableResult
    //static类型方法，防止被重写，包含 final 特性
    
    public var defaultURL:String = ""
    public var method:HTTPMethod = .get
    
    public static func setDefaultURL(url:String = ""){
//        QSManager.default.setDefaultURL(url: url)
        
    }
    
    
    public static func test(_ url:String,method:HTTPMethodType){
//        QSManager.default.setDefaultURL(url: url)
    }
    
    @discardableResult
    public static func request(_ url:String,method:HTTPMethodType = .get,parameters:Parameters? = nil,headers:HTTPHeaders? = nil,completionHandler: completionHandler?)->QSResponse{
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = QSManager.defaultHTTPHeaders
        let manager = QSManager(configuration: configuration)
        return manager.request(url, method: .get, parameters: parameters, headers: headers,completionHandler: completionHandler)
    }
    
    @discardableResult
    public static func download(_ url:String,method:HTTPMethodType = .get,parameters:Parameters? = nil,headers:HTTPHeaders? = nil,completionHandler: ((URL?,URLResponse?,Error?)->Void)?)->URLRequest{
        return QSManager.default.download(url: url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers, completionHandler: completionHandler)
    }
    
}

extension QSNetwork{
    
    public static func testinstancemethod(_ url:String,method:HTTP = HTTP(type: .get),parameters:Parameters? = nil,headers:HTTPHeaders? = nil,completionHandler: completionHandler?){
        
    }

//    @discardableResult
//    public static func request(_ url:String,method:HTTPMethodType = .get,parameters:Parameters? = nil,headers:HTTPHeaders? = nil,completionHandler: completionHandler?)->Response{
//        return QSManager.default.request(url, method: .get, parameters: parameters, headers: headers,completionHandler: completionHandler)
//    }
}

