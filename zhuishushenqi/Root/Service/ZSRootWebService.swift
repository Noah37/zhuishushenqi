//
//  ZSRootWebService.swift
//  zhuishushenqi
//
//  Created by caony on 2018/6/7.
//  Copyright © 2018年 QS. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxAlamofire
import Alamofire
import HandyJSON

final class ZSRootWebService:ZSBaseService {
    
    func fetchShelvesUpdate(for books:[BookDetail]) ->Observable<[BookDetail]>{
        
        let id =  getIDSOf(books: books)
        let api = QSAPI.update(id: id)
        return requestJSON(.get, api.path, parameters: api.parameters)
            .observeOn(ConcurrentDispatchQueueScheduler(qos:.background))
            .map { responseData in
                
            return [BookDetail]()
        }
    }
    
    func fetchShelvesUpdate(for ids:[String]) ->Observable<[String:Any]>{
        let id = (ids as NSArray).componentsJoined(by: ",")
        let api = QSAPI.update(id: id)
        return requestJSON(.get, api.path, parameters: api.parameters)
            .observeOn(ConcurrentDispatchQueueScheduler(qos:.background))
            .map { (_,responseData) in
                // json解析
                if let models = [BookShelf].deserialize(from: responseData as? [Any]) {
                    if let arr = models as? [BookShelf]{
                        BookManager.shared.updateInfoUpdate(updateInfo: arr)
                        return BookManager.shared.books
                    }
                }
                return [:]
        }
    }
    
    func fetchShelvesMsg() -> Observable<ZSShelfMessage>{
        let shelfApi = QSAPI.shelfMSG()
        return requestJSON(.get, shelfApi.path, parameters: shelfApi.parameters)
            .observeOn(ConcurrentDispatchQueueScheduler(qos:.background))
            .map{ (_,responseData) in
                if let message = ZSShelfMessage.deserialize(from: (responseData as! [String:Any])["message"] as? [String:Any]) {
                    return message
                }
                return ZSShelfMessage()
            }
    }
    
    private func getIDSOf(books:[BookDetail]) ->String{
        var id = ""
        for book in  books {
            if (book._id != "") {
                if id != "" {
                    id.append(",")
                }
                id.append(book._id)
            }
        }
        return id
    }
}
