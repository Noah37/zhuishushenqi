//
//  ZSWebViewController.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2018/8/19.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit
import WebKit

class ZSWebViewController: BaseViewController {
    
    var webView:WKWebView!
    
    var url:String = ""
    var webTitle:String = "" {
        didSet {
            self.title = webTitle
        }
    }

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
        let configuration = WKWebViewConfiguration()
        webView = WKWebView(frame: CGRect.zero, configuration: configuration)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        if url != "" {
            if let url = URL(string: self.url) {
                let request = URLRequest(url: url)
                webView.load(request)
            }
        }
        view.addSubview(self.webView)
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
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
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
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
    }
}
