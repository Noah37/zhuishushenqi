//
//  ZSCommunityViewModel.swift
//  zhuishushenqi
//
//  Created by caony on 2019/7/2.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit
import ZSAPI

class ZSCommunityViewModel {
    var viewDidLoad: ()->() = {}
    var reloadBlock: ()->() = {}
    
    var twitters:[QSHotModel] = []
    
    private var start:Int = 0
    private var limit:Int = 20
    
    init() {
        viewDidLoad = { [weak self] in
            self?.requestCommunity(completion: { [weak self] in
                self?.reloadBlock()
            })
        }
    }
    
    func requestCommunity() {
        requestCommunity { [weak self] in
            self?.reloadBlock()
        }
    }
    
    func requestMore() {
        guard let model = twitters.last else {
            self.reloadBlock()
            return
        }
        requestMore(model: model) { [weak self] in
            self?.reloadBlock()
        }
    }
    
    func requestMore(model:QSHotModel,completion:@escaping()->Void) {
        let api = ZSAPI.userTwitter("\(model.tweet._id)")
        zs_get(api.path, parameters: api.parameters) { [weak self] (json) in
            guard let tweets = json?["tweets"] as? [Any] else {
                completion()
                return
            }
            if let twitters = [QSHotModel].deserialize(from: tweets) as? [QSHotModel] {
                self?.twitters.append(contentsOf: twitters)
                completion()
            } else {
                completion()
            }
        }
    }
    
    func requestCommunity(completion:@escaping()->Void) {
        let api = ZSAPI.userTwitter("")
        zs_get(api.path) { [weak self] (json) in
            guard let tweets = json?["tweets"] as? [Any] else {
                completion()
                return
            }
            if let twitters = [QSHotModel].deserialize(from: tweets) as? [QSHotModel] {
                self?.twitters = twitters
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
    
    //MARK: - 社区
    func getCommunity(completion:@escaping()->Void) {
        let api = ZSAPI.communityHot(start: start, limit: limit)
        ZSNet.getJSON(api.path, parameters: api.parameters) { (json) in
            guard let feeds = json?["feeds"] as? [[String:Any]] else {  completion(); return }
            
        }
    }
}
