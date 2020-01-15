//
//  ZSReaderBaseViewModel.swift
//  zhuishushenqi
//
//  Created by caony on 2019/9/20.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit

class ZSReaderBaseViewModel {
    

    var model:ZSAikanParserModel? { didSet { bookReload() }}
    
    // 设置首次进入时指定的章节，如从详情页的目录进入
    var originalChapter:ZSBookChapter?
    var preRequestChapterCount = 5
    
    var reader = ZSReader.share
    
    // 阅读历史
    var readHistory:ZSReadHistory?
    
    var chapters:[ZSBookChapter] {
        get {
            return model?.chaptersModel ?? []
        }
    }
    
    fileprivate var webService = ZSReaderWebService()
    
    init() {
        reader.didChangeContentFrame = { frame in
            
        }
        
        reader.theme.didChangeFontSize = { fontSize in
            
        }
    }
    
    func bookReload() {
        // 阅读历史记录保存
        guard let book = model else { return }
        if let history = ZSShelfManager.share.history(book.bookUrl) {
            readHistory = history
        }
    }
    
    func saveHistory() {
        guard let history = readHistory else { return }
        ZSShelfManager.share.addHistory(history)
    }

    func request(callback:ZSReaderBaseCallback<ZSBookChapter>?) {
        if let chapter = originalChapter, chapter.chapterContent.length == 0 || chapter.chapterContent == ZSBookChapter.defaultContent {
            ZSReaderDownloader.share.download(chapter: chapter, book: model!, reg: model?.content ?? "") { (chapter) in
                callback?(chapter)
            }
            preRequest(chapter: chapter)
        } else if let chapters = model?.chaptersModel, chapters.count > 0 {
            ZSReaderDownloader.share.download(chapter: chapters.first!, book: model!, reg: model?.content ?? "") { (chapter) in
                callback?(chapter)
            }
            preRequest(chapter: chapters.first!)
        }
    }
    
    // 预加载章节, 前后章节各 preRequestChapterCount
    func preRequest(chapter:ZSBookChapter) {
        let chapterIndex = chapter.chapterIndex
        var index = chapterIndex - preRequestChapterCount
        // 预下载前面
        while index < chapterIndex {
            if index > 0 && index < chapters.count {
                guard let book = model else { return }
                let cp = chapters[index]
                let exist = ZSBookCache.share.isContentExist(cp.chapterUrl, book: book.bookName)
                if !exist {
                    ZSReaderDownloader.share.download(chapter: cp, book: model!, reg: model?.content ?? "") { (chapter) in
                        
                    }
                }
            }
            index += 1
        }
        var behindIndex = chapterIndex + 1
        // 预下载后面
        while behindIndex <= chapterIndex + preRequestChapterCount {
            if behindIndex > 0 && behindIndex < chapters.count {
                guard let book = model else { return }
                let cp = chapters[behindIndex]
                let exist = ZSBookCache.share.isContentExist(cp.chapterUrl, book: book.bookName)
                if !exist {
                    ZSReaderDownloader.share.download(chapter: cp, book: model!, reg: model?.content ?? "") { (chapter) in
                        
                    }
                }
            }
            behindIndex += 1
        }
    }
    
    func request(chapter:ZSBookChapter, callback:@escaping ZSReaderBaseCallback<ZSBookChapter>) {
        // 是否存在缓存了
        guard let book = model else { return }
        let exist = ZSBookCache.share.isContentExist(chapter.chapterUrl, book: book.bookName)
        if exist {
            if let chapter = ZSBookCache.share.content(for: chapter.chapterUrl, book: book.bookName) {
                callback(chapter)
                self.preRequest(chapter: chapter)
                return
            }
        }
        ZSReaderDownloader.share.download(chapter: chapter, book: model!, reg: model?.content ?? "") { (cp) in
            callback(cp)
            self.preRequest(chapter: chapter)
        }
    }
}
