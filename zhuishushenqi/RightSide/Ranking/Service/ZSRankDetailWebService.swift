//
//  QSRankDetailInteractor.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/4/13.
//  Copyright © 2017年 QS. All rights reserved.
//

import Foundation
import HandyJSON
import ZSAPI

class ZSRankDetailWebService {
    func fetchRanking(rank:QSRankModel,index:Int,_ handler:ZSBaseCallback<[Book]>?){
        let api = ZSAPI.rankList(id: ID(novel: rank, index: index))
        zs_get(api.path) { (json) in
            if let ranking = json?["ranking"] as? [String:AnyObject] {
                if let books = ranking["books"] as? [Any] {
                    if let models  = [Book].deserialize(from: books) as? [Book] {
                        handler?(models)
                    }
                }
            }
        }
    }
    
    func ID( novel:QSRankModel,index:Int)->String{
        var idStr = ""
        switch index {
        case 0:
            idStr = novel._id
            break
        case 1:
            idStr = novel.monthRank
            break
        case 2:
            idStr = novel.totalRank
            break
        default:
            idStr = novel._id
            break
        }
        if idStr == "" {
            idStr = novel._id
        }
        return idStr
    }
}
