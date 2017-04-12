//
//  SessionManager.swift
//  QSNetwork
//
//  Created by Nory Chao on 16/12/26.
//  Copyright © 2016年 QS. All rights reserved.
//

import Foundation

public typealias completionHandler = (QSResponse)->Void

public protocol ParameterEncoding {
    func encode(_ urlRequest: URLRequest, with parameters: Parameters?) throws -> URLRequest
}

public struct URLEncoding: ParameterEncoding {
    public func encode(_ urlRequest: URLRequest, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest =  urlRequest
        
        guard let parameters = parameters else { return urlRequest }
        
        if HTTPMethod(rawValue: urlRequest.httpMethod as NSString? ?? "GET") != nil {
            guard let url = urlRequest.url else {
                throw QSError.invalidURL(url: urlRequest.url!)
            }
            
            if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
                let percentEncodedQuery = (urlComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + query(parameters)
                urlComponents.percentEncodedQuery = percentEncodedQuery
                urlRequest.url = urlComponents.url
            }
        } else {
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
            }
            
            urlRequest.httpBody = query(parameters).data(using: .utf8, allowLossyConversion: false)
        }
        
        return urlRequest
    }
    
    private func query(_ parameters: [String: Any]) -> String {
        var components: [(String, String)] = []
        
        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += queryComponents(fromKey: key, value: value)
        }
        
        return components.map { "\($0)=\($1)" }.joined(separator: "&")
    }
    
    public func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
        var components: [(String, String)] = []
        
        if let dictionary = value as? [String: Any] {
            for (nestedKey, value) in dictionary {
                components += queryComponents(fromKey: "\(key)[\(nestedKey)]", value: value)
            }
        } else if let array = value as? [Any] {
            for value in array {
                components += queryComponents(fromKey: "\(key)[]", value: value)
            }
        } else if let value = value as? NSNumber {
            if value.isBool {
                components.append((escape(key), escape((value.boolValue ? "1" : "0"))))
            } else {
                components.append((escape(key), escape("\(value)")))
            }
        } else if let bool = value as? Bool {
            components.append((escape(key), escape((bool ? "1" : "0"))))
        } else {
            components.append((escape(key), escape("\(value)")))
        }
        
        return components
    }
    
    public func escape(_ string: String) -> String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        
        var escaped = ""
        
        if #available(iOS 8.3, *) {
            escaped = string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
        } else {
            let batchSize = 50
            var index = string.startIndex
            
            while index != string.endIndex {
                let startIndex = index
                let endIndex = string.index(index, offsetBy: batchSize, limitedBy: string.endIndex) ?? string.endIndex
                let range = startIndex..<endIndex
                
                let substring = string.substring(with: range)
                
                escaped += substring.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? substring
                
                index = endIndex
            }
        }
        
        return escaped
    }


    public static var `default`: URLEncoding { return URLEncoding() }
}

public struct SessionConfiguration{
    var data:NSMutableData
    let completionHandler:completionHandler?
}

public class QSManager:NSObject{
    
