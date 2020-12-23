//
//  ZSNotificationViewModel.swift
//  zhuishushenqi
//
//  Created by yung on 2019/7/7.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit
import ZSAPI

class ZSNotificationViewModel {
    var viewDidLoad: ()->() = {}
    var reloadBlock: ()->() = {}
    
    var notifications:[ZSNotification] = []
    
    var type:NotificationType = .message
    
    init() {
        viewDidLoad = { [weak self] in
            self?.requestImportant()
            self?.requestUnimportant()
        }
    }
    
    func requestImportant() {
        requestImportant { [weak self] in
            self?.reloadBlock()
        }
    }
    
    func requestImportant(completion:@escaping()->Void) {
        let api = ZSAPI.important(token: ZSLogin.share.token)
        zs_get(api.path, parameters: api.parameters) { [weak self] (json) in
            guard let notifications = json?["notifications"] as? [Any] else {
                completion()
                return
            }
            if let noti = [ZSNotification].deserialize(from: notifications) as? [ZSNotification] {
                self?.notifications = noti
                completion()
            } else {
                completion()
            }
        }
    }
    
    func requestUnimportant() {
        requestUnimportant { [weak self] in
            self?.reloadBlock()
        }
    }
    
    func requestUnimportant(completion:@escaping()->Void) {
        let api = ZSAPI.unimportant(token: ZSLogin.share.token)
        zs_get(api.path, parameters: api.parameters) { [weak self] (json) in
            guard let notifications = json?["notifications"] as? [Any] else {
                completion()
                return
            }
            if let noti = [ZSNotification].deserialize(from: notifications) as? [ZSNotification] {
                self?.notifications = noti
                completion()
            } else {
                completion()
            }
        }
    }
    
    func postRead(completion:@escaping(_ result:Bool)->Void) {
        let api = ZSAPI.readImportant(token: ZSLogin.share.token)
        zs_post(api.path, parameters: api.parameters) { (json) in
            if let result = json?["ok"] as? Bool {
                completion(result)
            } else {
                completion(false)
            }
        }
    }
}
