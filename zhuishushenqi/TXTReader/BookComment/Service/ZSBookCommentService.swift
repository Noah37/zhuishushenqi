//
//  ZSBookCommentService.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2018/6/16.
//  Copyright © 2018年 QS. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxAlamofire
import Alamofire
import HandyJSON

final class ZSBookCommentService:ZSBaseService {
    
    func fetchCommentDetail(id:String,type:QSBookCommentType)->Observable<BookComment>{
        let urlString = getDetailURL(id: id, type: type)
        return requestJSON(.get, urlString).observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map({ (_,response)  in
                if let reader = (response as AnyObject).object(forKey: "review") as? NSDictionary {
                    if let model = BookComment.deserialize(from: reader ) {
                        return model
                    }
                }
                return BookComment()
            })
    }
    
    func fetchCommentBest(id:String)->Observable<[BookCommentDetail]>{
        let best = "\(BASEURL)/post/\(id)/comment/best"
        return requestJSON(.get, best)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map({ (_,response) in
                if let books = (response as AnyObject).object(forKey: "comments") {
                    if let models = [BookCommentDetail].deserialize(from: books as? [Any]) as? [BookCommentDetail] {
                        return models
                    }
                }
                return [BookCommentDetail]()
            })
    }
    
    func fetchNormalMore(id:String,type:QSBookCommentType,start:Int,limit:Int)->Observable<[BookCommentDetail]>{
        let comment = getCommentURL(id: id, type: type,start: start,limit: limit)
        return requestJSON(.get, comment.0, parameters: comment.1, encoding: URLEncoding.default, headers: nil)
                .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map({ (_,response) in
                if let books = (response as AnyObject).object(forKey: "comments") as? [Any]{
                    if let models = [BookCommentDetail].deserialize(from: books) as? [BookCommentDetail] {
                        return models
                    }
                }
                return [BookCommentDetail]()
            })
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
