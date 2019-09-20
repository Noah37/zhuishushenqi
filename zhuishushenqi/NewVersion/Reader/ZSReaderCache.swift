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
                
            })
        }
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
    
//    func fetchInitialChapter(_ callback:ZSSearchWebAnyCallback<QSPage>?){
//        if let record = book?.record {
//            fetchPreChapter(record: record, chapterOffset: 0)
//            if let chapter = record.chapterModel {
//                let chapterIndex = record.chapter
//                // 换源时有可能超出章节
//                if let chapters = book?.chaptersInfo {
//                    var linkIndex = chapterIndex
//                    if chapterIndex >= chapters.count {
//                        linkIndex = chapters.count - 1
//                    }
//                    guard let link = chapters[safe: linkIndex]?.link else { return }
//                    cachedChapter[link] = chapter
//                }
//            } else {
//                fetchNewChapter(chapterOffset: 0, record: record, chaptersInfo: book?.chaptersInfo) { (page) in
//                    callback?(page)
//                }
//            }
//        }
//    }
    
//    func fetchNewChapter(chapterOffset:Int,record:QSRecord,chaptersInfo:[ZSChapterInfo]?,callback:ZSSearchWebAnyCallback<QSPage>?){
//        let chapter = record.chapter + chapterOffset
//        if chapter >= 0 && chapter < (chaptersInfo?.count ?? 0) {
//            if let chapterInfo = chaptersInfo?[safe: chapter] {
//                let link = chapterInfo.link
//                // 内存缓存
//                if let model =  cachedChapter[link] {
//                    let page =  chapterOffset > 0 ? 0: model.pages.count - 1
//                    callback?(model.pages[safe: page])
//                } else {
//                    self.fetchChapter(key: link, { (body) in
//                        if let bodyInfo = body {
//                            if let network = self.cacheChapter(body: bodyInfo, index: chapter) {
//                                // 请求新章节成功后不一定是当前的章节
//                                callback?(network.pages.first)
//                            }
//                        }
//                    })
//                }
//            }
//        }
//    }
    
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
    
}
