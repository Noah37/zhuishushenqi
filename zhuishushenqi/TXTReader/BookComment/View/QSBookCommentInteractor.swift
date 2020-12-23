//
//  QSBookCommentInteractor.swift
//  zhuishushenqi
//
//  Created yung on 2017/4/24.
//  Copyright © 2017年 QS. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import ZSAPI

class QSBookCommentInteractor: QSBookCommentInteractorProtocol {

    var output: QSBookCommentInteractorOutputProtocol?
    
    var model:BookComment!
    var hotComments:[BookCommentDetail] = []
    var normalComments:[BookCommentDetail] = []
    var start:Int = 0
    var commentType:QSBookCommentType = .normal
    private var limit:Int = 1000
    private var param:[String:Any]?
    fileprivate var readerModel:BookComment?
    fileprivate var hotModel:QSHotModel?
    
    func requestHot(){
        let best = "\(BASEURL)/post/\(model._id)/comment/best"
        zs_get(best) { (response) in
            if let books = response?["comments"] {
                if let magicComments = [BookCommentDetail].deserialize(from: books as? [Any]) as? [BookCommentDetail] {
                    self.hotComments = magicComments
                    self.output?.fetchHotSuccess(hots: self.hotComments)
                } else {
                    self.output?.fetchHotFailed()
                }
            }else{
                self.output?.fetchHotFailed()
            }
        }
    }
    
    func requestNormal(){
        let comment = getCommentURL(type: .normal)
        zs_get(comment, parameters: self.param) { (response) in
            if let books = response?["comments"]  {
                
                if let models = [BookCommentDetail].deserialize(from: books as? [Any]) as? [BookCommentDetail] {
                    self.normalComments.append(contentsOf: models)
                    self.output?.fetchNormalSuccess(normals: self.normalComments)
                }else{
                    self.output?.fetchNormalFailed()
                }
            }else{
                self.output?.fetchNormalFailed()
            }
        }
        start += 50
    }

    func requestDetail(){
        let urlString = self.getDetailURL(type: .normal)
        zs_get(urlString, parameters: nil) { (response) in
            QSLog(response)
            if let reader = response?["review"] {
                if let detail = BookComment.deserialize(from: reader as? NSDictionary) {
                    self.output?.fetchDetailSuccess(detail: detail)
                }else{
                    self.output?.fetchDetailFailed()
                }
            }else{
                self.output?.fetchDetailFailed()
            }
        }
    }
    
    func getCommentURL(type:QSBookCommentType)->String{
        var urlString = ""
        switch type {
        case .normal:
            //        http://api.zhuishushenqi.com/post/review/530a26522852d5280e04c19c/comment?start=0&limit=50
            let api = ZSAPI.normalComment(key: model._id, start: "\(start)", limit: "\(limit)")
            urlString = api.path
            param = api.parameters
            break
        case .hotUser:
            //            http://api.zhuishushenqi.com/user/twitter/58d14859d0693ae736034619/comments
            let api = ZSAPI.hotUser(key: model._id)
            urlString = api.path
            param = nil
            break
        case .hotPost:
            //            http://api.zhuishushenqi.com/post/58d1d313bd7cc9961f93192d/comment?start=0&limit=50
            let api = ZSAPI.hotPost(key: model._id, start: "\(start)", limit: "\(limit)")
            urlString = api.path
            param = api.parameters
            break
        }
        return urlString
    }
    
    func getDetailURL(type:QSBookCommentType)->String{
        var urlString = ""
        switch type {
        case .normal:
            let api = ZSAPI.commentDetail(key: model._id)
            urlString = api.path
            break
        case .hotUser:
            urlString = "\(BASEURL)/user/twitter/\(model._id)"
            break
        case .hotPost:
            //            http://api.zhuishushenqi.com/post/58d1d313bd7cc9961f93192d/comment?start=0&limit=50
            urlString = "\(BASEURL)/post/\(model._id)"
            break
        }
        return urlString
    }

}
