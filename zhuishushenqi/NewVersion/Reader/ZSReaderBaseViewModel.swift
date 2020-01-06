//
//  ZSReaderBaseViewModel.swift
//  zhuishushenqi
//
//  Created by caony on 2019/9/20.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit

class ZSReaderBaseViewModel {
    

    var model:AikanParserModel?
    var originalChapter:ZSBookChapter?
    var preRequestChapterCount = 5
    
    var reader = ZSReader.share
    
    // 阅读历史
    var readHistory:ZSReadHistory?
    
    var chapters:[ZSBookChapter] {
        get {
            return model?.chaptersModel as? [ZSBookChapter] ?? []
        }
    }
    
    fileprivate var webService = ZSReaderWebService()
    
    init() {
        reader.didChangeContentFrame = { frame in
            
        }
        
        reader.theme.didChangeFontSize = { fontSize in
            
        }
    }

    func request(callback:ZSBaseCallback<Void>?) {
        if let chapter = originalChapter, chapter.chapterContent.length == 0 {
            ZSReaderDownloader.share.download(chapter: chapter, book: model?.bookName ?? "", reg: model?.content ?? "") { (chapter) in
                callback?(nil)
            }
            preRequest(chapter: chapter)
        } else if let chapters = model?.chaptersModel as? [ZSBookChapter], chapters.count > 0 {
            ZSReaderDownloader.share.download(chapter: chapters.first!, book: model?.bookName ?? "", reg: model?.content ?? "") { (chapter) in
                callback?(nil)
            }
            preRequest(chapter: chapters.first!)
        }
    }
    
    // 预加载章节, 前后章节各 preRequestChapterCount
    func preRequest(chapter:ZSBookChapter) {
        if let chapters = model?.chaptersModel as? [ZSBookChapter] {
            var index = 0
            for chapter in chapters {
                if index <= chapter.chapterIndex && index > chapter.chapterIndex - preRequestChapterCount {
                    self.request(chapter: chapter) { (chapter) in
                        
                    }
                } else if index > chapter.chapterIndex && index < chapter.chapterIndex + preRequestChapterCount {
                    self.request(chapter: chapter) { (chapter) in
                        
                    }
                }
                index += 1
            }
        }
    }
    
    func request(chapter:ZSBookChapter, callback:@escaping ZSBaseCallback<ZSBookChapter>) {
        ZSReaderDownloader.share.download(chapter: chapter, book: model?.bookName ?? "", reg: model?.content ?? "") { (chapter) in
            callback(chapter)
        }
    }
}
