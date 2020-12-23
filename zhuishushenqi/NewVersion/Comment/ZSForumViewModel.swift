//
//  ZSForumViewModel.swift
//  zhuishushenqi
//
//  Created by yung on 2019/8/6.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit
import ZSAPI

class ZSForumViewModel {
    
    var viewDidLoad: ()->() = {}
    var reloadBlock: ()->() = {}
    
    var id:String = ""
    
    var review:ZSPostReview?
    var bestComment:[ZSForumComment] = []
    
    var comments:[ZSForumComment] = []
    
    var start:Int = 0
    var limit:Int = 0
    
    var noMoreData:Bool = false
    
    init() {
        viewDidLoad = { [weak self] in
            self?.request()
        }
    }
    
    func haveFooter() ->Bool {
        return bestComment.count == 0 && comments.count == 0
    }
    
    func haveBest() ->Bool {
        return bestComment.count != 0
    }
    
    func haveNormal() ->Bool {
        return comments.count != 0
    }
    
    func numberOfSections() ->Int {
        var sections = 1
        if bestComment.count > 0 {
            sections += 1
        }
        if comments.count > 0 {
            sections += 1
        }
        return sections
    }
    
    func numberOfRowsInSection(section:Int) ->Int {
        var rows = 0
        if section == 1 {
            if bestComment.count > 0 {
                rows = bestComment.count
            } else if comments.count > 0 {
                rows = comments.count
            }
        } else if section == 2 {
            rows = comments.count
        }
        return rows
    }
    
    func cellModel(for indexPath:IndexPath) -> ZSForumComment{
        var model:ZSForumComment = ZSForumComment()
        if indexPath.section == 1 {
            if bestComment.count > 0 {
                model = bestComment[indexPath.row]
            } else if comments.count > 0 {
                model = comments[indexPath.row]
            }
        } else {
            if comments.count > 0 {
                model = comments[indexPath.row]
            }
        }
        return model
    }

    //MARK: - request
    func request() {
        requestDetail { [weak self] in
            self?.reloadBlock()
        }
        requestNormal { [weak self] in
            self?.reloadBlock()
        }
        requestBest { [weak self] in
            self?.reloadBlock()
        }
    }
    
    func requestMore() {
        requestMore {  [weak self](haveMore) in
            self?.noMoreData = true
            self?.reloadBlock()
        }
    }
    
    private func requestDetail(completion:@escaping()->Void) {
        let api = ZSAPI.post(key: id)
        zs_get(api.path) { [weak self](json) in
            guard let review = json?["post"] as? [String:Any] else {
                completion()
                return
            }
            guard let postView = ZSPostReview.deserialize(from: review) else {
                completion()
                return
            }
            self?.review = postView
            completion()
        }
    }
    
    private func requestNormal(completion:@escaping()->Void) {
        start = 0
        limit = 50
        requestMore { _ in
            completion()
        }
    }
    
    private func requestMore(completion:@escaping(_ haveMore:Bool)->Void) {
        if comments.count % 50 != 0 {
            completion(false)
            return
        }
        start += 50
        let api = ZSAPI.hotPost(key: id, start: "\(start)", limit: "\(limit)")
        zs_get(api.path, parameters: api.parameters) { [weak self](json) in
            guard let comments = json?["comments"] as? [[String:Any]] else {
                completion(true)
                return
            }
            guard let commentModels = [ZSForumComment].deserialize(from: comments) as? [ZSForumComment] else {
                completion(true)
                return
            }
            self?.comments = commentModels
            completion(true)
        }
    }
    
    private func requestBest(completion:@escaping()->Void) {
        let api = ZSAPI.hotComment(key: id)
        zs_get(api.path) { [weak self](json) in
            guard let comments = json?["comments"] as? [[String:Any]] else {
                completion()
                return
            }
            guard let commentModels = [ZSForumComment].deserialize(from: comments) as? [ZSForumComment] else {
                completion()
                return
            }
            self?.bestComment = commentModels
            completion()
        }
    }
}