    fileprivate var configurations:[Int:SessionConfiguration] = [:]
    public var session:URLSession?
    public var defaultURL:String = ""
    public var operationQueue:OperationQueue?
    public static let `default`: QSManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = QSManager.defaultHTTPHeaders
        return QSManager(configuration: configuration)
    }()
    
    init(configuration:URLSessionConfiguration = URLSessionConfiguration.default) {
        super.init()
        self.operationQueue = OperationQueue()
        self.operationQueue?.maxConcurrentOperationCount = 1;
        self.session = URLSession(configuration: configuration, delegate: self, delegateQueue: self.operationQueue)
    }
    
    /// Creates default values for the "Accept-Encoding", "Accept-Language" and "User-Agent" headers.
    public static let defaultHTTPHeaders: HTTPHeaders = {
        let acceptEncoding: String = "gzip;q=1.0, compress;q=0.5"
        let acceptLanguage = Locale.preferredLanguages.prefix(6).enumerated().map { index, languageCode in
            let quality = 1.0 - (Double(index) * 0.1)
            return "\(languageCode);q=\(quality)"
            }.joined(separator: ", ")
        
        let userAgent: String = {
            if let info = Bundle.main.infoDictionary {
                let executable = info[kCFBundleExecutableKey as String] as? String ?? "Unknown"
                let bundle = info[kCFBundleIdentifierKey as String] as? String ?? "Unknown"
                let appVersion = info["CFBundleShortVersionString"] as? String ?? "Unknown"
                let appBuild = info[kCFBundleVersionKey as String] as? String ?? "Unknown"
                
                let osNameVersion: String = {
                    let version = ProcessInfo.processInfo.operatingSystemVersion
                    let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
                    
                    let osName: String = {
                        #if os(iOS)
                            return "iOS"
                        #endif
                    }()
                    return "\(osName) \(versionString)"
                }()
                
                let alamofireVersion: String = {
                    guard
                        let afInfo = Bundle(for: QSManager.self).infoDictionary,
                        let build = afInfo["CFBundleShortVersionString"]
                        else { return "Unknown" }
                    
                    return "QSNetwork/\(build)"
                }()
                
                return "\(executable)/\(appVersion) (\(bundle); build:\(appBuild); \(osNameVersion)) \(alamofireVersion)"
            }
            return "YouShaQi/2.24.10 (iPhone; iOS 10.1.1; Scale/2.00)"
        }()
        
        return [
            "Accept-Encoding": acceptEncoding,
            "Accept-Language": acceptLanguage,
            "User-Agent": "YouShaQi/2.24.10 (iPhone; iOS 10.1.1; Scale/2.00)"
        ]
    }()
    
    let queue = DispatchQueue(label: "org.qsnetwork.session-manager." + UUID().uuidString)
    
    @discardableResult
    public func request(
        _ url: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding:ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil,completionHandler:completionHandler?)->QSResponse{
        var originalRequest: URLRequest?
        var encodedURLRequest:URLRequest = URLRequest(url: URL(string: url) ?? URL(string:"http://caony.applinzi.com")!)
        do {
            originalRequest = try URLRequest(urlString: makeURL(url: url), method: method, headers: headers)
            encodedURLRequest = try encoding.encode(originalRequest!, with: parameters)
        } catch {
            let errorResult = QSResponse(data: nil, response: nil, error: error, task: nil)
            if let errorHandler = completionHandler {
                errorHandler(errorResult)
            }
        }
        print(encodedURLRequest)
        return request(urlRequest: encodedURLRequest ,completionHandler: completionHandler)
    }
    
    @discardableResult
    func request(urlRequest:URLRequest,completionHandler:completionHandler?) ->QSResponse{
        let request = urlRequest
        let isSyn = completionHandler == nil
        var session:URLSession!
        if let sessionsss = self.session {
            session = sessionsss
        }
        let semaphore = DispatchSemaphore(value: 0)
        var requestResult = QSResponse(data: nil, response: nil, error: nil, task: nil)
//        session = URLSession(configuration: URLSession.shared.configuration, delegate: self, delegateQueue: URLSession.shared.delegateQueue)
        
        let task:URLSessionDataTask = session.dataTask(with: request)
        let config = SessionConfiguration(data: NSMutableData()) { (result) in
            if let complete = completionHandler {
                DispatchQueue.main.async {
                    complete(result)
                }
            }
            if isSyn {
                requestResult = result
                semaphore.signal()
            }
        }
        configurations[task.taskIdentifier] = config
        task.resume()
        
        if isSyn {
            let timeout:Double? = 30.00
            let timeouts = timeout.flatMap { DispatchTime.now() + $0 }
                ?? DispatchTime.distantFuture
            _ = semaphore.wait(timeout: timeouts)
            return requestResult
        }
        return requestResult
    }
    
    public func download(url:String,method:HTTPMethod = .get,parameters:Parameters? = nil,encoding:ParameterEncoding = URLEncoding.default,headers: HTTPHeaders? = nil,completionHandler:((URL?,URLResponse?,Error?)->Void)?)->URLRequest{
        var originalRequest: URLRequest?
        var encodedURLRequest:URLRequest = URLRequest(url: URL(string: url) ?? URL(string:"http://caony.applinzi.com")!)
        do {
            originalRequest = try URLRequest(urlString: makeURL(url: url), method: method, headers: headers)
            encodedURLRequest = try encoding.encode(originalRequest!, with: parameters)
        } catch {
            if let errorHandler = completionHandler {
                errorHandler(URL(string: url),nil,error)
            }
        }
        return downloadImage(urlRequest: encodedURLRequest, completionHandler: completionHandler)
    }
    
    public func downloadImage(urlRequest:URLRequest,completionHandler:((URL?,URLResponse?,Error?)->Void)?)->URLRequest{
//        let request = urlRequest
//        let isSyn = completionHandler == nil
//        var session = URLSession.shared
//        let semaphore = DispatchSemaphore(value: 0)
        session = URLSession(configuration: URLSession.shared.configuration, delegate: self, delegateQueue: URLSession.shared.delegateQueue)
        let task = session?.downloadTask(with: urlRequest) { (url, response, error) in
            if let com = completionHandler {
                com(url,response,error)
            }
        }
        task?.resume()
        return urlRequest
    }
    
    public func setDefaultURL(url:String = ""){
        self.defaultURL = url
    }
    
    fileprivate func makeURL(url:String)->String{
        //http://
        var BASEURL = defaultURL
        var urlString = url
        if BASEURL != "" {
            BASEURL = remove(str: BASEURL)
            if urlString != "" {
                urlString = BASEURL + "/" + urlString
            }else{
                urlString = BASEURL
            }
        }
        return urlString
    }
    
    fileprivate func remove(str:String)->String{
        var urlString = str
        if urlString == "" {
            return urlString
        }
        let rangeTail = urlString.index(urlString.endIndex,offsetBy:-1)..<urlString.endIndex
        let tail = urlString.substring(with: rangeTail)
        if tail == "/" {
            urlString.removeSubrange(rangeTail)
        }
        return urlString
    }
    
}

