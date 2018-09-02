//
//  ZSBookCTService.swift
//  zhuishushenqi
//
//  Created by caony on 2018/8/28.
//  Copyright © 2018年 QS. All rights reserved.
//

import Foundation

class ZSBookCTService:ZSBaseService {
    func fetchCommentDetail(id:String,type:QSBookCommentType,handler:@escaping ZSBaseCallback<BookComment>){
        let urlString = getDetailURL(id: id, type: type)
        zs_get(urlString) { (json) in
            if let review = json?["review"] as? [String:Any]{
                if let model = BookComment.deserialize(from: review) {
                    handler(model)
                }
            }
        }
    }
    
    func fetchCommentBest(id:String,handler:@escaping ZSBaseCallback<[BookCommentDetail]>){
        let best = "\(BASEURL)/post/\(id)/comment/best"
        zs_get(best) { (json) in
            if let review = json?["comments"] as? [Any]{
                if let model = [BookCommentDetail].deserialize(from: review) as? [BookCommentDetail] {
                    handler(model)
                }
            }
        }
    }
    
    func fetchNormalMore(id:String,type:QSBookCommentType,start:Int,limit:Int,handler:@escaping ZSBaseCallback<[BookCommentDetail]>){
        let comment = getCommentURL(id: id, type: type,start: start,limit: limit)
        zs_get(comment.0, parameters: comment.1) { (json) in
            if let review = json?["comments"] as? [Any]{
                if let model = [BookCommentDetail].deserialize(from: review) as? [BookCommentDetail] {
                    handler(model)
                }
            }
        }
    }
    
    func getCommentURL(id:String,type:QSBookCommentType,start:Int,limit:Int)->(String,[String:Any]){
        var urlString = ""
        var param:[String:Any] = [:]
        switch type {
        case .normal:
            //        http://api.zhuishushenqi.com/post/review/530a26522852d5280e04c19c/comment?start=0&limit=50
            urlString = "\(BASEURL)/post/review/\(id)/comment"
            param = ["start":"\(start)","limit":"\(limit)"]
            break
        case .hotUser:
            //            http://api.zhuishushenqi.com/user/twitter/58d14859d0693ae736034619/comments
            urlString = "\(BASEURL)/user/twitter/\(id)/comments"
            break
        case .hotPost:
            //            http://api.zhuishushenqi.com/post/58d1d313bd7cc9961f93192d/comment?start=0&limit=50
            urlString = "\(BASEURL)/post/\(id)/comment"
            param = ["start":"\(start)","limit":"\(limit)"]
            break
        }
        return (urlString,param)
    }
    
    func getDetailURL(id:String,type:QSBookCommentType)->String{
        var urlString = ""
        switch type {
        case .normal:
            urlString = "\(BASEURL)/post/review/\(id)"
            break
        case .hotUser:
            
            urlString = "\(BASEURL)/user/twitter/\(id)"
            break
        case .hotPost:
            //            http://api.zhuishushenqi.com/post/58d1d313bd7cc9961f93192d/comment?start=0&limit=50
            urlString = "\(BASEURL)/post/\(id)"
            break
        }
        return urlString
    }
}
