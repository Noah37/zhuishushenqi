//
//  QSTextInteractor.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/4/14.
//  Copyright © 2017年 QS. All rights reserved.
//

import Foundation
import QSNetwork

class QSTextInteractor: QSTextInteractorProtocol {
    var output: QSTextInteractorOutputProtocol!
    
    var book:QSBook?
    var resources:[ResourceModel]?
    var chapters:[NSDictionary]?
    var bookDetail:BookDetail!
    var selectedIndex:Int = 1 //当前选择的源
    var queue:OperationQueue?
    var semaphore:DispatchSemaphore!
    var now:Int = 0
    var total = 0

    
    func commonInit(model:BookDetail){
        self.bookDetail = model
        self.resources  = self.bookDetail.resources
        self.chapters = self.bookDetail.chapters
        self.selectedIndex = self.bookDetail.sourceIndex
        if let book = model.book {
            self.book = book
        }else{
            self.book = book(bookDetail: self.bookDetail, chapters: self.chapters, resources: self.resources)
        }
        
        if let book = self.book {
            self.output.showBook(book: book)
        }
    }
    
    func requestAllResource(bookDetail:BookDetail){
        self.bookDetail = bookDetail
        //先查询书籍来源，根据来源返回的id再查询所有章节
        let api = QSAPI.allResource(key: bookDetail._id)
        QSNetwork.request(api.path, method: HTTPMethodType.get, parameters: api.parameters, headers: nil) { (response) in
            if let resource = response.json {
                do{
                    var resources:[ResourceModel]?
                    resources = try XYCBaseModel.model(withModleClass: ResourceModel.self, withJsArray: resource as! [Any]) as? [ResourceModel]
                    if let res = resources {
                        self.resources = res
                    }
                    if let resourcessss = self.resources {
                        self.output.fetchAllResourceSuccess(resource: resourcessss)
                    }else{
                        self.output.fetchAllResourceFailed()
                    }
                }catch{
                    QSLog(error)
                    self.output.fetchAllResourceFailed()
                }
            }else{
                self.output.fetchAllResourceFailed()
            }
        }
    }
    //网络请求所有的章节信息
    func requestAllChapters(selectedIndex:Int){
        self.selectedIndex = selectedIndex
        //两种情况,1.resources为空，说明第一次打开，直接通过book.id来请求
        //       2.resource不为空，按照resources来请求
        var api = QSAPI.allChapters(key: bookDetail._id)
        var url:String = api.path
        if let res = self.resources {
            if res.count > self.selectedIndex {
                api = QSAPI.allChapters(key: self.resources?[self.selectedIndex]._id ?? "")
                url = api.path
            }
        }
        QSNetwork.request(url, method: HTTPMethodType.get, parameters: api.parameters, headers: nil) { (response) in
            QSLog("JSON:\(String(describing: response.json))")
            if let chapters = response.json?["chapters"] as? [NSDictionary] {
                QSLog("Chapters:\(chapters)")
                self.chapters = chapters
                self.output.fetchAllChaptersSuccess(chapters: chapters)
            }else{
                self.output.fetchAllChaptersFailed()
            }
            
        }
    }
    
    //网络请求某一章节的信息
    func requestChapter(atIndex chapterIndex:Int){
        if chapterIndex >= (self.chapters?.count ?? 0) {
            self.output.fetchChapterFailed()
            return;
        }
        var link:NSString = "\(chapters?[chapterIndex].object(forKey: "link") ?? "")" as NSString
        link = link.urlEncode() as NSString
        let api = QSAPI.chapter(key: link as String, type: .chapter)
        QSNetwork.request(api.path) { (response) in
            if let json = response.json as? Dictionary<String, Any> {
                QSLog("JSON:\(json)")
                if let chapter = json["chapter"] as?  Dictionary<String, Any> {
                    self.output.fetchChapterSuccess(chapter: chapter,index:chapterIndex)
                } else {
                    self.output.fetchChapterFailed()
                }
            }else{
                self.output.fetchChapterFailed()
            }
        }
    }
    
    //获取新的页面信息
    func getChapter(chapterIndex:Int,pageIndex:Int) -> QSChapter?{
        var chapter:QSChapter?
        if (self.book?.chapters?.count ?? 0) > chapterIndex {
            let chaModel = self.book?.chapters?[chapterIndex]
            if chaModel?.content != "" {
                chapter = chaModel
                return chapter
            }
        }
        self.output.showActivity()
        requestChapter(atIndex: chapterIndex)
        return chapter
    }
    
