//
//  ZSDiscussWebService.swift
//  zhuishushenqi
//
//  Created by caony on 2018/8/21.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit

class ZSDiscussWebService: ZSBaseService {
    

    func fetchDiscuss(url:String,completion:@escaping ZSBaseCallback<[BookComment]>){
        zs_get(url) { (json) in
            if let posts = json?["posts"] as? [[String:Any]] {
                if let comments = [BookComment].deserialize(from: posts) as? [BookComment] {
                    completion(comments)
                }
            }
        }
    }
}
