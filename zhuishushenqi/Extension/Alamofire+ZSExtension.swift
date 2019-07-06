//
//  Alamofire+ZSExtension.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2018/7/31.
//  Copyright © 2018年 QS. All rights reserved.
//

import Foundation
import Alamofire

@discardableResult
public func zs_get(_ urlStr: String,parameters: Parameters? = nil) -> DataRequest {
    return zs_get(urlStr, parameters: parameters, nil)
}

public func zs_post(_ urlStr: String,parameters: Parameters? = nil) -> DataRequest {
    return request(urlStr, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
}

@discardableResult
public func zs_post(_ urlStr: String,parameters: Parameters? = nil,_ handler:ZSBaseCallback<[String:Any]>?) -> DataRequest {
    var headers = SessionManager.defaultHTTPHeaders
    headers["User-Agent"] = YouShaQiUserAgent
    let req = request(urlStr, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
        if let data = response.data {
            if let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any] {
                handler?(json)
            }
        } else {
            handler?([:])
        }
    }
    return req
}

@discardableResult
public func zs_put(_ urlStr: String,parameters: Parameters? = nil,_ handler:ZSBaseCallback<[String:Any]>?) -> DataRequest {
    var headers = SessionManager.defaultHTTPHeaders
    headers["User-Agent"] = YouShaQiUserAgent
    let req = request(urlStr, method: .put, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
        if let data = response.data {
            if let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any] {
                handler?(json)
            }
        } else {
            handler?([:])
        }
    }
    return req
}

public let YouShaQiUserAgent = "YouShaQi/4.4.4 (iPhone; iOS 12.0; Scale/3.00)"

@discardableResult
public func zs_get(_ urlStr: String,parameters: Parameters? = nil,_ handler:ZSBaseCallback<[String:Any]>?) -> DataRequest {
    var headers = SessionManager.defaultHTTPHeaders
    headers["User-Agent"] = YouShaQiUserAgent
    let req = request(urlStr, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
        if let data = response.data {
            if let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any] {
                handler?(json)
            }
        } else {
            handler?([:])
        }
    }
    return req
}

@discardableResult
public func zs_delete(_ urlStr: String,parameters: Parameters? = nil,_ handler:ZSBaseCallback<[String:Any]>?) -> DataRequest {
    var headers = SessionManager.defaultHTTPHeaders
    headers["User-Agent"] = YouShaQiUserAgent
    let req = request(urlStr, method: .delete, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
        if let data = response.data {
            if let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any] {
                handler?(json)
            }
        } else {
            handler?([:])
        }
    }
    return req
}

public func zs_download(urlString:String, filePath:String, handler:ZSBaseCallback<Any>?) {
    let pathURL = URL(fileURLWithPath: filePath, isDirectory: true)
    do {
        try FileManager.default.createDirectory(at: pathURL, withIntermediateDirectories: true, attributes: nil)
    } catch {
        print(error)
    }
    let fileName = (urlString as NSString).lastPathComponent
    let fileURL = pathURL.appendingPathComponent(fileName)
    let destination: DownloadRequest.DownloadFileDestination = { temporaryURL, _ in
        
        return (fileURL, [.createIntermediateDirectories, .removePreviousFile])
    }
    download(urlString, to: destination).response { (response) in
        if let error = response.error {
            handler?(error)
        } else {
            handler?(response.destinationURL)
        }
    }
    
}

@discardableResult
public func zs_download(url:String, parameters: Parameters? = nil,_ handler:ZSBaseCallback<[String:Any]>?) -> DownloadRequest {
    let destination = DownloadRequest.suggestedDownloadDestination()
    let downloadRequest = download(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil, to: destination).response { (response) in
        QSLog(response.destinationURL)
        
        let exist = FileManager.default.fileExists(atPath: response.destinationURL?.path ?? "")
        if exist {
            // 字体文件下载成功
            handler?(["url":response.destinationURL?.path ?? ""])
        } else {
            handler?(["error":response.error])
        }
        QSLog(response.temporaryURL)
        QSLog(response.error)
        QSLog(response.response)
    }
    return downloadRequest
}

public func downloadFile(urlString:String, handler:NetworkHandler<Any>?) {
    let pathURL = URL(fileURLWithPath: filePath, isDirectory: true)
    do {
        try FileManager.default.createDirectory(at: pathURL, withIntermediateDirectories: true, attributes: nil)
    } catch {
        print(error)
    }
    let fileName = (urlString as NSString).lastPathComponent
    let fileURL = pathURL.appendingPathComponent(fileName)
    let destination: DownloadRequest.DownloadFileDestination = { temporaryURL, _ in
        
        return (fileURL, [.createIntermediateDirectories, .removePreviousFile])
    }
    download(urlString, to: destination).response { (response) in
        if let error = response.error {
            handler?(error)
        } else {
            
            handler?(response.destinationURL)
        }
    }
    
}
