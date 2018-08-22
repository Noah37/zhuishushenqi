//
//  ZSDiscussViewModel.swift
//  zhuishushenqi
//
//  Created by caony on 2018/8/21.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit
import RxSwift

class ZSDiscussViewModel: NSObject {
    
    internal var refreshStatus: Variable<ZSRefreshStatus> = Variable(.none)
    
    var webService = ZSDiscussWebService()
    
    var block:String = "girl"
    
    func fetchDiscuss(selectIndexs:[Int],completion:@escaping ZSBaseCallback<[BookComment]>){
        let url = getURLString(selectIndexs: selectIndexs)
        webService.fetchDiscuss(url: url) { (comments) in
            completion(comments)
        }
    }
    
    func getURLString(selectIndexs:[Int])->String{
        let durations = ["duration=all","duration=all&distillate=true"]
        let sort = ["sort=updated","sort=created","sort=comment-count"]
        let urlString = "\(BASEURL)/post/by-block?block=\(block)&\(durations[selectIndexs[0]])&\(sort[selectIndexs[1]])&start=0&limit=20"
        return urlString
    }
}
