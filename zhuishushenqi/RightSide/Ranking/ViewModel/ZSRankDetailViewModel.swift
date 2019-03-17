//
//  QSRankDetailPresenter.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/4/13.
//  Copyright © 2017年 QS. All rights reserved.
//

import Foundation

class ZSRankDetailViewModel {
    
    var webService = ZSRankDetailWebService()
    
    func fetchRanking(rank:QSRankModel,index:Int,_ handler:ZSBaseCallback<[Book]>?){
        webService.fetchRanking(rank: rank, index: index, handler)
    }
}
