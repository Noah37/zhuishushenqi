//
//  QSRankPresenter.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/4/13.
//  Copyright © 2017年 QS. All rights reserved.
//

import Foundation

class QSRankPresenter: QSRankPresenterProtocol {
    weak var view: QSRankViewProtocol?
    var interactor: QSRankInteractorProtocol
    var router: QSRankWireframeProtocol
    
    var show:[Bool] = [false,false]
    var ranks:[[QSRankModel]] = []
    
    init(interface: QSRankViewProtocol, interactor: QSRankInteractorProtocol, router: QSRankWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad(){
        interactor.fetchRanks()
        view?.showActivityView()
    }
    
    func didClickOpenBtn(indexPath:IndexPath,show:[Bool]){
        self.show = show
        self.show[indexPath.section] = !self.show[indexPath.section]
        fetchWithShow(show: self.show)
    }
    
    func didSelectResultRow(indexPath: IndexPath) {
        if indexPath.row == (collapse(maleRank: self.ranks[indexPath.section]) - 1){
            show[indexPath.section] = !show[indexPath.section]
            fetchWithShow(show: self.show)
            return
        }
        router.presentDetails(ranks[indexPath.section][indexPath.row])
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

extension QSRankPresenter:QSRankInteractorOutputProtocol{
    func fetchRankSuccess(ranks:[[QSRankModel]]){
        self.ranks = ranks
        view?.showRanks(ranks: ranks)
        view?.hideActivityView()
    }
    
    func fetchRankFailed(){
        view?.hideActivityView()
        view?.showEmpty()
    }
    
    func fetchWithShow(show: [Bool]) {
        view?.show(show: show)
    }
}
