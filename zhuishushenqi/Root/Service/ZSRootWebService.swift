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

final class ZSRootWebService {
    func fetchShelvesUpdate(for books:[BookDetail]) ->Observable<[BookDetail]>{
        
        let id =  getIDSOf(books: books)
        let api = QSAPI.update(id: id)
        return requestJSON(.get, api.path, parameters: api.parameters)
            .observeOn(ConcurrentDispatchQueueScheduler(qos:.background))
            .map { responseData in
                
            return [BookDetail]()
        }
    }
    
    func getIDSOf(books:[BookDetail]) ->String{
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
