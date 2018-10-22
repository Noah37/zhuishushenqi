//
//  AppDelegate.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 16/9/16.
//  Copyright © 2016年 QS. All rights reserved.
//

import UIKit
import RxSwift

let rightScaleX:CGFloat = 0.2

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let sideVC = SideViewController.shared
        sideVC.contentViewController = ZSRootViewController()
        sideVC.rightViewController = RightViewController(style: .grouped)
        sideVC.leftViewController = LeftViewController()
        let sideNavVC = ZSBaseNavigationViewController(rootViewController: sideVC)
        window?.rootViewController = sideNavVC
        window?.makeKeyAndVisible()
        UIApplication.shared.setStatusBarHidden(false, with: .fade)
        #if DEBUG
            let fpsLabel = V2FPSLabel(frame: CGRect(x:15, y:ScreenHeight-40, width:55,height: 20));
            self.window?.addSubview(fpsLabel);
        #else
        #endif

        configureDataBase()
//        [application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        /**
         设置 UINavigationNar 外观
         */
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().tintColor = UIColor ( red: 0.7235, green: 0.0, blue: 0.1146, alpha: 1.0 )
//        let navbarTitleTextAttributes = [NSForegroundColorAttributeName:UIColor ( red: 0.7235, green: 0.0, blue: 0.1146, alpha: 1.0 )]
//        UINavigationBar.appearance().titleTextAttributes = navbarTitleTextAttributes
        UIApplication.shared.statusBarStyle = .lightContent
        
        let splash = QSSplashScreen()
        let disposeBag = DisposeBag()
        splash.show {
            // 新版本特性
            let firstRun = USER_DEFAULTS.object(forKey: "FIRSTRUN") as? Bool
            if firstRun == nil {
                USER_DEFAULTS.set(false, forKey: "FIRSTRUN")
                let introduce = QSIntroducePage()
                introduce.show(completion: {
                    // 根据性别推荐书籍(第一次安装才会出现) 由home页面自己发起
                    NotificationCenter.default.post(Notification(name: Notification.Name(rawValue:SHOW_RECOMMEND)))
                })
            }else{
                let mainWindow:UIWindow? = (UIApplication.shared.delegate?.window)!
                mainWindow?.makeKeyAndVisible()
            }
        }
        splash.subject.subscribe { (event) in
            QSLog("显示完成:\(event)")
        }.disposed(by: disposeBag)
        
        
        IFlySetting.setLogFile(LOG_LEVEL.LVL_ALL)
        IFlySetting.showLogcat(true)
        let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first ?? ""
        IFlySetting.setLogFilePath(paths)
//        let appid = "5ba0b197"
        let xfyj = "5445f87d"
        let zssq = "566551f4"
        //        let xfyj2 = "591a4d99"
        let initString = "appid=\(xfyj)"
        IFlySpeechUtility.createUtility(initString)
        
        // 提前解析
        DispatchQueue.main.async {
            TTSConfig.share.getSpeakers()
        }
        
//        QSLog(String.localized_login)
        QSLog(ZSBookManager.shared)
        
        WeiboSDK.enableDebugMode(true)
        WeiboSDK.registerApp(ZSThirdLogin.WBAppID)
        return true
    }
    
    func configureDataBase(){
        let store  = YTKKeyValueStore(dbWithName: dbName)
        
        if store?.isTableExists(searchHistory) == false {
            store?.createTable(withName: searchHistory)
        }
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        QQApiInterface.handleOpen(url, delegate: ZSThirdLogin.share)
        if TencentOAuth.canHandleOpen(url) {
            return TencentOAuth.handleOpen(url)
        }
        var result = WXApi.handleOpen(url, delegate: WXApiRequestHandler.share)
        result = WeiboSDK.handleOpen(url, delegate: ZSThirdLogin.share)
        return result
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        QQApiInterface.handleOpen(url, delegate: ZSThirdLogin.share)
        if TencentOAuth.canHandleOpen(url) {
            return TencentOAuth.handleOpen(url)
        }
        var result = WXApi.handleOpen(url, delegate: WXApiRequestHandler.share)
        result = WeiboSDK.handleOpen(url, delegate: ZSThirdLogin.share)
        return result
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        let pasteboard = UIPasteboard.general
        let items = pasteboard.items
        for item in items {
            if let vcnList = item["IFlySpeechPlusVcnList"] as? Data {
                if let files = NSKeyedUnarchiver.unarchiveObject(with: vcnList) as? [[String:Any]] {
                    for file in files {
                        if let vcn = file["vcn"] as? [String:Any] {
                            if let data = file["data"] as? Data {
                                let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
                                let filePath = "\(path)/\(vcn["name"] ?? "").jet"
                                let url = URL(fileURLWithPath: filePath)
                                let success = try? data.write(to: url)
                                QSLog("save success.")
                            }
                        }
                    }
                }
                
            } else if ZSThirdLoginStorage.share.canHandle(pasteData: item) {
                ZSThirdLoginStorage.share.handle(pasteData: item as! [String : Data])
            }
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


