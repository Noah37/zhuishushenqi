//
//  QSRankInteractor.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/4/13.
//  Copyright © 2017年 QS. All rights reserved.
//

import Foundation
import QSNetwork
import HandyJSON

class QSRankInteractor: QSRankInteractorProtocol {
    var output: QSRankInteractorOutputProtocol!
    
    var ranks:[[QSRankModel]] = []
    func fetchRanks(){
        let api = QSAPI.ranking()
        QSNetwork.request(api.path) { (response) in
            if let dict = response.json as? NSDictionary {
                if let male:[Any] = dict["male"] as? [Any] {
                    if let maleRank = [QSRankModel].deserialize(from: male) as? [QSRankModel] {
                        //添加别人家的榜单
                        let otherRank = self.rankModel(title: "别人家的榜单", image: "ranking_other")
                        var males = maleRank
                        males.insert(otherRank, at: self.collapse(maleRank: males))
                        self.ranks.append(males)
                    }
                }
                if let female:[Any] = dict["female"] as? [Any] {
                    if let femaleRank = [QSRankModel].deserialize(from: female) as? [QSRankModel] {
                        let otherRank = self.rankModel(title: "别人家的榜单", image: "ranking_other")
                        var males = femaleRank
                        males.insert(otherRank, at: self.collapse(maleRank: males))
                        self.ranks.append(males)
                    }
                }
                self.output.fetchRankSuccess(ranks: self.ranks)
            } else {
                self.output.fetchRankFailed()
            }
        }
    }
    
    func rankModel(title:String,image:String)->QSRankModel{
        let otherRank = QSRankModel()
        otherRank.title = title
        otherRank.image = image
        return otherRank
    }
    
    func collapse(maleRank:[QSRankModel]?)->Int{
        var collapseIndex = 0
        if let models = maleRank {
            for model in models {
                if model.collapse == 1 {
                    break
                }
                collapseIndex += 1
            }
        }
        return collapseIndex
    }
}
