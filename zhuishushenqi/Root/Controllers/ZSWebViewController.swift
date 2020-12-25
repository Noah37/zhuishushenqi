//
//  ZSWebViewController.swift
//  zhuishushenqi
//
//  Created by yung on 2018/8/19.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit
import WebKit
import SnapKit
//https://h5.zhuishushenqi.com/monthly?platform=ios&gender=female&token=xAk9Ac8k3Jj9Faf11q8mBVPQ&timeInterval=1546603628999.309082&appversion=2.29.14&timestamp=1546603628.999911&version=8

class ZSWebViewController: BaseViewController {
    
    var webView:WKWebView!
    
    var url:String = ""
    var webTitle:String = "" {
        didSet {
            self.title = webTitle
        }
    }
    
    var navBarRightItems:[ZSWebItem] = []
    
    var jumpHandler:ZSWebJumpHandler?
    var userHandler:ZSWebUserHandler?
    var toolHandler:ZSWebToolHandler?
    var biHandler:ZSWebBIHandler?
    var speakHandler:ZSWebSpeakHandler?
    
    
    weak var delegate:ZSWebViewControllerDelegate?
    
    var currentUrlStr:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillLayoutSubviews() {
        layoutSubview()
    }
    
    private func layoutSubview() {
//        webView.snp.remakeConstraints { (make) in
//            make.edges.equalToSuperview()
//        }
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
            if let tmpWebView = self.createWebViewWithCustomUserAgentWithConfiguratuion(configuration: configuration) {
                self.webView = tmpWebView
                self.webView.navigationDelegate = self
                self.webView.uiDelegate = self
                self.view.addSubview(self.webView)
                self.loadWebPage()
            }
        }
        webView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
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
        let webView = WKWebView(frame: self.view.frame, configuration: configuration)
        webView.evaluateJavaScript("navigator.userAgent") { (result, error) in
            let str = "\(String(describing: result))/YouShaQi"
            let userAgentDict = ["UserAgent":str]
            UserDefaults.standard.register(defaults: userAgentDict)
            UserDefaults.standard.synchronize()
            if #available(iOS 9.0, *) {
                webView.customUserAgent = str
            } else {
                webView.setValue(str, forKey: "applicationNameForUserAgent")
            }
        }
        return webView
    }
    
    func canUAAppendYouShaQi() -> Bool {
        return true
    }
    
    func loadWebPage() {
        if url != "" {
            // complete url
            
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
        var result = true
        if isBlankString(str: funcName) {
            result = true
//            if funcName! == "jump" {
//                perform(#selector(jumpToViewWithItem(item:)), with: webItem)
//                result = false
//            } else if funcName! == "getUserInfo" {
//                let queryDict = webItem.queryDic
//                let callback = queryDict?["callback"]
//                result = false
//            } else if funcName! == "login" {
//                loginWithWebItem(item: webItem)
//            } else if funcName! == "copyBoard" {
//                triggerCopyBoardWithItem(item: webItem)
//            } else if funcName! == "pop" {
//                let jsStr = jsStrFromWebItem(item: webItem)
//                // webViewHandlePopEventWithCallBack:jsstr
//                self.navigationController?.popViewController(animated: true)
//            } else if funcName! == "backEvent" {
//                setBackEventItem(item: webItem)
//            } else if funcName! == "setUserBehavior" {
//                handleBuryPointsWithJSItem(item: webItem)
//            } else if funcName! == "openTaobaoDetail" {
//                ZSYJSchemeHandle.handleTaobaoUrl(url: webItem.callbackParamStr ?? "")
//            } else if funcName! == "baseRecharge" {
//
//            }
//            else {
//                if funcName! != "openBookstore" {
//                    if funcName! == "openBookshelf" {
//
//                    } else if funcName! == "openBindPhone" {
//
//                    }
//                }
//            }
        } else {
            result = handleWebItem(item: webItem)
        }
        return result
    }
    
    func handleWebItem(item:ZSWebItem) ->Bool {
        var result:Bool = false
        if item.funcName != "setBounces" {
            if item.funcName == "setNavigationBar" {
                setNavigtionBarItems(item: item)
            } else if item.funcName == "backEvent" {
                setBackEventItem(item: item)
            } else if ZSWebJumpHandler.canHandleWebItem(item: item) {
                if self.jumpHandler == nil {
                    self.jumpHandler = ZSWebJumpHandler()
                }
                let context = ZSWebContext()
                context.fromVC = self
                context.delegate = self.delegate
                self.jumpHandler?.handleWebItem(item: item, context: context, block: { (result) in
                    
                })
            } else if ZSWebUserHandler.canHandleWebItem(item: item) {
                if self.userHandler == nil {
                    self.userHandler = ZSWebUserHandler()
                }
            } else if ZSWebToolHandler.canHandleWebItem(item: item) {
                let context = ZSWebContext()
                context.fromVC = self
                context.delegate = self.delegate
                if self.toolHandler == nil {
                    self.toolHandler = ZSWebToolHandler()
                }
                self.toolHandler?.handleWebItem(item: item, context: context, block: { [weak self] (result) in
                    self?.runJavaScriptMethodWithName(name: result)
                })
            } else if ZSWebBIHandler.canHandleWebItem(item: item) {
                if self.biHandler == nil {
                    self.biHandler = ZSWebBIHandler()
                }
            } else if ZSWebSpeakHandler.canHandleWebItem(item: item) {
                let context = ZSWebContext()
                context.fromVC = self
                context.delegate = self.delegate
                if self.speakHandler == nil {
                    self.speakHandler = ZSWebSpeakHandler()
                }
                self.speakHandler?.handleWebItem(item: item, context: context, block: { [weak self] (result) in
                    self?.runJavaScriptMethodWithName(name: result)
                })
            }
            result = true
        } else {
            result = false
            let paramDic = item.paramDic
            if let enabled = paramDic?["enabled"] as? Bool {
                self.webView.scrollView.bounces = enabled
            }
        }
        return result
    }
    
    func setBackEventItem(item:ZSWebItem) {
        
        
    }
    
    func runJavaScriptMethodWithName(name:String) {
        self.webView.evaluateJavaScript(name) { (result, error) in
            
        }
    }
    
    func setNavigtionBarItems(item:ZSWebItem) {
        let paramDic = item.paramDic
        if let navItems = paramDic?["setNavigationItems"] as? [[String:Any]] {
            var index = navItems.count - 1
            while index >= 0 {
                let item = navItems[index]
                let webItem = ZSWebItem()
                var dic:[String:Any] = [:]
                dic["jumpType"] = "webview"
                dic["title"] = item["title"] ?? ""
                dic["link"] = item["link"] ?? ""
                dic["itemType"] = item["itemType"] ?? ""
                webItem.paramDic = dic
                navBarRightItems.append(webItem)
                index -= 1
            }
        }
    }
    
    @objc func jumpToViewWithItem(item:ZSWebItem) {
        if let paramDic = item.paramDic {
            let jumpType = paramDic["jumpType"] as? String ?? ""
//            let pageType = paramDic["pageType"] as? String ?? ""
            let title = paramDic["title"] as? String ?? ""
            var link = paramDic["link"] as? String ?? ""
            let id = paramDic["id"] as? String ?? ""
//            let sourceType = paramDic["sourceType"] as? String ?? ""
            var platform = ""
            if (link as NSString).range(of: "platform=ios").location == NSNotFound {
                let whRange = (link as NSString).range(of: "?")
                let timeInterval = Date().timeIntervalSince1970
                if whRange.location == NSNotFound {
                    platform = "?platform=ios&timestamp=\(timeInterval)"
                    
                } else {
                    platform = "&platform=ios&timestamp=\(timeInterval)"
                }
            }
            link.append(platform)
            if jumpType == "webview" {
                let webVC = ZSWebViewController()
                webVC.title = title
                webVC.url = link
                self.navigationController?.pushViewController(webVC, animated: true)
                return
            }
            if jumpType != "native" {
                if jumpType == "safari" {
                    if let webUrl = URL(string: link) {
                        if UIApplication.shared.canOpenURL(webUrl) {
                            UIApplication.shared.openURL(webUrl)
                            return
                        }
                    }
                }
            }
            if jumpType != "bookDetail" {
                if jumpType == "login" {
//                    -[ZSWebViewController loginWithWebItem:](v139, "loginWithWebItem:", v4);
//                    goto LABEL_44;
                    return
                }
                if jumpType != "post" {
                    if jumpType != "account" {
                        
                    }
                    if !ZSLogin.share.hasLogin() {
//                    showLoginView
                    }
                }
            }
            if id != "" {
                let detailVC = QSBookDetailRouter.createModule(id: id)
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
        }
    }
    
    @objc func loginWithWebItem(item:ZSWebItem) {
        
    }
    
    @objc func triggerCopyBoardWithItem(item:ZSWebItem) {
        
    }
    
    @objc func jsStrFromWebItem(item:ZSWebItem) {
        
    }
    
    @objc func handleBuryPointsWithJSItem(item:ZSWebItem) {
        
    }
    
    func matchedResultWithLink(link:String) ->ZSWebItem? {
        let reg = try? NSRegularExpression(pattern: "^jsbridge://(\\w+)(\\?)?", options: NSRegularExpression.Options.allowCommentsAndWhitespace)
        let length = link.count
        let match = reg?.firstMatch(in: link, options: NSRegularExpression.MatchingOptions(rawValue: 2), range: NSMakeRange(0, length))
        guard let result = match?.range(at: 1) else { return nil }
        if result.location != NSNotFound {
            let subStr = link.qs_subStr(range: result)
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
                } else if !isWXScheme(url: url.absoluteString) {
                    if parseURL(urlString: url.absoluteString) {
                        // self.delegate webViewWillLoadUrl:isOutSide:0
                    }
                } else {
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
            }
            if url.absoluteString.hasPrefix("https://h5.zhuishushenqi.com") {
                decisionHandler(.allow)
            } else if url.absoluteString.hasPrefix("jsbridge://") {
//                configure(urlString: url)
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
//        let classNames = ["c-top-app-download clearfix",
//                          "c-page-header",
//                          "c-full-screen-page-header",
//                          "c-bottom-app-download clearfix"]
//        let jsAddClearOpHead = "document.getElementsByClassName('"
//        let jsAddClearOpTail = "')[0].style.display = 'none'"
//        for className in classNames {
//            let js = "\(jsAddClearOpHead)\(className)\(jsAddClearOpTail)"
//            self.webView.evaluateJavaScript(js) { (result, error) in
//
//            }
//        }
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
