//
//  QSSplashScreen.swift
//  zhuishushenqi
//
//  Created by yung on 2017/6/8.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

typealias SplashCallback = ()->Void

class QSSplashScreen: NSObject {
    
    var splashInfo:[String:Any] = [:]
    var subject:PublishSubject<Any>!
    private var splashRootVC:QSSplashViewController?
    private var remainDelay:Int = 3
    private var shouldHidden:Bool = true
    private let splashInfoKey = "splashInfoKey"
    private let splashImageNameKey = "splashImageNameKey"
    var completion:SplashCallback?
    
    private let splashURL = "http://api.zhuishushenqi.com/splashes/ios"
    
    func show(completion:@escaping SplashCallback){
        self.completion = completion
        let subject = PublishSubject<Any>()
        self.subject = subject
        detachRootViewController()
        let splashWindoww = UIWindow(frame: UIScreen.main.bounds)
        splashWindoww.backgroundColor = UIColor.black
        splashRootVC = QSSplashViewController()
        splashRootVC?.finishCallback = {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.showSplash), object: nil)
            self.subject.onNext(true)
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
        // first check network, load image from disk,if not reachable
        if Reachability(hostname: IMAGE_BASEURL)?.isReachable == false {
            let path = "/ZSSQ/Splash"
            if let dict = ZSCacheHelper.shared.cachedObj(for: splashInfoKey, cachePath: path) as? [String:Any] {
                let splashInfo = dict
                // image not exist,skip
                // searchPah exchange everytime you run your app
                let imageName = splashInfo[splashImageNameKey] as? String ?? ""
                let imagePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first?.appending("/\(imageName)") ?? ""
                let image = UIImage(contentsOfFile: imagePath)
                if let splashImage = image {
                    self.perform(#selector(self.showSplash), with: nil, afterDelay: 1.0)
                    self.splashRootVC?.setSplashImage(image: splashImage)
                }else{
                    hide()
                }
            } else {
                hide()
            }
            return
        }
        
        // request splash image
//        QSNetwork.request(splashURL) { (response) in
//            let splash =  response.json?["splash"] as? [[String:Any]]
//            if (splash?.count ?? 0) > 0{
//                if let splashInfo = splash?[0] {
//                    // save splash info,download image and save it
//                    self.splashInfo = splashInfo
//                    self.downloadSplashImage()
//                }else{
//                    self.hide()
//                }
//            }else {
//            }
//        }
        self.hide()
    }
    
    func downloadSplashImage(){
        let urlString = getSplashURLString()
        zs_download(url: urlString) { (response) in
            
        }
//        QSNetwork.download(urlString) { (fileURL, response, error) in
//            QSLog("\(fileURL?.path ?? "")")
//            let splashImage = UIImage(contentsOfFile: fileURL?.path ?? "")
//            self.splashInfo[self.splashImageNameKey] = fileURL?.lastPathComponent ?? ""
//            let path = "/ZSSQ/Splash"
//            ZSCacheHelper.shared.storage(obj: self.splashInfo, for: self.splashInfoKey, cachePath: path)
//            self.perform(#selector(self.showSplash), with: nil, afterDelay: 1.0)
//            if let image  = splashImage {
//                self.splashRootVC?.setSplashImage(image: image)
//            }
//        }
    }
    
    @objc func showSplash(){
        remainDelay -= 1
        if remainDelay == 0 {
            hide()
        }
        self.perform(#selector(self.showSplash), with: nil, afterDelay: 1.0)
    }
    
    func getSplashURLString()->String {
        //according to screen dimension
        let imageString = self.splashInfo["img"] as? String ?? ""
        return  imageString
    }
    
    func hide(){
        if shouldHidden {
            shouldHidden = false
            attachRootViewController()
            splashWindow = nil
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
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
