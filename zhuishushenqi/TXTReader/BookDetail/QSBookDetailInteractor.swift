//
//  QSBookDetailInteractor.swift
//  zhuishushenqi
//
//  Created Nory Cao on 2017/4/13.
//  Copyright © 2017年 QS. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import ZSAPI

class QSBookDetailInteractor: QSBookDetailInteractorProtocol {
    
    var output: QSBookDetailInteractorOutputProtocol!
    
    var bookDetail:BookDetail!
    var hotComment:[BookComment] = []
    var bookList:[QSBookList] = []
    var recList:[Book] = []
    
    func requestData(id:String){
        let api = ZSAPI.book(key: id)
        zs_get(api.path, parameters: nil) { (response) in
            if let json = response as? [AnyHashable : Any]{
                if let book = BookDetail.deserialize(from: json as NSDictionary) {
                    self.bookDetail = book
                    self.requestHot(id: id)
                }else{
                    self.output.fetchRankFailed()
                }
            }else{
                self.output.fetchRankFailed()
            }
        }
    }
    
    func requestHot(id:String){
        let api = ZSAPI.bookHot(key: id)
        zs_get(api.path) { (response) in
            if let json = response?["reviews"] as? [Any] {
                if let hot = [BookComment].deserialize(from: json) as? [BookComment] {
                    self.hotComment = hot
                    self.output.fetchBookSuccess(bookDetail:self.bookDetail,ranks: self.hotComment)
                    
                }else{
                    self.output.fetchRankFailed()
                }
                
            }else{
                self.output.fetchRankFailed()
            }
        }
    }
    
    func requestAllChapters(withUrl url:String,param:[String:Any]){
        //先查询书籍来源，根据来源返回的id再查询所有章节
        zs_getObj(url, parameters: param) { (response) in
            if let resources = response  {
                
                if let res = [ResourceModel].deserialize(from: resources as? [Any]) as? [ResourceModel] {
                    self.output.fetchAllChapterSuccess(bookDetail: self.bookDetail, res: res)

                }else{
                    self.output.fetchAllChapterFailed()
                }
            }
            else {
                self.output.fetchAllChapterFailed()
            }
        }
    }
    
    func requestRecommend(){
        //        http://api.zhuishushenqi.com/book/51d11e782de6405c45000068/recommend
        let url = "\(BASEURL)/book/\(bookDetail._id)/recommend"
        zs_get(url) { (response) in
            let books = response?["books"] as? NSArray
            if let bookList = books {
                if let booklist = [Book].deserialize(from: bookList as? [Any]) as? [Book] {
                    self.recList = booklist
                    self.output.fetchRecommendSuccess(books: booklist)
                }else{
                    self.output.fetchRecommendFailed()
                }
            }else{
                self.output.fetchRecommendFailed()
            }
        }
    }
    
    func requestRecList(){
        //        http://api.zhuishushenqi.com/book-list/51d11e782de6405c45000068/recommend?limit=3
        let url = "\(BASEURL)/book-list/\(bookDetail._id)/recommend?limit=3"
        zs_get(url) { (response) in
            let books = response?["booklists"] as? NSArray
            if let bookList = books {
                if let booklist = [QSBookList].deserialize(from: bookList as?  [Any]) as? [QSBookList] {
                    self.bookList = booklist
                    self.output.fetchRecBookSuccess(books: booklist)
                }else{
                    self.output.fetchRecBookFailed()
                }
            }else{
                self.output.fetchRecBookFailed()
            }
        }
    }
    
    func showTopic(index:Int){
        if self.bookList.count > index {
            self.output.showTopic(model: self.bookList[index])
        }
    }
    
    func showBookDetail(tag:Int){
        if tag >= 4 {
            // 可能感兴趣
            self.output.showInterestedView(recList: self.recList)
            return
        }
        if self.recList.count > tag{
            self.output.showBookDetail(model: self.recList[tag])
        }
    }
    
    func showCommunity(){
        self.output.showCommunity(model: bookDetail)
    }
    
}