    func book(bookDetail:BookDetail?,chapters:[NSDictionary]?,resources:[ResourceModel]?)->QSBook{//更换书籍来源则需要更新book.chapters信息,请求某一章节成功后也需要刷新chapters的content及其他信息
        self.chapters = chapters
        self.resources = resources
        let size:Int = getFontSize()
        let book:QSBook = QSBook()
        book.bookName = bookDetail?.title ?? ""
        book.bookID = bookDetail?._id ?? ""
        book.totalChapters = self.chapters?.count ?? 0
        book.resources = self.resources
        book.attribute = [NSFontAttributeName:UIFont.systemFont(ofSize: CGFloat(size))]
        book.curRes = 1
        var chapters:[QSChapter] = []
        for item in 0..<(self.chapters?.count ?? 0) {
            let chapter = self.chapters?[item]
            let chapterInfo = QSChapter()
            chapterInfo.link = chapter?["link"] as? String ?? ""
            chapterInfo.title = chapter?["title"] as? String ?? ""
            chapterInfo.id = chapter?["id"] as? String ?? ""
            chapterInfo.curChapter = item
            chapterInfo.attribute = book.attribute
            chapters.append(chapterInfo)
        }
        book.chapters = chapters
        self.book = book
        return book
    }

    @discardableResult
    func setChapters(chapterParam:NSDictionary?,index:Int,chapters:[QSChapter])->[QSChapter]{
        var chaptersTmp:[QSChapter] = []
        for item in 0..<chapters.count {
            let chapter = chapters[item]
            if item == index {
                if let chap = chapterParam {
                    chapter.content = chap["body"] as? String ?? ""
                    self.book?.chapters?[index] = chapter
                    update()
                }
            }
            chaptersTmp.append(chapter)
        }
        return chapters
    }

    func update(){
        self.bookDetail.book = self.book
//        updateBookShelf(bookDetail: self.bookDetail, type: .update, refresh: false)
    }
    
    func cacheAllChapter(){
        semaphore = DispatchSemaphore(value: 0)
        if let chapters = bookDetail.book?.chapters {
            total = chapters.count
            DispatchQueue.global().async {
                var index = 0
                var count = 0
                var exist:Bool = false
                self.output.showProgress(dict: ["desc":"正在缓存...","total":self.total,"now":"0"])
                for chapter in chapters {
                    if chapter.content == "" {
                        exist = true
                        count += 1
                        self.fetchChapter(index: index)
                        if count >= 5{
                            let timeout:Double? = 30.00
                            let timeouts = timeout.flatMap { DispatchTime.now() + $0 }
                                ?? DispatchTime.distantFuture
                            _ = self.semaphore.wait(timeout: timeouts)
                            count -= 1
                        }
                    }else{
                        self.total -= 1
                    }
                    index += 1
                }
                if !exist {
                    self.output.showProgress(dict: ["desc":"缓存完成"])
                }
            }
        }
    }
    
    func fetchChapter(index:Int){
        if index >= (chapters?.count ?? 0) {
            return
        }
        var link:NSString = "\(chapters?[index].object(forKey: "link") ?? "")" as NSString
        link = link.urlEncode() as NSString
        let api = QSAPI.chapter(key: link as String, type: .chapter)
        QSNetwork.request(api.path) { (response) in
            DispatchQueue.global().async {
                if let json = response.json as? Dictionary<String, Any> {
                    QSLog("JSON:\(json)")
                    if let chapter = json["chapter"] as?  Dictionary<String, Any> {
                        QSLog("下载完成第\(index)章节")
                        if let chapters = self.bookDetail.book?.chapters {
                            self.updateChapter(chapterParam: chapter as NSDictionary?, index: index, chapters: chapters)
                            self.now += 1
                            self.output.showProgress(dict: ["desc":"正在缓存...","total":self.total,"now":self.now])
                            self.semaphore.signal()
                        }
                        if let book = self.book {
                            self.output.downloadFinish(book: book)
                        }
                    } else {
                        QSLog("下载失败第\(index)章节")
                        self.semaphore.signal()
                        self.output.fetchChapterFailed()
                    }
                }else{
                    QSLog("下载失败第\(index)章节")
                    self.semaphore.signal()
                    self.output.fetchChapterFailed()
                }
            }
        }
    }
    
    func updateChapter(chapterParam:NSDictionary?,index:Int,chapters:[QSChapter]){
        DispatchQueue.global().async {
            let chapter = chapters[index]
            if let chap = chapterParam {
                chapter.content = chap["body"] as? String ?? ""
                self.book?.chapters?[index] = chapter
            }
            self.bookDetail.book = self.book
        }
    }
}

