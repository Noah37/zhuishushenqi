//
//  BUAdManager.swift
//  zhuishushenqi
//
//  Created by daye on 2021/12/27.
//  Copyright © 2021 QS. All rights reserved.
//

import Foundation
import BUAdSDK
import UIKit

class BUAdManager:NSObject {
    
    private static let appKey = "5256970"
    
    private static let secretKey = ""
    
    static let shared = BUAdManager()
    
    private var splashAdView:BUSplashAdView?
    
    private var startTime:CFTimeInterval = 0
    
    private var loadAdSuccess:Bool = false
    
    func loadAd() {
        let territory = UserDefaults.standard.integer(forKey: "territory")
        let isNoCN = territory > 0 && territory != BUAdSDKTerritory.CN.rawValue
        
        BUAdSDKManager.setAppID(BUAdManager.appKey)
        BUAdSDKManager.setTerritory(isNoCN ? BUAdSDKTerritory.NO_CN:BUAdSDKTerritory.CN)
        BUAdSDKManager.setGDPR(0)
        BUAdSDKManager.setCoppa(0)
        BUAdSDKManager.setCCPA(1)
#if DEBUG
        BUAdSDKManager.setLoglevel(.verbose)
#endif
        BUAdSDKManager.start(asyncCompletionHandler: { [weak self] success, error in
            self?.loadAdSuccess = success
        })
    }
    
    func startBUAdSDK(viewController:UIViewController) {
        if loadAdSuccess {
            addSplashAD(viewController: viewController)
        }
    }
    
    private func addSplashAD(viewController:UIViewController) {
        let frame = UIScreen.main.bounds
        splashAdView = BUSplashAdView(slotID: BUAdSlotID.normal_splash_ID, frame: frame)
        splashAdView?.tolerateTimeout = 3
        splashAdView?.delegate = self
        
        startTime = CACurrentMediaTime()
        splashAdView?.loadAdData()
        viewController.view.addSubview(splashAdView!)
        splashAdView?.rootViewController = viewController
    }
    
    private func removeSplashAd() {
        splashAdView?.removeFromSuperview()
    }
}

extension BUAdManager:BUSplashAdDelegate {
    
    func splashAdDidLoad(_ splashAd: BUSplashAdView) {
        
    }
    
    func splashAdDidClose(_ splashAd: BUSplashAdView) {
        removeSplashAd()
    }
    
    func splashAdDidClickSkip(_ splashAd: BUSplashAdView) {
        
    }
    
    func splashAd(_ splashAd: BUSplashAdView, didFailWithError error: Error?) {
        removeSplashAd()
    }
    
    func splashAdCountdown(toZero splashAd: BUSplashAdView) {
        
    }
}

class BUAdSlotID {
    static let normal_splash_ID = "887655509"
}
