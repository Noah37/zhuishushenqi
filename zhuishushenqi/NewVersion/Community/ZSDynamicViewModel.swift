//
//  ZSDynamicViewModel.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2019/7/6.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit
import ZSAPI

class ZSDynamicViewModel {
    var viewDidLoad: ()->() = {}
    var reloadBlock: ()->() = {}
    
    var dynamic:ZSDynamic?
    var followings:[ZSFollowings] = []
    
    init() {
        
    }
    
    func requestFollowings(id:String) {
        requestFollowings(id: id) { [weak self] in
            self?.reloadBlock()
        }
    }
    
    func requestFollowings(id:String,completion:@escaping()->Void) {
        let api = ZSAPI.userFollowings("\(id)")
        zs_get(api.path) { [weak self] (json) in
            guard let followings = json?["followings"] as? [Any] else {
                completion()
                return
            }
            if let follows = [ZSFollowings].deserialize(from: followings) as? [ZSFollowings] {
                self?.followings = follows
                completion()
            } else {
                completion()
            }
        }
    }
    
    func requestCommunity(id:String) {
        requestCommunity(id:id) { [weak self] in
            self?.reloadBlock()
        }
    }
    
    
    func requestCommunity(id:String, completion:@escaping()->Void) {
        let api = ZSAPI.userTwitters("\(id)", last: "")
        zs_get(api.path) { [weak self] (json) in
            if let dynamic = ZSDynamic.deserialize(from: json) {
                self?.dynamic = dynamic
                completion()
            } else {
                completion()
            }
        }
    }
    
    func requestMore(id:String) {
        requestMore(id:id) { [weak self] in
            self?.reloadBlock()
        }
    }
    
    
    func requestMore(id:String, completion:@escaping()->Void) {
        guard let last = dynamic?.tweets.last?._id else {
            completion()
            return
        }
        let api = ZSAPI.userTwitters("\(id)", last: "\(last)")
        zs_get(api.path) { [weak self] (json) in
            if let dynamic = ZSDynamic.deserialize(from: json) {
                self?.dynamic = dynamic
                completion()
            } else {
                completion()
            }
        }
    }
    
    func focus(id:String, completion:@escaping(_ success:Bool)->Void) {
        let api = ZSAPI.focus(token: ZSLogin.share.token, followeeId: id)
        zs_post(api.path, parameters: api.parameters) { (json) in
            if let result = json?["ok"] as? Bool {
                ZSLogin.share.fetchFollowings()
                completion(result)
            } else {
                completion(false)
            }
        }
    }
    
    func unFocus(id:String, completion:@escaping(_ success:Bool)->Void) {
        let api = ZSAPI.unFocus(token: ZSLogin.share.token, followeeId: id)
        zs_post(api.path, parameters: api.parameters) { (json) in
            if let result = json?["ok"] as? Bool {
                ZSLogin.share.fetchFollowings()
                completion(result)
            } else {
                completion(false)
            }
        }
    }
}
