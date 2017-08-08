//
//  QSRankInteractor.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/4/13.
//  Copyright © 2017年 QS. All rights reserved.
//

import Foundation
import QSNetwork

class QSRankInteractor: QSRankInteractorProtocol {
    var output: QSRankInteractorOutputProtocol!
    
    var ranks:[[QSRankModel]] = []
    func fetchRanks(){
        let api = QSAPI.ranking()
        QSNetwork.request(api.path) { (response) in
            if let dict = response.json as? NSDictionary {
                do{
                    if let male:[Any] = dict["male"] as? [Any] {
                        var maleRank:[QSRankModel]? = try XYCBaseModel.model(withModleClass: QSRankModel.self, withJsArray: male) as? [QSRankModel]
                        //添加别人家的榜单
                        let otherRank = self.rankModel(title: "别人家的榜单", image: "ranking_other")
                        maleRank?.insert(otherRank, at: 5)
                        self.ranks.append(maleRank ?? [])
                    }
                    if let female:[Any] = dict["female"] as? [Any] {
                        var femaleRank:[QSRankModel]? = try XYCBaseModel.model(withModleClass: QSRankModel.self, withJsArray: female ) as? [QSRankModel]
                        let otherRank = self.rankModel(title: "别人家的榜单", image: "ranking_other")
                        femaleRank?.insert(otherRank, at: 5)
                        self.ranks.append(femaleRank ?? [])
                    }
                    self.output.fetchRankSuccess(ranks: self.ranks)
                }catch{
                    self.output.fetchRankFailed()
                }
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
}
