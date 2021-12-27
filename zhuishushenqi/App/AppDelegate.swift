//
//  AppDelegate.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 16/9/16.
//  Copyright © 2016年 QS. All rights reserved.
//

import UIKit
import RxSwift
import GoogleMobileAds

#if DEBUG
//import DoraemonKit
import FLEX
import ZSAppConfig
#endif


let rightScaleX:CGFloat = 0.2
let rootVCKey = "rootVCKey"
let GADUnitID = "ca-app-pub-6271484308025079/5733340734"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var lastTabVC:UIViewController?
    
    var appOpenAd:GADAppOpenAd?
    
    var loadTime:Date?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        AppOpenAdManager.shared.loadAd()
        
        BUAdManager.shared.loadAd()

        #if DEBUG
//        DoraemonManager.shareInstance().install()
        FLEXManager.shared().showExplorer()
        #endif
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(type(of: self).removeAllObjects), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
        
        
//        window = UIWindow(frame: UIScreen.main.bounds)
//        let tabBarVC = ZSTabBarController()
//        window?.rootViewController = tabBarVC
            
//        let splash = QSSplashScreen()
//        let disposeBag = DisposeBag()
//        splash.show { [weak self] in
//            // 新版本特性
//            let firstRun = USER_DEFAULTS.object(forKey: "FIRSTRUN") as? Bool
//            if firstRun == nil {
//                USER_DEFAULTS.set(false, forKey: "FIRSTRUN")
//                let introduce = QSIntroducePage()
//                introduce.show(completion: {
//                    // 根据性别推荐书籍(第一次安装才会出现) 由home页面自己发起
//                    NotificationCenter.default.post(Notification(name: Notification.Name(rawValue:SHOW_RECOMMEND)))
//                })
//            }else{
//                self?.window?.makeKeyAndVisible()
//            }
//        }
//        splash.subject.subscribe { (event) in
//
//            }.disposed(by: disposeBag)
        
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
        
        
//        let APP_KEY = "e31646fa4555ea3472d4114921ee192e"
//        let APP_SECRET = "b961a55b60fbd7129e49a986e44352fb"
//        XMSDKPlayer.shared()?.setAutoNexTrack(true)
//        XMReqMgr.sharedInstance()?.registerXMReqInfo(withKey: APP_KEY, appSecret: APP_SECRET)
        
        IFlySetting.setLogFile(LOG_LEVEL.LVL_ALL)
        IFlySetting.showLogcat(true)
        let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first ?? ""
        IFlySetting.setLogFilePath(paths)
//        let appid = "5ba0b197"
        let xfyj = "5445f87d"
        let zssq = "566551f4"
//        let xfyj2 = "591a4d99"
        let initString = "appid=\(zssq)"
//        IFlySpeechUtility.createUtility(initString)
        
        // 提前解析
        DispatchQueue.global().async {
            TTSConfig.share.getSpeakers()
        }
        
        ZSBookManager.shared
        
        let path = "\(NSHomeDirectory())/Documents/Inbox/"
        ZSShelfManager.share.scanPath(path: path)

        
//        WeiboSDK.enableDebugMode(false)
//        WeiboSDK.registerApp(ZSThirdLogin.WBAppID)
        
        // database
        /*测试代码
         let database = ZSDatabase()
         database.createBookshelf()
         if let book = ZSBookManager.shared.books.allValues().first as? BookDetail {
         database.insertBookshelf(book: book)
         }
         let books = database.queryBookshelf()
         QSLog("books:\(books)")
         
         let testModel = ZSDBTestModel()
         let subModel = ZSDBTestSubModel()
         subModel.key = "IU6rIl2d2GWnEio"
         testModel.id = "Yg5fsKPOvpii0qAH2lpmJhjFmRhfe4dshhjY5Oim2Y"
         testModel.num = 1
         testModel.subModel = subModel
         
         ZSDBManager.share()?.getPropertys(testModel)
         
         */
        decryptedStr()
        
        return true
    }
    
    func configureDataBase(){
        let store  = YTKKeyValueStore(dbWithName: dbName)
        
        if store?.isTableExists(searchHistory) == false {
            store?.createTable(withName: searchHistory)
        }
    }
    
    @objc
    func removeAllObjects() {
        let alert = UIAlertController(title: "提示", message: "内存警告", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "确定", style: .default) { (action) in
            
        }
        alert.addAction(confirmAction)
        if let vc = self.window?.rootViewController {
            vc.present(alert, animated: true, completion: nil)
        }
    }
    
    func decryptedStr() {
        let cpContent = "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"
        
        let str =  FBEncryptorAESUtils.getDecryptedStr(withKey: "inTv0kKl4pI1BMk2munvAg==", cipherText: cpContent)

    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let path = "\(NSHomeDirectory())/Documents/Inbox/"
        ZSShelfManager.share.scanPath(path: path)
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.isFileURL {
            NotificationCenter.default.post(name: NSNotification.Name.LocalShelfChanged, object: nil)
            return true
        }
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
                            }
                        }
                    }
                }
                
            } else if ZSThirdLoginStorage.share.canHandle(pasteData: item) {
                ZSThirdLoginStorage.share.handle(pasteData: item as! [String : Data])
            }
        }
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .all
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        let rootViewController = application.windows.first(
              where: { $0.isKeyWindow })?.rootViewController
        if let rootViewController = rootViewController {
          // Do not show app open ad if the current view controller is SplashViewController.
          if rootViewController is SplashViewController {
            return
          }
          AppOpenAdManager.shared.showAdIfAvailable(viewController: rootViewController)
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


