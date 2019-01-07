//
//  ZSWebViewController.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2018/8/19.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit
import WebKit
//https://h5.zhuishushenqi.com/monthly?platform=ios&gender=female&token=xAk9Ac8k3Jj9Faf11q8mBVPQ&timeInterval=1546603628999.309082&appversion=2.29.14&timestamp=1546603628.999911&version=8

class ZSWebViewController: BaseViewController {
    
    var webView:WKWebView!
    
    var url:String = ""
    var webTitle:String = "" {
        didSet {
            self.title = webTitle
        }
    }
    
    var currentUrlStr:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.webView.frame = self.view.bounds
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func popAction() {
        if self.webView.canGoBack {
            self.webView.goBack()
        } else {
            super.popAction()
        }
    }
    
    func setupSubviews(){
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        UIApplication.shared.isStatusBarHidden = false
        let systemVersion = Double(UIDevice.current.systemVersion) ?? 8.0
        if systemVersion >= 8.0 {
            let userScript = WKUserScript(source: "var meta = document.createElement('meta');        meta.setAttribute('name', 'viewport');        meta.setAttribute('content', 'width=device-width');        document.getElementsByTagName('head')[0].appendChild(meta);", injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: true)
            let userContent = WKUserContentController()
            userContent.addUserScript(userScript)
            let configuration = WKWebViewConfiguration()
            configuration.userContentController = userContent
            userContent.add(self, name: "ZssqApi")
            
            if let tmpWebView = createWebViewWithCustomUserAgentWithConfiguratuion(configuration: configuration) {
                webView = tmpWebView
                webView.navigationDelegate = self
                webView.uiDelegate = self
                view.addSubview(webView)
                loadWebPage()
            }
        }
    }
    
    func addObservers() {
        self.webView.addObserver(self, forKeyPath: "title", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "title" {
            if (object as? WKWebView) == self.webView {
                
            }
        }
    }
    
    func createWebViewWithCustomUserAgentWithConfiguratuion(configuration:WKWebViewConfiguration) ->WKWebView? {
        let webView = UIWebView(frame: self.view.bounds)
        var userAgent = webView.stringByEvaluatingJavaScript(from: "navigator.userAgent") ?? ""
        if userAgent.count > 0 {
            if canUAAppendYouShaQi() {
                let containYouShaQi = userAgent.contains("/YouShaQi")
                if !containYouShaQi {
                    userAgent.append("/YouShaQi")
                    let userAgentDict = ["UserAgent":userAgent]
                    UserDefaults.standard.register(defaults: userAgentDict)
                    let webView = WKWebView(frame: self.view.frame, configuration: configuration)
                    return webView
                }
            }
        }
        return nil
    }
    
    func canUAAppendYouShaQi() -> Bool {
        return true
    }
    
    func loadWebPage() {
        if url != "" {
            if let url = URL(string: self.url) {
                let request = URLRequest(url: url)
                webView.load(request)
            }
        }
    }
    
    func isBlankString(str:String?) ->Bool {
        var isBlank = false
        if str == nil {
            isBlank = true
        }
        if let trimStr = str?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) {
            if trimStr.count > 0 {
                if trimStr == "(null)" {
                    isBlank = true
                }
            }
        }
        return isBlank
    }
    
    func parseURL(urlString:String) ->Bool {
        let replaceStr = urlString.replacingOccurrences(of: "/?", with: "?")
        guard let webItem = matchedResultWithLink(link: replaceStr) else { return false }
        let funcName = webItem.funcName
        if !isBlankString(str: funcName) {
            if funcName! == "getUserInfo" {
                let queryDict = webItem.queryDic
                let callback = queryDict?["callback"]
                
            }
        }
        return false
    }
    
    func matchedResultWithLink(link:String) ->ZSWebItem? {
        let reg = try? NSRegularExpression(pattern: "^jsbridge://(\\w+)(\\?)?", options: NSRegularExpression.Options.allowCommentsAndWhitespace)
        let length = link.count
        let match = reg?.firstMatch(in: link, options: NSRegularExpression.MatchingOptions(rawValue: 2), range: NSMakeRange(0, length))
        let result = match?.range(at: 1)
        if result?.location != NSNotFound {
            let subStr = link.qs_subStr(range: result!)
            let webItem = ZSWebItem()
            if subStr.count > 0 {
                webItem.funcName = subStr
                let rangeTwo = match?.range(at: 2)
                if rangeTwo?.location != NSNotFound {
                    let linkLength = link.count
                    let twoLength = rangeTwo?.length ?? 0
                    let twoLocation = rangeTwo?.location ?? 0
                    let query = link.qs_subStr(range: NSMakeRange(twoLocation,linkLength - twoLength))
                    let queryDict = parseQueryStr(str: query)
                    webItem.queryDic = queryDict
                    if let param = queryDict["param"] {
                        if let data = param.data(using: String.Encoding(rawValue: 4)) {
                            if let paramObj:[String:Any] = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [String:Any] {
                                webItem.paramDic = paramObj
                            }
                        }
                    }
                    if let callback = queryDict["callback"] {
                        webItem.callback = callback
                        webItem.callbackParamStr = queryDict["param"]
                    }
                }
            }
            return webItem
        }
        return nil
    }
    
    func parseQueryStr(str:String) ->[String:String] {
        let queryStr = str.replacingOccurrences(of: "?", with: "")
        let comps = queryStr.components(separatedBy: "&")
        var queryDict:[String:String] = [:]
        for comp in comps {
            let keyValueArr = comp.components(separatedBy: "=")
            if keyValueArr.count == 2 {
                let key = keyValueArr[0]
                let value = keyValueArr[1]
                let noPerValue = value.removingPercentEncoding
                queryDict[key] = noPerValue
            }
        }
        return queryDict
    }
    
