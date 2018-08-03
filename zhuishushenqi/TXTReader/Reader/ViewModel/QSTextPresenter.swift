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
    var sourceIndex = 2
    
    //MARK: - fontChange
    func fontChange(action: ToolBarFontChangeAction,_ callback:ZSSearchWebAnyCallback<QSPage>?) {
        var size = QSReaderSetting.shared.fontSize
        if action == .plus {
            size += 1
        } else {
            size -= 1
        }
        if size > QSReaderFontSizeMax {
            QSLog("fontSize:\(size)\n 超出了限制")
            return
        }
        if size < QSReaderFontSizeMin {
            QSLog("fontSize:\(size)\n 超出了限制")
            return
        }
        QSReaderSetting.shared.fontSize = size
        //字体变小，页数变少
        if let record = book?.record {
            let chapterIndex = record.chapter
            let pageIndex = record.page
            if let link = book?.chaptersInfo?[chapterIndex].link {
                if let chapter = cachedChapter[link] {
                    chapter.getPages()
                    if pageIndex >= 0 && pageIndex < chapter.pages.count {
                        callback?(chapter.pages[pageIndex])
                    } else {
                        callback?(chapter.pages.last)
                    }
                }
            }
        }
    }
    
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
        } else {
            sourceIndex = (self.book?.resources?.count ?? 0) - 1
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
    
    fileprivate func fetchForwardPage(link:String,chapterIndex:Int,callback:ZSSearchWebAnyCallback<QSPage>?){
        // 内存缓存
        if let model =  cachedChapter[link] {
            callback?(model.pages.first)
        } else {
            fetchChapter(key: link, { (body) in
                if let bodyInfo = body {
                    if let network = self.cacheChapter(body: bodyInfo, index: chapterIndex) {
                        // 请求新章节成功后不一定是当前的章节
                        callback?(network.pages.first)
                    }
                }
            })
        }
    }
    
    // 此方法仅获取page,不改变record
    func fetchNextPage(indexPath:IndexPath,callback:ZSSearchWebAnyCallback<QSPage>?, networkCallback:ZSSearchWebAnyCallback<QSPage>?){
        if let chapters = book?.chaptersInfo?[indexPath.section] {
            // 从cachedChapter中获取model
            if let model = cachedChapter[chapters.link] {
                callback?(model.pages[indexPath.row])
            } else {
                // cachedChapter中不存在则网络请求,先返回一个空的
                callback?(nil)
                fetchNewChapter(indexPath: indexPath,callback: networkCallback)
            }
        } else {
            callback?(nil)
            fetchAllResource { (resources) in
                self.fetchAllChapters({ (chaptersInfo) in
                    self.fetchNewChapter(indexPath: indexPath,callback: networkCallback)
                })
            }
        }
    }
    
    // 此方法仅获取page,不改变record
    func fetchLastPage(indexPath:IndexPath,callback:ZSSearchWebAnyCallback<QSPage>?){
        if let chapters = book?.chaptersInfo?[indexPath.section] {
            // 从cachedChapter中获取model
            if let model = cachedChapter[chapters.link] {
                callback?(model.pages.first)
            } else {
                // cachedChapter中不存在则网络请求,先返回一个空的
                callback?(nil)
                fetchNewChapter(indexPath: indexPath,callback: callback)
            }
        } else {
            callback?(nil)
            fetchAllResource { (resources) in
                self.fetchAllChapters({ (chaptersInfo) in
                    self.fetchNewChapter(indexPath: indexPath,callback: callback)
                })
            }
        }
    }
    
    func updateLastRecord(callback:ZSSearchWebAnyCallback<QSPage>?) {
        if let record = book?.record {
            if let chapters = book?.chaptersInfo?[record.chapter] {
                // 从cachedChapter中获取model
                if let model = cachedChapter[chapters.link] {
                    let pageIndex = record.page
                    if pageIndex > 0 {
                        record.page -= 1
                        callback?(model.pages[record.page])
                    } else {// 新章节
                        record.page = 0
                        record.chapter -= 1
                        record.chapterModel = nil
                        if let link = book?.chaptersInfo?[record.chapter].link {
                            if let chapter = cachedChapter[link] {
                                record.page = chapter.pages.count - 1
                                record.chapterModel = chapter
                                callback?(chapter.pages[record.page])
                            }
                        }
                    }
                } else {
                    record.page = 0
                    record.chapter -= 1
                    record.chapterModel = nil
                    if let link = book?.chaptersInfo?[record.chapter].link {
                        if let chapter = cachedChapter[link] {
                            record.page = chapter.pages.count - 1
                            record.chapterModel = chapter
                            callback?(chapter.pages[record.page])
                        }
                    }
                }
            }
            book?.record = record
        }
    }
    
    // 先更新
    func updateNextRecord(callback:ZSSearchWebAnyCallback<QSPage>?) {
        // 向前章节,完成后从内存中获取当前章节,更新阅读记录中的model
        // 判断是否为新的章节
        if let record = book?.record {
            if let chapters = book?.chaptersInfo?[record.chapter] {
                // 从cachedChapter中获取model
                if let model = cachedChapter[chapters.link] {
                    let pageIndex = record.page
                    let totalPage = model.pages.count
                    if pageIndex < totalPage - 1 {
                        record.page += 1
                        callback?(model.pages[record.page])
                    } else { // 新章节
                        record.chapter += 1
                        record.page = 0
                        record.chapterModel = nil
                        if let link = book?.chaptersInfo?[record.chapter].link {
                            if let chapter = cachedChapter[link] {
                                record.chapterModel = chapter
                                callback?(chapter.pages[record.page])
                            }
                        }
                    }
                }else {
                    record.page = 0
                    record.chapter += 1
                    if let link = book?.chaptersInfo?[record.chapter].link {
                        if let chapter = cachedChapter[link] {
                            record.chapterModel = chapter
                            callback?(chapter.pages[record.page])
                        }
                    }
                }
            }
            book?.record = record
        }
    }
    
    // 获取下一个页面
    func fetchNextPage(callback:ZSSearchWebAnyCallback<QSPage>?){
        if exsitLocal() {
            fetchNextLocalPage(page: nil, callback)
        } else {
            if let record = book?.record {
                let chapterIndex = record.chapter
                if chapterIndex < (book?.chaptersInfo?.count ?? 0) {
                    if let link = book?.chaptersInfo?[chapterIndex].link {
                        if let chapterModel = cachedChapter[link] {
                            let page = record.page
                            if page < chapterModel.pages.count - 1 {
                                let tmpPage = page + 1
                                let tmpModel = chapterModel.pages[tmpPage]
                                callback?(tmpModel)
                            } else {
                                fetchNewChapter(chapterOffset: 1,record: record,chaptersInfo: self.book?.chaptersInfo,callback: callback)
                            }
                        } else {
                            fetchNewChapter(chapterOffset: 1,record: record,chaptersInfo: self.book?.chaptersInfo,callback: callback)
                            
                        }
                    }
                }
            }
        }
    }
    
    func fetchLastPage(callback:ZSSearchWebAnyCallback<QSPage>?){
        if exsitLocal() {
            fetchLastLocalPage(page:nil,callback)
        } else {
            if let record = book?.record {
                let chapterIndex = record.chapter
                if chapterIndex > 0 {
                    if let link = book?.chaptersInfo?[chapterIndex].link {
                        if let chapterModel = cachedChapter[link] {
                            let page = record.page
                            if page > 0 {
                                // 当前页存在
                                let pageIndex = page - 1
                                let pageModel = chapterModel.pages[pageIndex]
                                callback?(pageModel)
                            } else {// 当前章节信息不存在,必然是新的章节
                                fetchNewChapter(chapterOffset: -1,record: record,chaptersInfo: self.book?.chaptersInfo,callback:callback)
                            }
                        } else {
                            fetchNewChapter(chapterOffset: -1,record: record,chaptersInfo: self.book?.chaptersInfo,callback: callback)
                        }
                    }
                } else if chapterIndex == 0 { //等于0则判断
                    if let link = book?.chaptersInfo?[chapterIndex].link {
                        if let chapterModel = cachedChapter[link] {
                            let page = record.page
                            if page > 0 {
                                // 当前页存在
                                let pageIndex = page - 1
                                let pageModel = chapterModel.pages[pageIndex]
                                callback?(pageModel)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func existNextPage() -> Bool {
        if let record = book?.record {
            if let chapterModel = record.chapterModel {
                let chapter = record.chapter
                let page = record.page
                if chapter == ((book?.chaptersInfo?.count ?? 0) - 1) {
                    if page == chapterModel.pages.count - 1 {
                        return false
                    }
                }
            } else {
                let chapter = record.chapter
                if chapter == ((book?.chaptersInfo?.count ?? 1) - 1) {
                    return false
                }
            }
            return true
        }
        return false
    }
    
    func existLastPage() -> Bool {
        if let record = book?.record {
            if let _ = record.chapterModel {
                let chapter = record.chapter
                let page = record.page
                if chapter == 0 {
                    if page == 0 {
                        return false
                    }
                }
            } else {
                let chapter = record.chapter
                if chapter == 0 {
                    return false
                }
            }
            return true
        }
        return false
    }
    
    func fetchCurrentPage(_ callback:ZSSearchWebAnyCallback<QSPage>?){
        if let record = book?.record {
            let chapter = record.chapter
            if let link = book?.chaptersInfo?[chapter].link {
                fetchChapter(key: link) { (body) in
                    if let bodyInfo = body {
                        if let network = self.cacheChapter(body: bodyInfo, index: chapter) {
                            callback?(network.pages.first)
                        }
                    }
                }
            }
        }
    }
    
    func fetchInitialChapter(_ callback:ZSSearchWebAnyCallback<QSPage>?){
        if let record = book?.record {
            if let chapter = record.chapterModel {
                let chapterIndex = record.chapter
                if let link = book?.chaptersInfo?[chapterIndex].link {
                    cachedChapter[link] = chapter
                }
            } else {
                fetchNewChapter(chapterOffset: 0, record: record, chaptersInfo: book?.chaptersInfo) { (page) in
                    callback?(page)
                }
            }
        }
    }
    
    fileprivate func fetchNewChapter(indexPath:IndexPath,callback:ZSSearchWebAnyCallback<QSPage>?) {
        if let chapterInfo = self.book?.chaptersInfo?[indexPath.section] {
            let link = chapterInfo.link
            // 内存缓存
            self.fetchChapter(key: link, { (body) in
                if let bodyInfo = body {
                    if let network = self.cacheChapter(body: bodyInfo, index: indexPath.section) {
                        callback?(network.pages.first)
                    }
                }
            })
        }
    }
    
    func fetchNewChapter(chapterOffset:Int,record:QSRecord,chaptersInfo:[ZSChapterInfo]?,callback:ZSSearchWebAnyCallback<QSPage>?){
        let chapter = record.chapter + chapterOffset
        if chapter >= 0 && chapter < (chaptersInfo?.count ?? 0) {
            if let chapterInfo = chaptersInfo?[chapter] {
                let link = chapterInfo.link
                // 内存缓存
                if let model =  cachedChapter[link] {
                    let page =  chapterOffset > 0 ? 0: model.pages.count - 1
                    callback?(model.pages[page])
                } else {
                    self.fetchChapter(key: link, { (body) in
                        if let bodyInfo = body {
                            if let network = self.cacheChapter(body: bodyInfo, index: chapter) {
                                // 请求新章节成功后不一定是当前的章节
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
    func cacheChapter(body:ZSChapterBody,index:Int)->QSChapter? {
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

//MARK: - horMove
extension ZSReaderViewModel {
    
    // 这个方法包含本地与网络小说的判断
    func hm_existNext(page:QSPage?) ->Bool {
        if exsitLocal() {
            return existNextLocalPage()
        } else {
            if let tmpPage = page {
                let chapterIndex = tmpPage.curChapter
                let pageIndex = tmpPage.curPage
                let totalPages = tmpPage.totalPages
                if pageIndex == totalPages - 1 {
                    if let chaptersInfo = book?.chaptersInfo {
                        if chapterIndex == chaptersInfo.count - 1 {
                            return false
                        }
                    }
                }
            }
            return true
        }
    }
    
    func hm_existLast(page:QSPage?) ->Bool {
        if exsitLocal() {
            return existLastLocalPage()
        } else {
            if let tmpPage = page {
                let chapterIndex = tmpPage.curChapter
                let pageIndex = tmpPage.curPage
                if pageIndex == 0 {
                    if chapterIndex == 0 {
                        return false
                    }
                }
            }
            return true
        }
    }
    
    fileprivate func fetchBackwardPage(link:String,chapterIndex:Int,callback:ZSSearchWebAnyCallback<QSPage>?){
        // 内存缓存
        if let model =  cachedChapter[link] {
            callback?(model.pages.last)
        } else {
            fetchChapter(key: link, { (body) in
                if let bodyInfo = body {
                    if let network = self.cacheChapter(body: bodyInfo, index: chapterIndex) {
                        callback?(network.pages.last)
                        self.book?.record?.page = network.pages.count - 1
                    }
                }
            })
        }
    }
    
    func fetchBackwardPage(page:QSPage?,callback:ZSSearchWebAnyCallback<QSPage>?) {
        if exsitLocal() {
            fetchLastLocalPage(page:page,callback)
        } else {
            if let tmpPage = page {
                let chapterIndex = tmpPage.curChapter
                let pageIndex = tmpPage.curPage
                if pageIndex > 0 {
                    if let link = book?.chaptersInfo?[chapterIndex].link {
                        if let chapterModel = cachedChapter[link] {
                            callback?(chapterModel.pages[pageIndex - 1])
                        }
                    }
                } else if (pageIndex == 0) {
                    if let chapterInfo = book?.chaptersInfo?[chapterIndex - 1] {
                        let link = chapterInfo.link
                        if chapterIndex > 0 {
                            fetchBackwardPage(link: link, chapterIndex: chapterIndex - 1, callback: callback)
                        }
                    }
                }
            } else {
                if let chapter = book?.record?.chapter {
                    if chapter > 0  {
                        if let chapterInfo = book?.chaptersInfo?[chapter - 1] {
                            let link = chapterInfo.link
                            fetchBackwardPage(link: link, chapterIndex: chapter - 1, callback: callback)
                        }
                    }
                }
            }
        }
    }
    
    func fetchForwardPage(page:QSPage?,callback:ZSSearchWebAnyCallback<QSPage>?){
        if exsitLocal() {
            fetchNextLocalPage(page:page, callback)
        } else {
            if let tmpPage = page {
                // page 存在则根据page的值来获取下一章节
                let chapterIndex = tmpPage.curChapter
                let pageIndex = tmpPage.curPage
                let totalPages = tmpPage.totalPages
                if pageIndex < totalPages - 1 {
                    // 还在当前章节
                    if let link = book?.chaptersInfo?[chapterIndex].link {
                        if let chapterModel = cachedChapter[link] {
                            callback?(chapterModel.pages[pageIndex + 1])
                        }
                    }
                } else if pageIndex == totalPages - 1 {
                    // 新的章节
                    if chapterIndex  < (book?.chaptersInfo?.count ?? 0 - 1) {
                        if let chapterInfo = book?.chaptersInfo?[chapterIndex + 1] {
                            let link = chapterInfo.link
                            fetchForwardPage(link: link, chapterIndex: chapterIndex + 1, callback: callback)
                        }
                    }
                }
            } else {
                // page 不存在说明是新的章节,请求新的章节
                if let chapter = book?.record?.chapter {
                    if chapter >= 0 && chapter < (book?.chaptersInfo?.count ?? 0 - 1) {
                        if let chapterInfo = book?.chaptersInfo?[chapter + 1] {
                            let link = chapterInfo.link
                            fetchForwardPage(link: link, chapterIndex: chapter + 1, callback: callback)
                        }
                    }
                }
            }
        }
    }
    
    func updateBackwardRecord(page:QSPage?){
        if exsitLocal() {
            if let tmpPage = page {
                let pageIndex = tmpPage.curPage
                let chapterIndex = tmpPage.curChapter
                if let _ = book?.book.localChapters[chapterIndex] {
                    if pageIndex > 0 {
                        book?.record?.page = pageIndex - 1
                    } else if pageIndex == 0 {
                        if chapterIndex > 0 {
                            book?.record?.chapter = chapterIndex - 1
                            book?.record?.page = book!.book.localChapters[chapterIndex - 1].pages.count - 1
                        }
                    }
                }
            }
        } else {
            
            if let tmpPage = page {
                let pageIndex = tmpPage.curPage
                let chapterIndex = tmpPage.curChapter
                if let link = book?.chaptersInfo?[chapterIndex].link {
                    if let _ = cachedChapter[link] {
                        if pageIndex > 0 {
                            book?.record?.page = pageIndex - 1
                        } else if pageIndex == 0 {
                            book?.record?.chapter = chapterIndex - 1
                            book?.record?.page = 0
                            book?.record?.chapterModel = nil
                        }
                    } else {
                        book?.record?.chapter = chapterIndex - 1
                        book?.record?.page = 0
                        book?.record?.chapterModel = nil
                    }
                }
            } else {
                book?.record?.chapter -= 1
                book?.record?.page = 0
                book?.record?.chapterModel = nil
            }
        }
    }
    
    func updateForwardRecord(page:QSPage?){
        if exsitLocal() {
            if let tmpPage = page {
                let pageIndex = tmpPage.curPage
                let totalPages = tmpPage.totalPages
                let chapterIndex = tmpPage.curChapter
                if let chapterModel = book?.book.localChapters[chapterIndex] {
                    if pageIndex < totalPages - 1 {
                        book?.record?.page = pageIndex + 1
                    } else if pageIndex == totalPages - 1 {
                        if chapterIndex < book!.book.localChapters.count - 1 {
                            book?.record?.chapter = chapterIndex + 1
                            book?.record?.page = 0
                        }
                    }
                }
            }
        } else {
            if let tmpPage = page {
                let pageIndex = tmpPage.curPage
                let totalPages = tmpPage.totalPages
                let chapterIndex = tmpPage.curChapter
                if let link = book?.chaptersInfo?[chapterIndex].link {
                    if let _ = cachedChapter[link] {
                        if pageIndex < totalPages - 1 {
                            // 当前章节
                            book?.record?.page = pageIndex + 1
                        } else if pageIndex == totalPages - 1 {
                            book?.record?.chapter = chapterIndex + 1
                            book?.record?.page = 0
                            book?.record?.chapterModel = nil
                        }
                    } else {
                        book?.record?.chapter = chapterIndex + 1
                        book?.record?.page = 0
                        book?.record?.chapterModel = nil
                    }
                }
            } else {
                // page不存在,那么下一页依然是新的章节
                book?.record?.chapter += 1
                book?.record?.page = 0
                book?.record?.chapterModel = nil
            }
        }
    }
}

//MARK: - local book
extension ZSReaderViewModel {
    
    func exsitLocal()->Bool{
        if let chapters = book?.book.localChapters {
            if chapters.count > 0 {
                return true
            }
        }
        return false
    }
    
    func existNextLocalPage() -> Bool{
        if exsitLocal() {
            if let chapters = book?.book.localChapters {
                if let record = book?.record {
                    let pageIndex = record.page
                    let chapterIndex = record.chapter
                    if chapterIndex == chapters.count - 1 {
                        // 最后一章
                        if pageIndex == chapters[chapterIndex].pages.count - 1 {
                            return false
                        }
                    }
                }
            } else {
                return false
            }
        }
        return true
    }
    
    func existLastLocalPage() -> Bool {
        if exsitLocal() {
            if let chapters = book?.book.localChapters {
                if let record = book?.record {
                    let pageIndex = record.page
                    let chapterIndex = record.chapter
                    if chapterIndex == 0 {
                        if pageIndex == 0 {
                            return false
                        }
                    }
                }
            } else {
                return false
            }
        }
        return true
    }
    
    func fetchLocalPage(_ callback:ZSBaseCallback<QSPage>?){
        if let chapters = book?.book.localChapters {
            if let record = book?.record {
                let pageIndex = record.page
                let chapterIndex = record.chapter
                if chapterIndex < chapters.count {
                    if pageIndex < chapters[chapterIndex].pages.count {
                        callback?(chapters[chapterIndex].pages[pageIndex])
                    }
                }
            }
        } else {
            callback?(nil)
        }
    }
    
    func fetchNextLocalPage(page:QSPage?,_ callback:ZSBaseCallback<QSPage>?){
        if let chapters = book?.book.localChapters {
            
            let pageIndex = page?.curPage ?? 0
            let chapterIndex = page?.curChapter ?? 0
            if chapterIndex < chapters.count - 1 {
                if pageIndex < chapters[chapterIndex].pages.count - 1 {
                    callback?(chapters[chapterIndex].pages[pageIndex + 1])
                } else {
                    callback?(chapters[chapterIndex + 1].pages.first)
                }
            } else if chapterIndex == chapters.count - 1 {
                if pageIndex < chapters[chapterIndex].pages.count - 1 {
                    callback?(chapters[chapterIndex].pages[pageIndex + 1])
                } else {
                    callback?(nil)
                }
            }
        } else {
            callback?(nil)
        }
    }
    
    func fetchLastLocalPage(page:QSPage?,_ callback:ZSBaseCallback<QSPage>?){
        if let chapters = book?.book.localChapters {
            
            let pageIndex = page?.curPage ?? 0
            let chapterIndex = page?.curChapter ?? 0
            if chapterIndex > 0 && chapterIndex < chapters.count {
                if pageIndex > 0 {
                    callback?(chapters[chapterIndex].pages[pageIndex - 1])
                } else {
                    callback?(chapters[chapterIndex - 1].pages.last)
                }
            } else if chapterIndex == 0 {
                if pageIndex > 0 {
                    callback?(chapters[chapterIndex].pages[pageIndex - 1])
                } else {
                    callback?(nil)
                }
            }
            
        } else {
            callback?(nil)
        }
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
