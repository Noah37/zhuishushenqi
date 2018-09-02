//
//  ZSBookCTViewModel.swift
//  zhuishushenqi
//
//  Created by caony on 2018/8/28.
//  Copyright © 2018年 QS. All rights reserved.
//

import Foundation
import RxSwift


class ZSBookCTViewModel:NSObject,ZSRefreshProtocol {
    
    var webService:ZSBookCTService = ZSBookCTService()
    
    var refreshStatus: Variable<ZSRefreshStatus> = Variable(.none)
    
    var model:BookComment?
    
    var detail:BookComment?
    
    var best:[BookCommentDetail]?
    
    var normal:[BookCommentDetail]?
    
    var start = 0
    var limit = 50
    
    func fetchCommentDetail(handler:@escaping ZSBaseCallback<BookComment>){
        webService.fetchCommentDetail(id: model?._id ?? "", type: .normal) { (comment) in
            self.detail = comment
            handler(comment)
        }
    }
    
    func fetchCommentBest(handler:@escaping ZSBaseCallback<[BookCommentDetail]>){
        webService.fetchCommentBest(id: model?._id ?? "") { (best) in
            self.best = best
            handler(best)
        }
        webService.fetchCommentBest(id: model?._id ?? "", handler: handler)
    }
    
    func  fetchNewNormal(handler:@escaping ZSBaseCallback<[BookCommentDetail]>) {
        start = 0
        webService.fetchNormalMore(id: model?._id ?? "", type: .normal, start: start, limit: limit) { (normals) in
            self.normal = normals
            self.refreshStatus.value = .headerRefreshEnd
            handler(normals)
        }
    }
    
    func fetchNormalMore(handler:@escaping ZSBaseCallback<[BookCommentDetail]>){
        start += 50
        webService.fetchNormalMore(id: model?._id ?? "", type: .normal, start: start, limit: limit) { (more) in
            self.refreshStatus.value = .footerRefreshEnd
            if let normals = more {
                if normals.count > 0 {
                    self.normal?.append(contentsOf: normals)
                    handler(normals)
                }
            }
        }
    }
    
    func linkURL(linkData:CoreTextLinkData)->Any? {
        let linkTo = linkData.linkTo
        if linkTo == "post" {
            let comment = BookComment()
            comment._id = linkData.key
            return comment
        } else if linkTo == "booklist" {
            return linkData.key
        }
        return nil
    }
}
