//
//  QSRankPresenter.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/4/13.
//  Copyright © 2017年 QS. All rights reserved.
//

import Foundation

class ZSRankViewModel {
    
    var ranks:[[QSRankModel]] = []
    var showRanks:[[QSRankModel]] = []
    var showMaleRank:Bool = false
    var showFemaleRank:Bool = false
    fileprivate var webService:ZSRankService = ZSRankService()
    
    init() {
        fetchRanking { (_) in
            
            self.showRanks = self.ranks
            self.clickSection(index: 0, nil)
            self.clickSection(index: 1, nil)
        }
    }
    
    func fetchRanking(_ handler:ZSBaseCallback<Void>?) {
        webService.fetchRanking { (ranking) in
            if let realRanking = ranking {
                self.ranks = realRanking
            }
            handler?(nil)
        }
    }
    
    func clickRow(indexPath:IndexPath,_ handler:ZSBaseCallback<[QSRankModel]>?) {
        let collapseIndex = webService.collapse(maleRank: ranks[indexPath.section])
        if indexPath.row == collapseIndex - 1 {
            if indexPath.section == 0 {
                showMaleRank = !showMaleRank
            } else {
                showFemaleRank = !showFemaleRank
            }
            clickSection(index: indexPath.section,handler)
        } else {
            handler?(nil)
        }
    }
    
    func clickSection(index:Int,_ handler:ZSBaseCallback<[QSRankModel]>?) {
        if showMaleRank {
            showRanks[index] = ranks[index]
            handler?(showRanks[index])
        } else {
            let collapseIndex = webService.collapse(maleRank: ranks[index])
            subRanking(index: index, collapseIndex: collapseIndex) { (models) in
                self.showRanks[index] = models ?? []
                handler?(self.showRanks[index])
            }
        }
    }
    
    func subRanking(index:Int,collapseIndex:Int,_ handler:ZSBaseCallback<[QSRankModel]>?) {
        var sub:[QSRankModel] = []
        for i in 0..<ranks[index].count {
            let model = ranks[index][i]
            if i < collapseIndex {
                sub.append(model)
            }
        }
        handler?(sub)
    }
}
