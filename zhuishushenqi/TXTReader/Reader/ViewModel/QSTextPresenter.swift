//
//  QSTextPresenter.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/4/14.
//  Copyright © 2017年 QS. All rights reserved.
//

import Foundation

class ZSReaderViewModel {
    
    var book:BookDetail?
    
    var cachedChapter:[String:QSChapter] = [:]
        
    fileprivate var webService = ZSReaderWebService()
    
    //MARK: - fetch network resource
    func fetchAllResource(key:String,_ callback:ZSBaseCallback<[ResourceModel]>?){
        webService.fetchAllResource(key: key, callback)
    }
    
    func fetchAllChapters(key:String,_ callback:ZSBaseCallback<[ZSChapterInfo]>?){
        webService.fetchAllChapters(key: key, callback)
    }
    
    func fetchChapter(key:String,_ callback:ZSBaseCallback<ZSChapterBody>?){
        webService.fetchChapter(key: key, callback)
    }
    
    // 获取下一个页面
    func fetchNextPage(callback:ZSSearchWebAnyCallback<QSPage>?){
        //2.获取当前阅读的章节与页码,这里由于是网络小说,有几种情况
        //(1).当前章节信息为空,那么这一章只有一页,翻页直接进入了下一页,章节加一
        //(2).当前章节信息不为空,说明已经请求成功了,那么计算当前页码是否为该章节的最后一页
        //这是2(2)
        if let record = book?.record {
            if let chapterModel = record.chapterModel {
                let page = record.page
                if page < chapterModel.pages.count - 1 {
                    let pageIndex = page + 1
                    let pageModel = chapterModel.pages[pageIndex]
                    callback?(pageModel)
                } else { // 新的章节
                    fetchNewChapter(chapterOffset: 1,record: record,chaptersInfo: self.book?.chaptersInfo,callback: callback)
                }
            } else {
                fetchNewChapter(chapterOffset: 1,record: record,chaptersInfo: self.book?.chaptersInfo,callback: callback)
            }
        }
    }
    
    func fetchLastPage(callback:ZSSearchWebAnyCallback<QSPage>?){
        if let record = book?.record {
            if let chapterModel = record.chapterModel {
                let page = record.page
                if page > 0 {
                    // 当前页存在
                    let pageIndex = page - 1
                    let pageModel = chapterModel.pages[pageIndex]
                    callback?(pageModel)
                } else {// 当前章节信息不存在,必然是新的章节
                    fetchNewChapter(chapterOffset: -1,record: record,chaptersInfo: self.book?.chaptersInfo,callback: callback)
                }
            } else {
                fetchNewChapter(chapterOffset: -1,record: record,chaptersInfo: self.book?.chaptersInfo,callback: callback)
            }
        }
    }
    
    fileprivate func fetchNewChapter(chapterOffset:Int,record:QSRecord,chaptersInfo:[ZSChapterInfo]?,callback:ZSSearchWebAnyCallback<QSPage>?){
        let chapter = record.chapter + chapterOffset
        if chapter > 0 && chapter < (chaptersInfo?.count ?? 0) {
            if let chapterInfo = chaptersInfo?[chapter] {
                let link = chapterInfo.link
                // 内存缓存
                if let model =  cachedChapter[link] {
                    callback?(model.pages.first)
                } else {
                    self.fetchChapter(key: link, { (body) in
                        if let bodyInfo = body {
                            if let network = self.cacheChapter(body: bodyInfo, index: chapter) {
                                callback?(network.pages.first)
                            }
                        }
                    })
                }
            }
        }
    }
        
    // 将新获取的章节信息存入chapterDict中
    @discardableResult
    fileprivate func cacheChapter(body:ZSChapterBody,index:Int)->QSChapter?{
        let chapterModel = self.book?.chaptersInfo?[index]
        let qsChapter = QSChapter()
        if let link = chapterModel?.link {
            qsChapter.link = link
            // 如果使用追书正版书源，取的字段应该是cpContent，需要根据当前选择的源进行判断
            if let _ = chapterModel?.order  {
                qsChapter.content = body.cpContent
                
            } else {
                qsChapter.content = body.body
            }
            if let title = chapterModel?.title {
                qsChapter.title = title
            }
            qsChapter.curChapter = index
            qsChapter.getPages() // 直接计算page
            cachedChapter[link] = qsChapter
            return qsChapter
        }
        return nil
    }
}

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
        if (bookDetail.chapters?.count ?? 0) == 0 || bookDetail.isUpdated{
            view?.showActivityView()
            interactor.requestAllResource(bookDetail:bookDetail)
        }else{
            interactor.commonInit(model: bookDetail)
        }
    }
    
    func didClickContent(){
        
    }
    
    func didClickChangeSource(){
        
    }

    func didClickCache(){
        interactor.cacheAllChapter()
    }
    
    func didClickCategory(book:BookDetail,books:[String:Any]){
        
        router.presentCategory(book: book,books:books)
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
    }
    
    func fetchAllResourceSuccess(resource: [ResourceModel]) {
        view?.hideActivityView()
        view?.showResources(resources: resource)
    }
    
    func fetchAllResourceFailed() {
        view?.hideActivityView()
    }
    
    func showActivity() {
        view?.showActivityView()
    }
    
    func downloadFinish(book: QSBook) {
        view?.downloadFinish(book: book)
    }
    
    func showProgress(dict: [String : Any]) {
        view?.showProgress(dict: dict)
    }
}
