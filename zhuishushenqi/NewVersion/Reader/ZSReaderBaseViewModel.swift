//
//  ZSReaderBaseViewModel.swift
//  zhuishushenqi
//
//  Created by caony on 2019/9/20.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit

class ZSReaderBaseViewModel {
    

    var book:BookDetail?
    fileprivate var webService = ZSReaderWebService()

    //MARK: - fetch network resource
    func request(_ callback:ZSBaseCallback<Void>?){
        guard let model = book else { return }
        ZSReaderCache.shared.request(book: model) { (_) in
            callback?(nil)
        }
    }
    
    func fetchAllChapters(_ callback:ZSBaseCallback<[ZSChapterInfo]>?){
        
    }
    
    func fetchSourceIndex() ->Int? {
        guard let source = self.book?.record?.source else { return nil }
        guard let resources = self.book?.resources else { return nil }
        var index = 0
        for model in resources {
            if model._id.isEqual(to: source._id) {
                break
            }
            index += 1
        }
        return index
    }
}
