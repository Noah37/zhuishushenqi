//
//  ZSDiscussViewModel.swift
//  zhuishushenqi
//
//  Created by caony on 2018/8/21.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit
import RxSwift
import MJRefresh

protocol ZSDiscussViewModelProtocol {
    
    var models:[AnyObject] { get set }
    var refreshStatus:Variable<ZSRefreshStatus>{ get }
    var start:Int { get set }
    var limit:Int { get set }
    var selectSectionIndexs:[Int] { get set }
    func updateSelectSectionIndexs(indexs:[Int]) 
    func fetchDiscuss(_ handler:ZSBaseCallback<Void>?)
    func fetchMoreDiscuss(_ handler:ZSBaseCallback<Void>?)
}

extension ZSDiscussViewModelProtocol {
    func autoSetRefreshHeaderStatus(header:MJRefreshHeader?,footer:MJRefreshFooter?) -> Disposable{
        return refreshStatus.asObservable().subscribe(onNext: { (status) in
            switch status {
            case .headerRefreshing:
                header?.beginRefreshing()
            case .headerRefreshEnd:
                header?.endRefreshing()
            case .footerRefreshing:
                footer?.beginRefreshing()
            case .footerRefreshEnd:
                footer?.endRefreshing()
            case .noMoreData:
                footer?.endRefreshingWithNoMoreData()
            default:
                break
            }
        })
    }
}

class ZSDiscussBaseViewModel: NSObject, ZSRefreshProtocol, ZSDiscussViewModelProtocol {
    
    var start: Int = 0
    
    var limit: Int = 20
    
    var selectSectionIndexs: [Int] = []
    
    var block:String = "girl"
    
    internal var refreshStatus: Variable<ZSRefreshStatus> = Variable(.none)
    
    var models: [AnyObject] = []
    
    var webService = ZSDiscussWebService()
    
    func updateSelectSectionIndexs(indexs: [Int]) {
        selectSectionIndexs = indexs
    }
    
    func fetchDiscuss(_ handler: ZSBaseCallback<Void>?) {
        start = 0
        let url = getURLString(selectIndexs: selectSectionIndexs)
        webService.fetchDiscuss(url: url) { (comments) in
            if let cModels = comments {
                self.models = cModels
            }
            self.refreshStatus.value = .headerRefreshEnd
            handler?(nil)
        }
    }
    
    func fetchMoreDiscuss(_ handler: ZSBaseCallback<Void>?) {
        start += 20
        let url = getURLString(selectIndexs: selectSectionIndexs)
        webService.fetchDiscuss(url: url) { (comments) in
            if let cModels = comments {
                self.models.append(contentsOf: cModels)
            }
            self.refreshStatus.value = .footerRefreshEnd
            handler?(nil)
        }
    }
    
    func getURLString(selectIndexs:[Int])->String{
        // local list
        //all ,默认排序
        //        http://api.zhuishushenqi.com/post/by-block?block=ramble&duration=all&sort=updated&start=0&limit=20
        
        // all,最新发布
        //        http://api.zhuishushenqi.com/post/by-block?block=ramble&duration=all&sort=created&start=0&limit=20
        
        // all,最多评论
        //        http://api.zhuishushenqi.com/post/by-block?block=ramble&duration=all&sort=comment-count&start=0&limit=20
        
        // 精品,默认
        //        http://api.zhuishushenqi.com/post/by-block?block=ramble&distillate=true&duration=all&sort=updated&start=0&limit=20
        
        // 精品,最新发布
        //        http://api.zhuishushenqi.com/post/by-block?block=ramble&distillate=true&duration=all&sort=created&start=0&limit=20
        
        // 精品,最多评论
        //        http://api.zhuishushenqi.com/post/by-block?block=ramble&distillate=true&duration=all&sort=comment-count&start=0&limit=20
        
        
        let durations = ["duration=all","duration=all&distillate=true"]
        let sort = ["sort=updated","sort=created","sort=comment-count"]
        let urlString = "\(BASEURL)/post/by-block?block=\(block)&\(durations[selectIndexs[0]])&\(sort[selectIndexs[1]])&start=\(start)&limit=\(limit)"
        return urlString
    }
}

class ZSDiscussViewModel: NSObject,ZSRefreshProtocol {
    
    internal var refreshStatus: Variable<ZSRefreshStatus> = Variable(.none)
    
    var webService = ZSDiscussWebService()
    
    var block:String = "girl"
    
    var models:[BookComment] = []
    
    var start = 0
    var limit = 20
    
    func fetchDiscuss(selectIndexs:[Int],completion:@escaping ZSBaseCallback<[BookComment]>){
        start = 0
        let url = getURLString(selectIndexs: selectIndexs)
        webService.fetchDiscuss(url: url) { (comments) in
            if let cModels = comments {
                self.models = cModels
            }
            self.refreshStatus.value = .headerRefreshEnd
            completion(comments)
        }
    }
    
    
    func fetchMore(selectIndexs:[Int],completion:@escaping ZSBaseCallback<[BookComment]>) {
        start += 20
        let url = getURLString(selectIndexs: selectIndexs)
        webService.fetchDiscuss(url: url) { (comments) in
            if let cModels = comments {
                self.models.append(contentsOf: cModels)
            }
            self.refreshStatus.value = .footerRefreshEnd
            completion(comments)
        }
    }
    
    func getURLString(selectIndexs:[Int])->String{
        // local list
        //all ,默认排序
        //        http://api.zhuishushenqi.com/post/by-block?block=ramble&duration=all&sort=updated&start=0&limit=20
        
        // all,最新发布
        //        http://api.zhuishushenqi.com/post/by-block?block=ramble&duration=all&sort=created&start=0&limit=20
        
        // all,最多评论
        //        http://api.zhuishushenqi.com/post/by-block?block=ramble&duration=all&sort=comment-count&start=0&limit=20
        
        // 精品,默认
        //        http://api.zhuishushenqi.com/post/by-block?block=ramble&distillate=true&duration=all&sort=updated&start=0&limit=20
        
        // 精品,最新发布
        //        http://api.zhuishushenqi.com/post/by-block?block=ramble&distillate=true&duration=all&sort=created&start=0&limit=20
        
        // 精品,最多评论
        //        http://api.zhuishushenqi.com/post/by-block?block=ramble&distillate=true&duration=all&sort=comment-count&start=0&limit=20
        
        
        let durations = ["duration=all","duration=all&distillate=true"]
        let sort = ["sort=updated","sort=created","sort=comment-count"]
        let urlString = "\(BASEURL)/post/by-block?block=\(block)&\(durations[selectIndexs[0]])&\(sort[selectIndexs[1]])&start=\(start)&limit=\(limit)"
        return urlString
    }
}
