//
//  ZSWebToolHandler.swift
//  zhuishushenqi
//
//  Created by yung on 2019/6/30.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit

class ZSWebToolHandler: ZSWebEventHandlerProtocol {
    static func canHandleWebItem(item: ZSWebItem) -> Bool {
        let items = ["share","copyBoard","sharespread","shareEarnings","setTopBarColor","getDeviceInfo","setOptionButton","saveImage","showToast","jumptoPublic"]
        return items.contains(item.funcName ?? "")
    }
    
    func handleWebItem(item: ZSWebItem, context: ZSWebContext, block: (String) -> Void) {
        if item.funcName == "share" {
            triggerShareFunctionWithItem(item: item)
        } else if item.funcName == "copyBoard" {
            triggerCopyBoardWithItem(item: item)
        } else if item.funcName == "sharespread" || item.funcName == "shareEarnings" {
            shareShituWithItem(item: item)
        } else if item.funcName == "setTopBarColor" {
            
        } else if item.funcName == "getDeviceInfo" {
            let userId = ZSThirdLogin.share.userInfo?.user?._id ?? ""
            let version = ZSConfigUtil.versionShortCode()
            let platformString = ZSConfigUtil.platformString()
            let systemVersion = UIDevice.current.systemVersion
            let uniquelIdfa = ZSConfigUtil.uniquelIdfa()
            let publisherID = ZSConfigUtil.publisherId()
            let channel = ZSConfigUtil.channel()
            let appName = ZSConfigUtil.appName()
            let deviceInfo = ["userId":userId,
                              "deviceId":uniquelIdfa,
                              "channel":channel,
                              "appName":appName,
                              "version":version,
                              "systemVersion":systemVersion,
                              "publisherID":publisherID,
                              "deviceModel":platformString]
            item.callbackParamStr = deviceInfo.toJSON
            block("\(item.callback ?? "")(\(item.callbackParamStr ?? ""))")
        }
    }
    
    func triggerShareFunctionWithItem(item:ZSWebItem) {
        
    }
    
    func triggerCopyBoardWithItem(item:ZSWebItem) {
        
    }

    func shareShituWithItem(item:ZSWebItem) {
        
    }
    
}
