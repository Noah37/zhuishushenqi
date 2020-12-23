//
//  ZSReaderManager.swift
//  zhuishushenqi
//
//  Created by yung on 2018/7/9.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit

final class ZSReaderManager {
    
    var cachedChapter:[String:QSChapter] = [:]
    
    // 获取下一个页面
    func getNextPage(record:QSRecord,chaptersInfo:[ZSChapterInfo]?,callback:ZSSearchWebAnyCallback<QSPage>?){
        //2.获取当前阅读的章节与页码,这里由于是网络小说,有几种情况
        //(1).当前章节信息为空,那么这一章只有一页,翻页直接进入了下一页,章节加一
        //(2).当前章节信息不为空,说明已经请求成功了,那么计算当前页码是否为该章节的最后一页
        //这是2(2)
        if let chapterModel = record.chapterModel {
            let page = record.page
            if page < chapterModel.pages.count - 1 {
                let pageIndex = page + 1
                let pageModel = chapterModel.pages[pageIndex]
                callback?(pageModel)
            } else { // 新的章节
                getNewChapter(chapterOffset: 1,record: record,chaptersInfo: chaptersInfo,callback: callback)
            }
        } else {
            getNewChapter(chapterOffset: 1,record: record,chaptersInfo: chaptersInfo,callback: callback)
        }
    }
    
    func getLastPage(record:QSRecord,chaptersInfo:[ZSChapterInfo]?,callback:ZSSearchWebAnyCallback<QSPage>?){
        if let chapterModel = record.chapterModel {
            let page = record.page
            if page > 0 {
                // 当前页存在
                let pageIndex = page - 1
                let pageModel = chapterModel.pages[pageIndex]
                callback?(pageModel)
            } else {// 当前章节信息不存在,必然是新的章节
                getNewChapter(chapterOffset: -1,record: record,chaptersInfo: chaptersInfo,callback: callback)
            }
        } else {
            getNewChapter(chapterOffset: -1,record: record,chaptersInfo: chaptersInfo,callback: callback)
        }
    }
    
    func getNewChapter(chapterOffset:Int,record:QSRecord,chaptersInfo:[ZSChapterInfo]?,callback:ZSSearchWebAnyCallback<QSPage>?){
        let chapter = record.chapter + chapterOffset
        if chapter > 0 && chapter < (chaptersInfo?.count ?? 0) {
            if let chapterInfo = chaptersInfo?[chapter] {
                let link = chapterInfo.link
                // 内存缓存
                if let model =  cachedChapter[link] {
                    callback?(model.pages.first)
                } else {
                    callback?(nil)
//                    viewModel.fetchChapter(key: link, { (body) in
//                        if let bodyInfo = body {
//                            if let network = self.cacheChapter(body: bodyInfo, index: chapter) {
//                                callback?(network.pages.first)
//                            }
//                        }
//                    })
                }
            }
        }
    }
    
}
