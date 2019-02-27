//
//  ZSWebViewControllerDelegate.swift
//  zhuishushenqi
//
//  Created by caony on 2019/1/6.
//  Copyright © 2019年 QS. All rights reserved.
//

import Foundation

@objc protocol ZSWebViewControllerDelegate {
    @objc optional func webViewDidSetNavBarStyle(style:[String:Any])
    @objc optional func webViewDidTitleShown(title:String)
    @objc optional func webViewWillLoadUrl(url:String, isOutSide:Bool)
    @objc optional func webViewHandleBackEventWithCallBack(callback:String)
    @objc optional func webViewHandlePopEventWithCallBack(callback:String)
    @objc optional func webViewShareStatus(status:CLongLong, callback:String, parama:String)
    @objc optional func webViewNeedRefreshShareClickStatus()
    @objc optional func webViewNeedClose(webView:ZSWebViewController, animated:Bool)
    @objc optional func webViewNeedUpdateToolbar(webView:ZSWebViewController)
}
