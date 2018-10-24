//
//  ZSShelfWebService.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2018/7/31.
//  Copyright © 2018年 QS. All rights reserved.
//

import Foundation

class ZSShelfWebService: ZSBaseService {
    func fetchShelvesUpdate(for ids:[String],completion:@escaping ZSBaseCallback<[UpdateInfo]>) {
        let id = (ids as NSArray).componentsJoined(by: ",")
        let api = QSAPI.update(id: id)
        zs_get(api.path, parameters: api.parameters).responseJSON { (response) in
            if let data = response.data {
                if let obj = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [Any] {
                    if let models = [UpdateInfo].deserialize(from: obj) {
                        if let arr = models as? [UpdateInfo]{
                            completion(arr)
                        }
                    }
                }
            }
        }
    }
    
    func fetchShelfMsg(_ completion:ZSBaseCallback<ZSShelfMessage>?) {
        let shelfApi = QSAPI.shelfMSG()
        zs_get(shelfApi.path, parameters: shelfApi.parameters).responseJSON { (response) in
            if let data = response.data {
                if let obj = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any] {
                    if let message = ZSShelfMessage.deserialize(from: obj?["message"] as? [String:Any]) {
                        completion?(message)
                    }
                }
            }
        }
    }
    
    func fetchShelvesUpdate(for books:[BookDetail],completion:ZSBaseCallback<Void>?) {
        
        let id =  getIDSOf(books: books)
        let api = QSAPI.update(id: id)
        zs_get(api.path, parameters: api.parameters).responseJSON { (response) in
            if let data = response.data {
                if let obj = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [Any] {
                    
                }
            }
        }
    }
    
    func fetchBookshelf(token:String, completion:@escaping ZSBaseCallback<[ZSUserBookshelf]>) {
        let api = QSAPI.bookshelf(token: token)
        zs_get(api.path, parameters: api.parameters) { (json) in
            if let models = [ZSUserBookshelf].deserialize(from: json?["books"] as? [Any]) as? [ZSUserBookshelf] {
                completion(models)
            }
        }
    }
    
    func fetchShelfDelete(urlString:String, param:[String:Any]? ,completion:@escaping ZSBaseCallback<[String:Any]>) {
        zs_delete(urlString, parameters: param) { (json) in
            completion(json)
        }
    }
    
    func fetchShelfAdd(urlString:String, param:[String:Any]?, completion:@escaping ZSBaseCallback<[String:Any]>) {
        zs_put(urlString, parameters: param) { (json) in
            completion(json)
        }
    }
    
    func fetchBookInfo(id:String, completion:@escaping ZSBaseCallback<BookDetail>) {
        let api = QSAPI.book(key: id)
        zs_get(api.path, parameters: api.parameters) { (json) in
            if let book = BookDetail.deserialize(from: json) {
                completion(book)
            }
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
