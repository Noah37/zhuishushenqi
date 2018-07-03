//
//  QSTextInteractor.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/4/14.
//  Copyright © 2017年 QS. All rights reserved.
//

/*
 chapters:
 {
 chapterCover = "";
 currency = 0;
 isVip = 0;
 link = "http://book.my716.com/getBooks.aspx?method=content&bookId=2201994&chapterFile=U_2201994_201806182043464927_0420_600.txt";
 order = 0;
 partsize = 0;
 title = "\U7b2c\U4e94\U4e5d\U516b\U7ae0 \U8d8a\U5357\U5144\U5f1f\Uff08\U8865\U66f44\Uff09";
 totalpage = 0;
 unreadble = 0;
 }
 */

import Foundation
import QSNetwork
import HandyJSON

class ZSReaderWebService:ZSBaseService {
    
    //MARK: - 请求所有的来源,key为book的id
    func fetchAllResource(key:String,_ callback:ZSBaseCallback<[ResourceModel]>?){
        let api = QSAPI.allResource(key: key)
        QSNetwork.request(api.path, method: HTTPMethodType.get, parameters: api.parameters, headers: nil) { (response) in
            if let resource = response.json {
                if let resources  = [ResourceModel].deserialize(from: resource as? [Any]) as? [ResourceModel] {
                    callback?(resources)
                }else{
                    callback?(nil)
                }
            }else{
                callback?(nil)
            }
        }
    }
    
    //MARK: - 请求所有的章节,key为book的id
    func fetchAllChapters(key:String,_ callback:ZSBaseCallback<[ZSChapterInfo]>?){
        let api = QSAPI.allChapters(key: key)
        let url:String = api.path
        QSNetwork.request(url, method: HTTPMethodType.get, parameters: api.parameters, headers: nil) { (response) in
            QSLog("JSON:\(String(describing: response.json))")
            if let chapters =  [ZSChapterInfo].deserialize(from: response.json?["chapters"] as? [Any]) as? [ZSChapterInfo]{
                QSLog("Chapters:\(chapters)")
                callback?(chapters)
            }else{
                callback?(nil)
            }
        }
    }
    
    //MARK: - 请求当前章节的信息,key为当前章节的link,追书正版则为id
    func fetchChapter(key:String,_ callback:ZSBaseCallback<ZSChapterBody>?){
        var link:NSString = key as NSString
        link = link.urlEncode() as NSString
        let api = QSAPI.chapter(key: link as String, type: .chapter)
        QSNetwork.request(api.path) { (response) in
            QSLog("JSON:\(String(describing: response.json))")
            if let body = ZSChapterBody.deserialize(from: response.json?["chapter"] as? NSDictionary) {
                callback?(body)
            } else {
                callback?(nil)
            }
        }
    }
}

class QSTextInteractor: QSTextInteractorProtocol {
    var output: QSTextInteractorOutputProtocol!
    
    var book:QSBook?
    var resources:[ResourceModel]?
    var chapters:[NSDictionary]?
    var chapterDict:[String:Any] = [:]
    var bookDetail:BookDetail!
    var selectedIndex:Int = 0 //当前选择的源
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
                if let resources  = [ResourceModel].deserialize(from: resource as? [Any]) as? [ResourceModel] {
                    self.resources = resources
                    self.output.fetchAllResourceSuccess(resource: resources)

                }else{
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
                    // 章节信息获取成功后model化
                    
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
    func getChapter(chapterIndex:Int,pageIndex:Int) {
//        self.output.showActivity()
        requestChapter(atIndex: chapterIndex)
    }

    @discardableResult
    func setChapters(chapterParam:NSDictionary?,index:Int,chapters:[QSChapter])->[QSChapter]{
        var chaptersTmp:[QSChapter] = []
        for item in 0..<chapters.count {
            let chapter = chapters[item]
            if item == index {
                if let chap = chapterParam {
                    chapter.content = chap["body"] as? String ?? ""
                    self.book?.chapters[index] = chapter
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
                self.book?.chapters[index] = chapter
            }
            self.bookDetail.book = self.book
        }
    }
}

