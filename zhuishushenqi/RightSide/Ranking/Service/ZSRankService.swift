//
//  ZSRankService.swift
//  zhuishushenqi
//
//  Created by yung on 2018/8/13.
//  Copyright © 2018年 QS. All rights reserved.
//

import Foundation
import ZSAPI

class ZSRankService {
    
    func fetchRanking(_ handler:ZSBaseCallback<[[QSRankModel]]>?){
        let api = ZSAPI.ranking("" as AnyObject)
        zs_get(api.path).responseJSON { (response) in
            if let data = response.data {
                if let obj = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any]  {
                    var ranking:[[QSRankModel]] = []
                    if let male = obj["male"] as? [Any] {
                        if let maleModels = [QSRankModel].deserialize(from: male) as? [QSRankModel] {
                            var males = maleModels
                            let otherRank = self.rankModel(title: "别人家的榜单", image: "ranking_other")
                            males.insert(otherRank, at: self.collapse(maleRank: males))
                            ranking.append(males)
                        }
                    }
                    if let female = obj["female"] as? [Any] {
                        if let femaleModels = [QSRankModel].deserialize(from: female) as? [QSRankModel] {
                            var females = femaleModels
                            let otherRank = self.rankModel(title: "别人家的榜单", image: "ranking_other")
                            females.insert(otherRank, at: self.collapse(maleRank: females))
                            ranking.append(females)
                        }
                    }
                    handler?(ranking)
                }
            }
        }
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
    
    
    fileprivate func rankModel(title:String,image:String)->QSRankModel{
        let otherRank = QSRankModel()
        otherRank.title = title
        otherRank.image = image
        return otherRank
    }
}
