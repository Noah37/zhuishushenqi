//
//  QSRankDetailInteractor.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/4/13.
//  Copyright © 2017年 QS. All rights reserved.
//

import Foundation
import QSNetwork

class QSRankDetailInteractor: QSRankDetailInteractorProtocol {
    var output: QSRankDetailInteractorOutputProtocol!
    
    var ranks:[[Book]] = [[],[],[]]
    
    func fetchRanks(novel:QSRankModel,index:Int){
        if isExist(index: index) {
            self.output.fetchRankSuccess(ranks: self.ranks)
            return
        }
        let api = QSAPI.rankList(id: ID(novel: novel, index: index))
        QSNetwork.request(api.path, method: HTTPMethodType.get, parameters: nil, headers: nil) { (response) in
            QSLog(response.json)
            if let json = response.json {
                if let books = (json.object(forKey: "ranking") as AnyObject).object(forKey: "books") {
                    do{
                        let rank =  try XYCBaseModel.model(withModleClass: Book.self, withJsArray:books as! [AnyObject]) as? [Book]
                        self.ranks[index] = rank ?? []
                        self.output.fetchRankSuccess(ranks: self.ranks)
                    }catch{
                        self.output.fetchRankFailed()
                    }
                }
            }else{
                self.output.fetchRankFailed()
            }
        }
    }
    
    func isExist(index:Int)->Bool{
        if ranks[index].count > 0 {
            return true
        }
        return false
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
    
    func rankModel(title:String,image:String)->QSRankModel{
        let otherRank = QSRankModel()
        otherRank.title = title
        otherRank.image = image
        return otherRank
    }
}
