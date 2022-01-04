//
//  ApplicationExtension.swift
//  zhuishushenqi
//
//  Created by yung on 2020/6/18.
//  Copyright © 2020 QS. All rights reserved.
//

import Foundation
import UIKit

#if DEBUG
extension UIApplication {
    
    @available(iOS 13.0, *)
    static let windowScene:UIWindowScene? = UIApplication.shared.connectedScenes.filter { $0.activationState == .foregroundActive }.first as? UIWindowScene
    
    var keywindow:UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.windowScene?.windows.first(where: { $0.isKeyWindow })
        } else {
            return UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        }
    }
    
    private class ApplicationState {
        
        static let shared = ApplicationState()
        
        var current = UIApplication.State.inactive
        
        private init() {
            let center = NotificationCenter.default
            let mainQueue = OperationQueue.main
            center.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: mainQueue) { (notification) in
                self.current = UIApplication.shared.applicationState
            }
            center.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: mainQueue) { (notification) in
                self.current = UIApplication.shared.applicationState
            }
            center.addObserver(forName: UIApplication.didFinishLaunchingNotification, object: nil, queue: mainQueue) { (notification) in
                self.current = UIApplication.shared.applicationState
            }
            center.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: mainQueue) { (notification) in
                self.current = UIApplication.shared.applicationState
            }
            center.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: mainQueue) { (notification) in
                self.current = UIApplication.shared.applicationState
            }
        }
    }
    
    @objc
    private var __applicationState: UIApplication.State {
        if Thread.isMainThread {
            return self.__applicationState
        } else {
            return ApplicationState.shared.current
        }
    }
    
    /// FIXME: -[UIApplication applicationState] called on a background thread.
    public static func mainThreadApplicationState() {
        if let originalMethod = class_getInstanceMethod(UIApplication.self, #selector(getter: applicationState)),
            let swizzledMethod = class_getInstanceMethod(UIApplication.self, #selector(getter: __applicationState)) {
            _ = ApplicationState.shared
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
}
#endif