    func parse(url:URL)->[String:Any]{
        var result:[String:Any] = [:]
        let query = url.query ?? ""
        let params = query.components(separatedBy: "&")
        for param in params {
            let dict = param.components(separatedBy: "=")
            if dict.count > 1 {
                let key = dict[0]
                let value = dict[1]
                let decodeValue = value.removingPercentEncoding ?? ""
                var obj:Any = decodeValue
                if let data = decodeValue.data(using: .utf8) {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) {
                        QSLog(json)
                        obj = json
                    }
                }
                if key != "" {
                    result[key] = obj
                }
            }
        }
        return result
    }
    
    func zs_query(url:String?)->String{
        var query = ""
        if let urlString = url {
            let urlArr = urlString.components(separatedBy: "?")
            if urlArr.count > 1 {
                query = urlArr[1]
            }
        }
        return query
    }
    
    func getTitle(code:String)->String{
        let codes = code.components(separatedBy: "##")
        var title:String = ""
        if codes.count > 1 {
            title = codes[1]
        }
        return title
    }
    
    func jumpReader(id:String, code:String){
        let title = getTitle(code: code)
        let book = BookDetail()
        book._id = id
        book.title = title
        let readerVC = ZSReaderViewController()
        readerVC.viewModel.book = book
        self.present(readerVC, animated: true, completion: nil)
    }
    
    func jumpWeb(urlString:URL,title:String){
        let webVC = ZSWebViewController()
        webVC.url = urlString.absoluteString
        webVC.webTitle = title
        self.navigationController?.pushViewController(webVC, animated: true)
    }
    
    func jump(urlString:URL){
        let queryDict = parse(url: urlString)
//        let t = queryDict["t"]
        if let param = queryDict["param"] as? [String:Any] {
            let code = param["code"] as? String ?? ""
            if let jumpType = param["jumpType"] as? String {
                if jumpType == "native" {
                    if let pageType = param["pageType"] as? String {
                        if pageType == "bookDetail" {
                            let id = param["id"] as? String ?? ""
                            jumpReader(id: id,code: code)
                        }
                    }
                } else if jumpType == "webview" {
                    if let pageType = param["pageType"] as? String {
                        if pageType == "recommend" {
                            
                        }
                        let webviewTitle = param["title"] as? String ?? ""
                        let link = param["link"] as? String ?? ""
                        if let webviewURL = URL(string: link) {
                            jumpWeb(urlString: webviewURL, title: webviewTitle)
                        }
                    }
                }
            }
        }
    }
    
    func configure(urlString:URL) {
        let host = urlString.host ?? ""
        if host == "jump" {
            jump(urlString: urlString)
        }
    }
}

extension ZSWebViewController:WKNavigationDelegate,WKUIDelegate {
    
    func isiTunesURL(url:String) ->Bool {
        var isiTunes = false
        let reg = try? NSRegularExpression(pattern: "\\/\\/itunes\\.apple\\.com\\/", options: NSRegularExpression.Options(rawValue: 0))
        if let regular = reg {
            let urlLength = url.count
            if let _ = regular.firstMatch(in: url, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, urlLength)) {
                isiTunes = true
            }
        }
        return isiTunes
    }
    
    func isAppStoreURL(url:String) ->Bool {
        if url.hasPrefix("itms-apps://") {
            return true
        }
        return false
    }
    
    func isWXScheme(url:String) ->Bool {
        if url.hasPrefix("weixin://") {
            return true
        }
        return false
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
            if url.absoluteString.count > 0 {
                if isiTunesURL(url: url.absoluteString) || isAppStoreURL(url: url.absoluteString) {
                    // self.delegate webViewWillLoadUrl:isOutSide:1
                    UIApplication.shared.openURL(url)
                    // self.delegate webViewNeedClose:animated:1
                }
                if !isWXScheme(url: url.absoluteString) {
                    if parseURL(urlString: url.absoluteString) {
                        // self.delegate webViewWillLoadUrl:isOutSide:0
                    }
                }
                UIApplication.shared.openURL(url)
                let backForwardList = webView.backForwardList
                let backList = backForwardList.backList
                let firstObject = backList.first
                if let firstString = firstObject?.url.absoluteString {
                    if firstString.contains("m.zhuishushenqi.com/publicPay/") {
                        UserDefaults.standard.set(1, forKey: "kIsPurchasingByW")
                        UserDefaults.standard.synchronize()
                        // needsCloseWebView = 1
                        // self.delegate webViewNeedClose:animated:1
                    }
                }
            }
            if url.absoluteString.hasPrefix("https://h5.zhuishushenqi.com") {
                decisionHandler(.allow)
            } else if url.absoluteString.hasPrefix("jsbridge://") {
                configure(urlString: url)
                decisionHandler(.cancel)
            } else {
                decisionHandler(.cancel)
            }
        } else {
            decisionHandler(.cancel)
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // 去除广告
        let classNames = ["c-top-app-download clearfix",
                          "c-page-header",
                          "c-full-screen-page-header",
                          "c-bottom-app-download clearfix"]
        let jsAddClearOpHead = "document.getElementsByClassName('"
        let jsAddClearOpTail = "')[0].style.display = 'none'"
        for className in classNames {
            let js = "\(jsAddClearOpHead)\(className)\(jsAddClearOpTail)"
            self.webView.evaluateJavaScript(js) { (result, error) in
                
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
    }
}

extension ZSWebViewController:WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
    }
    
    
}
