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
    private var remainDelay:Int = 3
    private var shouldHidden:Bool = true
    private let splashInfoKey = "splashInfoKey"
    private let splashImagePathKey = "splashImagePathKey"
    private let splashImageName = "splashImageName"
    var completion:SplashCallback?
    
    private let splashURL = "http://api.zhuishushenqi.com/splashes/ios"
    
    func show(completion:@escaping SplashCallback){
        self.completion = completion
        detachRootViewController()
        let splashWindoww = UIWindow(frame: UIScreen.main.bounds)
        splashWindoww.backgroundColor = UIColor.black
        splashRootVC = QSSplashViewController()
        splashRootVC?.finishCallback = {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.showSplash), object: nil)
            self.hide()
        }
        splashRootVC?.view.backgroundColor = UIColor.clear
        splashWindoww.rootViewController = splashRootVC
        splashWindow = splashWindoww
        splashWindow?.makeKeyAndVisible()
        getSplashInfo()
    }
    
    func getSplashInfo(){
        QSLog("info:\(String(describing: USER_DEFAULTS.object(forKey: splashInfoKey)))")
        // first check network,not reachable
        if Reachability(hostname: IMAGE_BASEURL)?.isReachable == false {
            // load image from disk
            let splashInfo = USER_DEFAULTS.object(forKey: splashInfoKey) as? NSDictionary
            let imagePath = splashInfo?.object(forKey: splashImagePathKey) as? String ?? ""
            // image not exist,skip
            if FileManager.default.fileExists(atPath: imagePath) {
                hide()
            }else{
                let image = UIImage(contentsOfFile: imagePath)
                if let splashImage = image{
                    self.perform(#selector(self.showSplash), with: nil, afterDelay: 1.0)
                    self.splashRootVC?.setSplashImage(image: splashImage)
                }else{
                    hide()
                }
            }
            return
        }
        
        // request splash image
        QSNetwork.request(splashURL) { (response) in
            let splash =  response.json?["splash"] as? [NSDictionary]
            if let splashInfo = splash?[0] {
                // save splash info,download image and save it
                self.splashInfo = splashInfo
                self.downloadSplashImage()
            }else{
                self.hide()
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
                    let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
                    let url = URL(fileURLWithPath: path!.appending("/\(self.splashImageName)"))
                    do{
                        try UIImagePNGRepresentation(splashImage)?.write(to: url)
                    }catch{
                        
                    }
                    let mutableInfo:NSMutableDictionary = NSMutableDictionary(dictionary: self.splashInfo!)
                    mutableInfo.setValue(path, forKey: self.splashImagePathKey)
                    self.splashInfo = mutableInfo
                    USER_DEFAULTS.set(self.splashInfo, forKey: self.splashInfoKey)
                    self.perform(#selector(self.showSplash), with: nil, afterDelay: 1.0)
                    self.splashRootVC?.setSplashImage(image: splashImage)
                }else{
                    self.hide()
                }
            }else{
                self.hide()
            }
        }
    }
    
    func showSplash(){
        remainDelay -= 1
        if remainDelay == 0 {
            hide()
        }
        self.perform(#selector(self.showSplash), with: nil, afterDelay: 1.0)
    }
    
    func getSplashURLString()->String {
        //according to screen dimension
        let imageString = self.splashInfo?.object(forKey: "img") as? String ?? ""
        return  imageString
    }
    
    func hide(){
        if shouldHidden {
            shouldHidden = false
            attachRootViewController()
            if let completion = self.completion {
                completion()
            }
        }
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
        bgView.image = UIImage(named: getImageName())
        view.addSubview(bgView)
        
        splashIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width
            , height: UIScreen.main.bounds.height - 100))
        splashIcon.backgroundColor = UIColor.clear
        view.addSubview(splashIcon)
        
        skipBtn = UIButton(type: .custom)
        skipBtn.frame = CGRect(x: UIScreen.main.bounds.width - 80, y:UIScreen.main.bounds.height -  65, width: 60, height: 30)

        skipBtn.setTitle("跳过", for: .normal)
        skipBtn.setTitleColor(UIColor.gray, for: .normal)
        skipBtn.backgroundColor = UIColor(white: 0.0, alpha: 0.1)
        skipBtn.addTarget(self, action: #selector(skipAction(btn:)), for: .touchUpInside)
        skipBtn.layer.cornerRadius = 5
        view.addSubview(skipBtn)
    }
    
    func getImageName()->String{
        var imageName = ""
        if IPHONE4 {
            imageName = "Default"
        }else if IPHONE5 {
            imageName = "Default-640x1136"
        }else if IPHONE6 {
            imageName = "Default-750x1334"
        }else {
            imageName = "Default-1242x2208"
        }
        return imageName
    }
    
    @objc private func skipAction(btn:UIButton){
        if let callback = finishCallback {
            callback()
        }
    }
    
    func setSplashImage(image:UIImage){
        splashIcon.image = image
    }
}
