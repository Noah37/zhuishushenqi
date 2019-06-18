//
//  Notification+QSExtension.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2018/2/6.
//  Copyright © 2018年 QS. All rights reserved.
//

import Foundation

public typealias NotificationHandler = () ->Void

extension NotificationCenter {
    public static var observerHandler:NotificationHandler?
    
    public static func qs_addObserver(observer:Any,selector:Selector,name:String,object:Any?) -> Void {
        NotificationCenter.default.addObserver(observer, selector: selector, name: Notification.Name(rawValue: name), object: object)
    }
    
    public static func zs_addObserver(oberver:Any,name:String,_ handler:NotificationHandler?){
        observerHandler = handler
        self.qs_addObserver(observer: self, selector: #selector(NotificationCenter.observerHandlerAction), name: name, object: nil)
    }
    
    public static func qs_postNotification(name:String,obj:Any?){
        let noti = Notification(name: Notification.Name(rawValue: name), object: obj, userInfo: nil)
        NotificationCenter.default.post(noti)
    }
    
    public static func qs_removeObserver(observer:Any,name:String,object:Any?){
        NotificationCenter.default.removeObserver(observer, name: Notification.Name(rawValue: name), object: object)
    }
    
    @objc public static func observerHandlerAction(){
        NotificationCenter.observerHandler?()
    }
}
