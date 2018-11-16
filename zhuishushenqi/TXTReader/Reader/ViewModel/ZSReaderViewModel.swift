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
    
    var boughtInfo:ZSBoughtInfo?
    
    var cachedChapter:[String:QSChapter] = [:]
    
    /// 默认缓存前后的章节数
    var preCacheCount = 2
    
    fileprivate var webService = ZSReaderWebService()
    
    // 默认选择非追书的源,选择的源根据record中的记录
    var sourceIndex = 2
    
    init() {
        
    }
    
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
       
        if let record = book?.record {
            let chapterIndex = record.chapter > 0 ? record.chapter:0
            let pageIndex = record.page > 0 ? record.page:0
            if let link = book?.chaptersInfo?[chapterIndex].link {
                if let chapter = cachedChapter[link] {
                    // 如果缓存的章节量较大,为了防止影响用户体验,当前章节处理后直接返回,其他章节继续处理
                    chapter.getPages()
                    if pageIndex >= 0 && pageIndex < chapter.pages.count {
                        callback?(chapter.pages[pageIndex])
                    } else {
                        callback?(chapter.pages.last)
                    }
                }
            }
        }
        //字体变小，页数变少,这里应该对所有的已缓存章节变更
        for (_, chapter) in cachedChapter {
            chapter.getPages()
        }
    }
    
    //MARK: - boughtINfo
    func boughtInfo( token:String, _ callback:ZSBaseCallback<ZSBoughtInfo>?) {
        let api = QSAPI.boughtChapters(id: book?._id ?? "", token: token)
        zs_get(api.path, parameters: api.parameters) { (json) in
            if let info = ZSBoughtInfo.deserialize(from: json) {
                self.boughtInfo = info
                callback?(info)
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
    
    func fetchSourceIndex() ->Int? {
        if let source = self.book?.record?.source {
            if let resources = self.book?.resources {
                var index = 0
                for model in resources {
                    if model._id == source._id {
                        break
                    }
                    index += 1
                }
                return index
            }
        }
        return nil
    }
    
    func changeSource(index:Int) {
        if index < (self.book?.resources?.count ?? 0) {
            self.book?.record?.source = self.book?.resources?[index]
        }
    }
    
    func fetchAllChapters(_ callback:ZSBaseCallback<[ZSChapterInfo]>?){
        if let index = fetchSourceIndex() {
            let key = self.book?.resources?[index]._id ?? ""
            webService.fetchAllChapters(key: key) { (chapters) in
                self.book?.chaptersInfo = chapters
                callback?(chapters)
            }
        } else {
            
            if sourceIndex < (self.book?.resources?.count ?? 0) {
                changeSource(index: sourceIndex)
                let key = self.book?.resources?[sourceIndex]._id ?? ""
                webService.fetchAllChapters(key: key) { (chapters) in
                    self.book?.chaptersInfo = chapters
                    callback?(chapters)
                }
            } else {
                sourceIndex = (self.book?.resources?.count ?? 0) - 1
                changeSource(index: sourceIndex)
                let key = self.book?.resources?[sourceIndex]._id ?? ""
                webService.fetchAllChapters(key: key) { (chapters) in
                    self.book?.chaptersInfo = chapters
                    callback?(chapters)
                }
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
                        if record.chapter >= 0 {
                            if let link = book?.chaptersInfo?[record.chapter].link {
                                if let chapter = cachedChapter[link] {
                                    record.page = chapter.pages.count - 1
                                    record.chapterModel = chapter
                                    callback?(chapter.pages[record.page])
                                }
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
                        record.chapterModel = model
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
            } else if let localChapters = self.book?.book.localChapters {
                let chapterModel = localChapters[record.chapter]
                let pageIndex = record.page
                if pageIndex < (chapterModel.pages.count - 1) {
                    record.page += 1
                    record.chapterModel = chapterModel
                    callback?(chapterModel.pages[record.page])
                } else {
                    record.page = 0
                    record.chapter += 1
                    record.chapterModel = nil
                    if record.chapter < localChapters.count {
                        record.chapterModel = localChapters[record.chapter]
                        callback?(localChapters[record.chapter].pages[record.page])
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
                                fetchPreChapter(record: record, chapterOffset: 1)

                            }
                        } else {
                            fetchNewChapter(chapterOffset: 1,record: record,chaptersInfo: self.book?.chaptersInfo,callback: callback)
                            fetchPreChapter(record: record, chapterOffset: 1)
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
                                fetchPreChapter(record: record, chapterOffset: -1)
                            }
                        } else {

                            fetchNewChapter(chapterOffset: -1,record: record,chaptersInfo: self.book?.chaptersInfo,callback: callback)
                            fetchPreChapter(record: record, chapterOffset: -1)
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
                if let chaptersCount = book?.chaptersInfo?.count {
                    // 如果是最后一章,要考虑是否为最后一页,一般第一次进入不存在chapterModel,网络请求成功后默认展示第一章
                    if chapter == chaptersCount - 1 {
                        if let chapterLink = book?.chaptersInfo?[chapter].link {
                            let chapterModel = cachedChapter[chapterLink]
                            if chapterModel?.pages.count == 1 || record.page == ((chapterModel?.pages.count ?? 1) - 1) {
                                return false
                            }
                        }
                    }
                } else if let chapterCount = book?.book.localChapters.count {
                    if chapter >= chapterCount {
                        return false
                    }
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
                let page = record.page
                if chapter == 0 {
                    if page == 0 {
                        return false
                    }
                }
            }
            return true
        } 
        return false
    }
    
    func fetchCurrentPage(_ callback:ZSSearchWebAnyCallback<QSPage>?){
        if let record = book?.record {
            fetchPreChapter(record: record, chapterOffset: 0)
            var chapter = record.chapter
            // 如果当前章节超出限制,取最大值
            if chapter > (book?.chaptersInfo?.count ?? 0) {
                chapter = book?.chaptersInfo?.count ?? 0
            }
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
            fetchPreChapter(record: record, chapterOffset: 0)
            if let chapter = record.chapterModel {
                let chapterIndex = record.chapter
                // 换源时有可能超出章节
                if let chapters = book?.chaptersInfo {
                    if chapterIndex < chapters.count {
                        let link = chapters[chapterIndex].link
                        cachedChapter[link] = chapter
                    } else {
                        let link = chapters[chapters.count - 1].link
                        cachedChapter[link] = chapter
                    }
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
    
    /// 默认请求该章节的前后X章内容
    func fetchPreChapter(record:QSRecord, chapterOffset:Int) {
        if chapterOffset <= 0 {
            /// 请求当前章节的前X章节
            for index in (-preCacheCount + chapterOffset)..<0 {
                fetchNewChapter(chapterOffset: index, record: record, chaptersInfo: book?.chaptersInfo) { (page) in
                    // 缓存
                }
            }
        }
        if chapterOffset >= 0 {
            /// 请求当前章节的后X章节
            for index in 1..<(preCacheCount + 1 + chapterOffset) {
                fetchNewChapter(chapterOffset: index, record: record, chaptersInfo: book?.chaptersInfo) { (page) in
                    // 缓存
                }
            }
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
            qsChapter.isVip = chapterModel?.isVip ?? 0
            qsChapter.order = chapterModel?.order ?? 0
            qsChapter.currency = chapterModel?.currency ?? 0
            qsChapter.cpContent = body.cpContent
            qsChapter.id = body.id
            qsChapter.content = body.body
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
        if (book?.book.localChapters.count ?? 0) > 0 {
            let localChapters = book?.book.localChapters ?? []
            if let record = book?.record {
                let pageIndex = record.page
                let chapterIndex = record.chapter
                if chapterIndex < localChapters.count {
                    if pageIndex < localChapters[chapterIndex].pages.count {
                        callback?(localChapters[chapterIndex].pages[pageIndex])
                    }
                }
            }
        } else {
            
            callback?(nil)
        }
    }
    
    func fetchNextLocalPage(page:QSPage?,_ callback:ZSBaseCallback<QSPage>?){
        if let chapters = book?.book.localChapters {
            
            let pageIndex = book?.record?.page ?? 0
            let chapterIndex = book?.record?.chapter ?? 0
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
            
            let pageIndex = book?.record?.page ?? 0
            let chapterIndex = book?.record?.chapter ?? 0
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
