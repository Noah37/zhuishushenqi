//
//  ZSLoginVerifyView.swift
//  zhuishushenqi
//
//  Created by yung on 2018/10/24.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit

typealias ZSLoginVerifyViewResultHandler = (_ ret:Int, _ param:[String:String]) ->Void

class ZSLoginVerifyView: UIView, UIWebViewDelegate {

    var webView:UIWebView!
    var backgroundView:UIView!
    
    var resultHandler:ZSLoginVerifyViewResultHandler?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        
        webView = UIWebView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 300))
        webView.delegate = self
        webView.center = self.center
        
        let userAgent = self.webView.stringByEvaluatingJavaScript(from: "navigator.userAgent") ?? ""
        let m_UserAgent = "\(userAgent) TCSDK/1.0.2"
        UserDefaults.standard.register(defaults: ["UserAgent":m_UserAgent])
        UserDefaults.standard.synchronize()
        
        backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.height))
        backgroundView.backgroundColor = UIColor(white: 0.3, alpha: 0.6)
        backgroundView.isUserInteractionEnabled = true
        addSubview(backgroundView)
        addSubview(webView)
        
        self.isUserInteractionEnabled = true
    }
    
    func startVerify(str:String) {
        webView.loadHTMLString(str, baseURL: nil)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        let urlString = request.url?.absoluteString ?? ""
        if urlString.hasPrefix("tcwebscheme://callback") {
            let location = (urlString as NSString).range(of: "?retJson=").location
            if location != NSNotFound {
                let jsonString = urlString.substingInRange((location+9)..<((urlString as NSString).length))
                let noPercentJson = jsonString?.removingPercentEncoding ?? ""
                if let data = noPercentJson.data(using: .utf8) {
                    if let obj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any] {
                        var requestParam:[String:String] = [:]
                        let ret = obj["ret"] as? Int ?? 1
                        requestParam["mobile"] = ZSMobileLogin.share.mobile
                        requestParam["type"] = "login"
                        requestParam["captchaType"] = "tencent"
                        requestParam["Ticket"] = obj["ticket"] as? String ?? ""
                        requestParam["Randstr"] = obj["randstr"] as? String ?? ""
                        resultHandler?(ret, requestParam)
                    }
                }
            }
        }
        return true
    }

}
