//
//  QSTextPresenter.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/4/14.
//  Copyright © 2017年 QS. All rights reserved.
//

import Foundation

class QSTextPresenter: QSTextPresenterProtocol {
    weak var view: QSTextViewProtocol?
    var interactor: QSTextInteractorProtocol
    var router: QSTextWireframeProtocol
    
    var show:[Bool] = [false,false]
    var ranks:[[QSRankModel]] = []
    
    init(interface: QSTextViewProtocol, interactor: QSTextInteractorProtocol, router: QSTextWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad(bookDetail:BookDetail){
        if (bookDetail.chapters?.count ?? 0) == 0{
            interactor.requestAllResource(bookDetail:bookDetail)
        }else{
            interactor.commonInit(model: bookDetail)
        }
//        view?.showActivityView()
    }
    
    func didClickContent(){
        
    }
    
    func didClickChangeSource(){
        
    }
    
    func didClickCategory(){
        
    }
    
    func didClickBack(){
        
    }
    
    func requestChapter(index:Int){
        view?.showActivityView()
        interactor.requestChapter(atIndex: index)
    }
    
    func requestAllChapter(index:Int){
        view?.showActivityView()
        interactor.requestAllChapters(selectedIndex: index)
    }
}

extension QSTextPresenter:QSTextInteractorOutputProtocol{
    func fetchAllChaptersSuccess(chapters:[NSDictionary]){
        view?.hideActivityView()
        view?.showAllChapter(chapters: chapters)
    }
    
    func fetchAllChaptersFailed() {
        view?.hideActivityView()
        view?.showLocalChapter()
    }
    
    func showBook(book:QSBook){
        view?.showBook(book: book)
    }
    
    func fetchChapterSuccess(chapter:Dictionary<String, Any>,index:Int){
        view?.showChapter(chapter: chapter, index: index)
        view?.hideActivityView()
    }
    
    func fetchChapterFailed(){
        view?.hideActivityView()
        view?.showLocalChapter()
    }
    
    func fetchAllResourceSuccess(resource: [ResourceModel]) {
        view?.hideActivityView()
        view?.showResources(resources: resource)
    }
    
    func fetchAllResourceFailed() {
        view?.hideActivityView()
        view?.showLocalChapter()
    }
    
    func showActivity() {
        view?.showActivityView()
    }
}
