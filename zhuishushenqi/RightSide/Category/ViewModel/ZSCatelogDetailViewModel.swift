//
//  QSRankRouter.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/4/13.
//  Copyright © 2017年 QS. All rights reserved.
//
import ZSAPI

class ZSCatelogDetailViewModel:ZSSegmentBaseViewModel {
    
    var parameterModel:ZSCatelogParameterModel?
    var type:String = ""
    var title:String = ""
    var segmentIndex:Int = 0
    private var startIndex:Int = 0
    private var limit = 50
    
    override init() {
        
    }
    
    func request(_ handler:ZSBaseCallback<Void>?) {
        startIndex = 0
        limit = 50
        let major = parameterModel?.major ?? ""
        let gender = parameterModel?.gender ?? ""
        let api = ZSAPI.categoryList(gender: gender, type: type, major:  major, minor: "", start: "\(startIndex)", limit: "\(limit)")
        zs_get(api.path, parameters: api.parameters) { [weak self](response) in
            guard let sSelf = self else { return }
            guard let books = response?["books"] as? [Any] else {
                handler?(nil)
                return
            }
            if let models = [Book].deserialize(from: books) as? [Book] {
                sSelf.books = models
            }
            handler?(nil)
        }
    }
    
    func requestMore(_ handler:ZSBaseCallback<Void>?) {
        if startIndex < books.count {
            startIndex += limit
        } else {
            handler?(nil)
            return
        }
        let major = parameterModel?.major ?? ""
        let gender = parameterModel?.gender ?? ""
        let api = ZSAPI.categoryList(gender: gender, type: type, major:  major, minor: "", start: "\(startIndex)", limit: "\(limit)")
        zs_get(api.path, parameters: api.parameters) { [weak self](response) in
            guard let sSelf = self else { return }
            guard let books = response?["books"] as? [Any] else {
                handler?(nil)
                return
            }
            if let models = [Book].deserialize(from: books) as? [Book] {
                sSelf.books.append(contentsOf: models)
            }
            handler?(nil)
        }
    }
}
