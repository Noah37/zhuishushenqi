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
    func fetchAllResource(_ callback:ZSBaseCallback<[ResourceModel]>?){
        let key = book?._id ?? ""
        webService.fetchAllResource(key: key) { (resources) in
            self.book?.resources = resources
            callback?(resources)
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
