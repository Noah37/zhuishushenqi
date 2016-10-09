//
//  AppDelegate.swift
//  zhuishushenqi
//
//  Created by caonongyun on 16/9/16.
//  Copyright © 2016年 CNY. All rights reserved.
//

import UIKit

let rightScaleX:CGFloat = 0.2

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,RESideMenuDelegate{

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let sideVC = SideViewController.sharedInstance
        sideVC.contentViewController = RootViewController()
        sideVC.rightViewController = RightViewController(style: .Grouped)
        sideVC.leftViewController = LeftViewController()
        let sideNavVC = UINavigationController(rootViewController: SideViewController.sharedInstance)
        window?.rootViewController = sideNavVC
        window?.makeKeyAndVisible()
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Fade)
        #if DEBUG
            let fpsLabel = V2FPSLabel(frame: CGRectMake(15, ScreenHeight-40, 55, 20));
            self.window?.addSubview(fpsLabel);
        #else
        #endif

//        [application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        /**
         设置 UINavigationNar 外观
         */
        UINavigationBar.appearance().barTintColor = UIColor.whiteColor()
        UINavigationBar.appearance().tintColor = UIColor ( red: 0.7235, green: 0.0, blue: 0.1146, alpha: 1.0 )
//        let navbarTitleTextAttributes = [NSForegroundColorAttributeName:UIColor ( red: 0.7235, green: 0.0, blue: 0.1146, alpha: 1.0 )]
//        UINavigationBar.appearance().titleTextAttributes = navbarTitleTextAttributes
        UIApplication.sharedApplication().statusBarStyle = .LightContent

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

// 首先要明确一点: swift里面是没有宏定义的概念
// 自定义内容输入格式: 文件名[行号]函数名: 输入内容
// 需要在info.plist的other swift flag的Debug中添加DEBUG
func XYCLog<T>(message: T, fileName: String = #file, lineNum: Int = #line, funcName: String = #function)
{
    #if DEBUG
        print("\((fileName as NSString).lastPathComponent)[\(lineNum)] \(funcName): \(message)")
    #endif
}

