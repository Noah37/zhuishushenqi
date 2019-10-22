//
//  ZSReaderCache.swift
//  zhuishushenqi
//
//  Created by caony on 2019/9/20.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit

class ZSReaderCache {
    
    fileprivate var webService = ZSReaderWebService()
    fileprivate var book:BookDetail!
    
    fileprivate var sourceIndex = 1
    
    fileprivate var cachedChapter:[String:QSChapter] = [:]

    static let shared = ZSReaderCache()
    private init() {
        
    }
    
    func request(book:BookDetail,_ callback:ZSBaseCallback<Void>?) {
        self.book = book
        // 1. 请求所有的章节信息
        fetchResources { [unowned self](resources) in
            guard let source = self.actualSource() else {
                return
            }
            // 2.请求当前源所有的章节
            self.fetchChapters(source: source, { [unowned self] (chapters) in
                self.book.chaptersInfo = chapters
                // 3. 请求第一章信息【如果有阅读记录，请求阅读记录的章节信息】
                guard let chapter = self.initialChapter(chapters: self.book.chaptersInfo) else {
                    return
                }
                // 如果缓存中已经存在，则取缓存
                if let _ = self.cachedChapter[chapter.link] {
                    callback?(nil)
                } else {
                    // 不存在缓存,开始下载
                    self.webService.fetchChapter(key: chapter.link, { (body) in
                        guard let chapterBody = body else { return }
                        self.storeChapter(body: chapterBody, index: self.initialChapterIndex(chapters: self.book.chaptersInfo))
                        callback?(nil)
                    })
                }
            })
        }
    }
    
    func load() ->QSPage {
        // 章节数与页数默认-1
        let page = QSPage()
        let chapterIndex = initialChapterIndex(chapters: self.book.chaptersInfo)
        if chapterIndex < (self.book.chaptersInfo?.count ?? 0){
            if let chapterInfo = self.book.chaptersInfo?[chapterIndex] {
                if let chapter = cachedChapter[chapterInfo.link] {
                    let pageIndex = initialPageIndex(chapters: self.book.chaptersInfo)
                    if pageIndex < chapter.pages.count {
                        return chapter.pages[pageIndex]
                    }
                }
            }
        }
        return page
    }
    
    private func fetch(chapter:ZSChapterInfo) {
        
        
    }
    
    private func initialChapter(chapters:[ZSChapterInfo]?) ->ZSChapterInfo? {
        if let record = book.record {
            if record.chapter < (chapters?.count ?? 0) {
                return chapters?[record.chapter]
            }
        }
        return chapters?.first
    }
    
    private func initialChapterIndex(chapters:[ZSChapterInfo]?) ->Int {
        if let record = book.record {
            if record.chapter < (chapters?.count ?? 0) {
                return record.chapter
            }
        }
        return 0
    }
    
    private func initialPageIndex(chapters:[ZSChapterInfo]?) ->Int {
        if let record = book.record {
            if record.chapter < (chapters?.count ?? 0) {
                return record.page
            }
        }
        return 0
    }
    
    private func fetchResources(_ callback:ZSBaseCallback<[ResourceModel]>?){
        let key = book._id
        webService.fetchAllResource(key: key) { (resources) in
            self.book.resources = resources
            callback?(resources)
        }
    }
    
    private func fetchChapters(source:ResourceModel, _ callback:ZSBaseCallback<[ZSChapterInfo]>?){
        webService.fetchAllChapters(key: source._id) { (chapters) in
            callback?(chapters)
        }
    }
    
    private func changeSource(index:Int) {
        if index < (self.book.resources?.count ?? 0) {
            self.book.record?.source = self.book.resources?[safe: index]
        }
    }
    
    private func actualSource() ->ResourceModel? {
        // 1. 如果阅读记录中存在source，则直接采用
        if let source = self.book.record?.source {
            return source
        }
        // 2. 不存在则采用已经请求的源【0默认为追书官方源，因此从1开始】
        let sourceCount = self.book.resources?.count ?? 0
        if sourceIndex < sourceCount {
            return self.book.resources?[safe: sourceIndex]
        }
        return nil
    }
    
    private func fetchSourceIndex() ->Int? {
        guard let source = self.book.record?.source else { return nil }
        guard let resources = self.book.resources else { return nil }
        var index = 0
        for model in resources {
            if model._id.isEqual(to: source._id) {
                break
            }
            index += 1
        }
        return index
    }
    
    // 将新获取的章节信息存入chapterDict中
    @discardableResult
    private func storeChapter(body:ZSChapterBody,index:Int)->QSChapter? {
        let chapterModel = self.book?.chaptersInfo?[safe: index]
        let qsChapter = QSChapter()
        if let link = chapterModel?.link {
            qsChapter.link = link
            // 如果使用追书正版书源，取的字段应该是cpContent，需要根据当前选择的源进行判断
            qsChapter.isVip = chapterModel?.isVip ?? false
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