extension QSManager:URLSessionDataDelegate,URLSessionTaskDelegate,URLSessionDownloadDelegate{
    
    //此方法在调用时会禁用 didCompleteWithError
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Swift.Void){
        print(response)
        completionHandler(URLSession.ResponseDisposition.allow);
    }

    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome downloadTask: URLSessionDownloadTask){
        
    }

    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data){
        let config = configurations[dataTask.taskIdentifier]
        if  config?.data != nil {
            config?.data.append(data)
        }
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Swift.Void){
        
    }

    public func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void){
        // 1.判断服务器返回的证书类型, 是否是服务器信任
        var position = URLSession.AuthChallengeDisposition.performDefaultHandling
        var credential:URLCredential? = nil
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust  {
            credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            if credential != nil {
                position = URLSession.AuthChallengeDisposition.useCredential
            }else{
                position = URLSession.AuthChallengeDisposition.performDefaultHandling
            }
        }else{
            position = URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge
        }
        completionHandler(position,credential)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64){
        
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?){
        if let config = configurations[task.taskIdentifier],
            let handler = config.completionHandler
        {
            let result = QSResponse(
                data: config.data as Data,
                response: task.response,
                error: error,
                task: task
            )
            handler(result)
        }
        configurations.removeValue(forKey: task.taskIdentifier)
    }
    
    /* Sent when a download task that has completed a download.  The delegate should
     * copy or move the file at the given location to a new location as it will be
     * removed when the delegate message returns. URLSession:task:didCompleteWithError: will
     * still be called.
     */
    @available(iOS 7.0, *)
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL){
        
    }
    
    
    /* Sent periodically to notify the delegate of download progress. */
    @available(iOS 7.0, *)
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64){
        
    }
    
    
    /* Sent when a download has been resumed. If a download failed with an
     * error, the -userInfo dictionary of the error will contain an
     * NSURLSessionDownloadTaskResumeData key, whose value is the resume
     * data.
     */
    @available(iOS 7.0, *)
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64){
        
    }

    
    public func testInstanceMethod(_ url:String,method:String){
        
    }

}

extension URLRequest {
    public init(urlString: String, method: HTTPMethod, headers: HTTPHeaders? = nil) throws {
        
        guard let url = URL(string: urlString ) else {
            throw QSError.invalidURL(url: nil)
        }
        
        self.init(url: url)
        
        httpMethod = method.rawValue as String
        
        if let headers = headers {
            for (headerField, headerValue) in headers {
                setValue(headerValue, forHTTPHeaderField: headerField)
            }
        }
    }
}

extension NSNumber {
    fileprivate var isBool: Bool { return CFBooleanGetTypeID() == CFGetTypeID(self) }
}

