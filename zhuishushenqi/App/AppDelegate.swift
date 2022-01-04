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
        
        // Cause API of UI called on a background thread issue.
//        GADMobileAds.sharedInstance().start(completionHandler: nil)
//        AppOpenAdManager.shared.loadAd()
        
        BUAdManager.shared.loadAd()

        #if DEBUG
//        DoraemonManager.shareInstance().install()
        FLEXManager.shared().showExplorer()
        #endif
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(type(of: self).removeAllObjects), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
        
        // 新版本特性
        let firstRun = USER_DEFAULTS.bool(forKey: UserDefaults.firstRunKey)
        if !firstRun {
            USER_DEFAULTS.set(false, forKey: UserDefaults.firstRunKey)
            ZSIntroducePage.shared.show {
                // 根据性别推荐书籍(第一次安装才会出现) 由home页面自己发起
                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue:SHOW_RECOMMEND)))
            }
        }

        if #available(iOS 9.0, *) {
            
        } else {
            UIApplication.shared.setStatusBarHidden(false, with: .fade)
            UIApplication.shared.statusBarStyle = .lightContent
        }
        #if DEBUG
            let fpsLabel = V2FPSLabel(frame: CGRect(x:15, y:ScreenHeight-40, width:55,height: 20));
            self.window?.addSubview(fpsLabel);
        #else
        #endif

        configureDataBase()
        /**
         设置 UINavigationNar 外观
         */
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().tintColor = UIColor ( red: 0.7235, green: 0.0, blue: 0.1146, alpha: 1.0 )
        let navbarTitleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor ( red: 0.7235, green: 0.0, blue: 0.1146, alpha: 1.0 )]
        UINavigationBar.appearance().titleTextAttributes = navbarTitleTextAttributes
        
//        let APP_KEY = "e31646fa4555ea3472d4114921ee192e"
//        let APP_SECRET = "b961a55b60fbd7129e49a986e44352fb"
//        XMSDKPlayer.shared()?.setAutoNexTrack(true)
//        XMReqMgr.sharedInstance()?.registerXMReqInfo(withKey: APP_KEY, appSecret: APP_SECRET)
        
        IFlySetting.setLogFile(LOG_LEVEL.LVL_ALL)
        IFlySetting.showLogcat(true)
        let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first ?? ""
        IFlySetting.setLogFilePath(paths)
//        let appid = "5ba0b197"
//        let xfyj = "5445f87d"
//        let zssq = "566551f4"
//        let xfyj2 = "591a4d99"
//        let initString = "appid=\(zssq)"
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
        // zhuishu的解密方法
        let textFile = Bundle.main.path(forResource: "EncrtptorText", ofType: nil) ?? ""
        if let cpContent = try? String(contentsOfFile: textFile) {
            let str =  FBEncryptorAESUtils.getDecryptedStr(withKey: "inTv0kKl4pI1BMk2munvAg==", cipherText: cpContent)
            print("FBEncryptorAESUtils:\(str)")
        }
    }
    
    func showSplash() {
        // 后台超过3分钟才展示开屏广告
        let splashTime = UserDefaults.standard.double(forKey: UserDefaults.splashTimeKey)
        let currentTime = Date().timeIntervalSince1970
        if currentTime - splashTime > 180 {
            UserDefaults.standard.set(currentTime, forKey: UserDefaults.splashTimeKey)
            UserDefaults.standard.synchronize()
            let splashViewController = UIStoryboard.main.instantiateInitialViewController()
            let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
            keyWindow?.rootViewController = splashViewController
        }
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
        showSplash()
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
                                _ = try? data.write(to: url)
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
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


