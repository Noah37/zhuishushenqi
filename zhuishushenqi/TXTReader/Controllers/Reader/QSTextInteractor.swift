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
    
    func commonInit(model:BookDetail){
        self.bookDetail = model
        self.resources  = self.bookDetail.resources
        self.chapters = self.bookDetail.chapters
        self.selectedIndex = self.bookDetail.sourceIndex
        self.book = book(bookDetail: self.bookDetail, chapters: self.chapters, resources: self.resources)
        
        if let book = self.book {
            self.output.showBook(book: book)
        }
        if let chapter = bookDetail.chapters?.count {
            requestChapter(atIndex: chapter)
        }
    }
    
    func requestAllResource(bookDetail:BookDetail){
        self.bookDetail = bookDetail
        //先查询书籍来源，根据来源返回的id再查询所有章节
        let url = "\(BASEURL)/toc"
        let param = ["view":"summary","book":bookDetail._id]
        QSNetwork.request(url, method: HTTPMethodType.get, parameters: param, headers: nil) { (response) in
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
        var url:String = "\(BASEURL)/toc/\(bookDetail._id)?view=chapters"
        if let res = self.resources {
            if res.count > self.selectedIndex {
                url = "\(BASEURL)/toc/\(self.resources?[self.selectedIndex]._id ?? "")?view=chapters"
            }
        }
        QSNetwork.request(url) { (response) in
            QSLog("JSON:\(response.json)")
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
        let url = "\(CHAPTERURL)/\(chapters?[chapterIndex].object(forKey: "link") ?? "")?k=22870c026d978c75&t=1489933049"
        QSNetwork.request(url) { (response) in
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
    func getPage(chapter:Int,pageIndex:Int) -> QSChapter?{
        var page:QSChapter?
        //获取本地 model，存在即返回,使用本章节序号 + 小说id的md5
        let localKey:String = "\(chapter)\(self.book?.resources?[selectedIndex].link ?? "")"
        if let model = QSChapter.localModelWithKey(key: localKey) {
            //判断向前翻页还是向后翻页
            page = model
            return page
        }
        self.output.showActivity()
        requestChapter(atIndex: chapter)
        return page
    }
    
    func getLocalPage(chapter:Int,pageIndex:Int)->QSChapter?{
        var page:QSChapter?
        //获取本地 model，存在即返回,使用本章节序号 + 小说id的md5
        let localKey:String = "\(chapter)\(self.book?.resources?[selectedIndex].link ?? "")"
        if let model = QSChapter.localModelWithKey(key: localKey) {
            //判断向前翻页还是向后翻页
            page = model
        }
        return page
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
    
    func setChapters(chapterParam:NSDictionary?,index:Int,chapters:[QSChapter])->[QSChapter]{
        var chaptersTmp:[QSChapter] = []
        for item in 0..<chapters.count {
            let chapter = chapters[item]
            if item == index {
                if let chap = chapterParam {
                    chapter.content = chap["body"] as? String ?? ""
                    updateLocal(model:chapter)
                }
            }
            chaptersTmp.append(chapter)
        }
        return chapters
    }
    
    func updateLocal(model:QSChapter){
        QSChapter.updateLocalModel(localModel: model, link:self.resources?[selectedIndex].link ?? "")
    }

}

