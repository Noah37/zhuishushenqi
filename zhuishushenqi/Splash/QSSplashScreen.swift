//
//  QSSplashScreen.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2017/6/8.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit
import QSNetwork

typealias SplashCallback = ()->Void

class QSSplashScreen: NSObject {
    
    var splashInfo:NSDictionary?
    private var splashRootVC:QSSplashViewController?
    
    private let splashURL = "http://api.zhuishushenqi.com/splashes/ios"
    
    func show(){
        detachRootViewController()
        let splashWindoww = UIWindow(frame: UIScreen.main.bounds)
        splashWindoww.backgroundColor = UIColor.black
        splashRootVC = QSSplashViewController()
        splashRootVC?.finishCallback = {
            self.hide()
        }
        splashRootVC?.view.backgroundColor = UIColor.clear
        splashWindoww.rootViewController = splashRootVC
        splashWindow = splashWindoww
        splashWindow?.makeKeyAndVisible()
        getSplashInfo()
    }
    
    func getSplashInfo(){
        // first
        
        // request splash image
        QSNetwork.request(splashURL) { (response) in
            let splash =  response.json?["splash"] as? [NSDictionary]
            if let splashInfo = splash?[0] {
                // save splash info,download image and save it
                self.splashInfo = splashInfo
                self.downloadSplashImage()
//                USER_DEFAULTS.set(splashInfo, forKey: "splashInfo")
                
            }
        }
    }
    
    func downloadSplashImage(){
        let urlString = getSplashURLString()
        QSNetwork.request(urlString) { (response) in
            QSLog(response.data)
            if let imageData = response.data {
                let image = UIImage(data: imageData)
                if let splashImage = image{
                    self.splashInfo?.setValue(splashImage.base64(), forKey: "imageData")
                    self.splashRootVC?.setSplashImage(image: splashImage)
                }
            }
        }
    }
    
    func getSplashURLString()->String {
        //according to screen dimension
        let imageString = self.splashInfo?.object(forKey: "img") as? String ?? ""
        return  imageString
    }
    
    func hide(){
        attachRootViewController()
        let mainWindow:UIWindow? = (UIApplication.shared.delegate?.window)!
        mainWindow?.makeKeyAndVisible()
    }
    
}

var originalRootViewController:UIViewController?
var splashWindow:UIWindow?

extension QSSplashScreen {
    func detachRootViewController(){
        if originalRootViewController == nil {
            let mainWindow:UIWindow? = (UIApplication.shared.delegate?.window)!
            originalRootViewController = mainWindow?.rootViewController
        }
    }
    
    func attachRootViewController(){
        if originalRootViewController != nil {
            let mainWindow:UIWindow? = (UIApplication.shared.delegate?.window)!
            mainWindow?.rootViewController = originalRootViewController
        }
    }
}

class QSSplashViewController: UIViewController {
    private var bgView:UIImageView!
    private var splashIcon:UIImageView!
    private var skipBtn:UIButton!
    var finishCallback:SplashCallback?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
    
    private func setupSubviews(){
        bgView = UIImageView(frame: UIScreen.main.bounds)
        bgView.image = UIImage(named: "LaunchImage")
        view.addSubview(bgView)
        
        splashIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width
            , height: UIScreen.main.bounds.height - 100))
        splashIcon.backgroundColor = UIColor.clear
        view.addSubview(splashIcon)
        
        skipBtn = UIButton(type: .custom)
        skipBtn.frame = CGRect(x: UIScreen.main.bounds.width - 120, y: 35, width: 60, height: 30)

        skipBtn.setTitle("跳过", for: .normal)
        skipBtn.setTitleColor(UIColor.gray, for: .normal)
        skipBtn.backgroundColor = UIColor(white: 1.0, alpha: 0.6)
        skipBtn.isHidden = true
        skipBtn.addTarget(self, action: #selector(skipAction(btn:)), for: .touchUpInside)
        skipBtn.layer.cornerRadius = 5
        view.addSubview(skipBtn)
    }
    
    @objc private func skipAction(btn:UIButton){
        if let callback = finishCallback {
            callback()
        }
    }
    
    func setSplashImage(image:UIImage){
        splashIcon.image = image
        skipBtn.isHidden = false
    }
}
