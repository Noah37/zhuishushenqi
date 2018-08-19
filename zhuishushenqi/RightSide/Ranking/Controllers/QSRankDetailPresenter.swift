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

class QSRankDetailPresenter: QSRankDetailPresenterProtocol {
    weak var view: QSRankDetailViewProtocol?
    var interactor: QSRankDetailInteractorProtocol
    var router: QSRankDetailWireframeProtocol
    
    var ranks:[[Book]] = []
    var selectedIndex = 0
    var rank:QSRankModel!
    
    init(interface: QSRankDetailViewProtocol, interactor: QSRankDetailInteractorProtocol, router: QSRankDetailWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad(novel:QSRankModel){
        self.rank = novel
        interactor.fetchRanks(novel: self.rank,index:selectedIndex)
        view?.showActivityView()
    }
    
    func didSelectSeg(index:Int){
        if index == selectedIndex {
            return
        }
        selectedIndex = index
        view?.showActivityView()
        view?.showEmpty()
        interactor.fetchRanks(novel: self.rank, index: selectedIndex)
    }
    
    func didSelectResultRow(indexPath: IndexPath) {
        router.presentDetails(ranks[selectedIndex][indexPath.row])
    }
}

extension QSRankDetailPresenter:QSRankDetailInteractorOutputProtocol{
    func fetchRankSuccess(ranks:[[Book]]){
        self.ranks = ranks
        view?.hideActivityView()
        view?.showRanks(ranks: ranks)
    }
    
    func fetchRankFailed(){
        view?.hideActivityView()
    }
}
