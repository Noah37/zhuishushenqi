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
    
    // 默认选择非追书的源
    fileprivate var sourceIndex = 2
    
    //MARK: - fetch network resource
    func fetchAllResource(_ callback:ZSBaseCallback<[ResourceModel]>?){
        let key = book?._id ?? ""
        webService.fetchAllResource(key: key) { (resources) in
            self.book?.resources = resources
            callback?(resources)
        }
    }
    
    func fetchAllChapters(_ callback:ZSBaseCallback<[ZSChapterInfo]>?){
        if sourceIndex < (self.book?.resources?.count ?? 0) {
            let key = self.book?.resources?[sourceIndex]._id ?? ""
            webService.fetchAllChapters(key: key) { (chapters) in
                self.book?.chaptersInfo = chapters
                callback?(chapters)
            }
        }
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
                    record.page = pageIndex
                    self.book?.record = record
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
                    record.page = pageIndex
                    self.book?.record = record
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
    
    func fetchInitialChapter(_ callback:ZSSearchWebAnyCallback<QSPage>?){
        if let record = book?.record {
            fetchNewChapter(chapterOffset: 0, record: record, chaptersInfo: book?.chaptersInfo) { (page) in
                callback?(page)
            }
        }
    }
    
    fileprivate func fetchNewChapter(chapterOffset:Int,record:QSRecord,chaptersInfo:[ZSChapterInfo]?,callback:ZSSearchWebAnyCallback<QSPage>?){
        let chapter = record.chapter + chapterOffset
        if chapter >= 0 && chapter < (chaptersInfo?.count ?? 0) {
            if let chapterInfo = chaptersInfo?[chapter] {
                let link = chapterInfo.link
                // 内存缓存
                if let model =  cachedChapter[link] {
                    record.chapter = chapter
                    record.page =  chapterOffset > 0 ? 0: model.pages.count - 1
                    record.chapterModel  = model
                    self.book?.record = record
                    callback?(model.pages[record.page])
                } else {
                    self.fetchChapter(key: link, { (body) in
                        if let bodyInfo = body {
                            if let network = self.cacheChapter(body: bodyInfo, index: chapter) {
                                record.chapterModel = network
                                record.chapter = chapter
                                record.page = 0
                                self.book?.record = record
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
            if chapterModel?.order == 1  {
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
