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
import HandyJSON
import ZSAPI

class ZSReaderWebService:ZSBaseService {
    
    //MARK: - 请求所有的来源,key为book的id
    func fetchAllResource(key:String,_ callback:ZSBaseCallback<[ResourceModel]>?){
        let api = ZSAPI.allResource(key: key)
        zs_get(api.path, parameters: api.parameters) { (response) in
            if let resources  = [ResourceModel].deserialize(from: response as? [Any]) as? [ResourceModel] {
                callback?(resources)
            }else{
                callback?(nil)
            }
        }
    }
    
    //MARK: - 请求所有的章节,key为book的id
    func fetchAllChapters(key:String,_ callback:ZSBaseCallback<[ZSChapterInfo]>?){
        let api = ZSAPI.allChapters(key: key)
        let url:String = api.path
        zs_get(url, parameters: api.parameters) { (response) in
            if let chapters =  [ZSChapterInfo].deserialize(from: response?["chapters"] as? [Any]) as? [ZSChapterInfo]{
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
        let api = ZSAPI.chapter(key: link as String, type: .chapter)
        zs_get(api.path) { (response) in
            QSLog("JSON:\(String(describing: response))")
            if let body = ZSChapterBody.deserialize(from: response?["chapter"] as? NSDictionary) {
                callback?(body)
            } else {
                callback?(nil)
            }
        }
    }
}
