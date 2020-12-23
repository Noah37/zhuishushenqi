//
//  ZSLocalShelfViewModel.swift
//  zhuishushenqi
//
//  Created by yung on 2018/7/31.
//  Copyright © 2018年 QS. All rights reserved.
//

import Foundation


class ZSLocalShelfViewModel {
    
    
    var books:[String:BookDetail] = [:]
    var paths:[String] = []
    
    init() {
        scanPath()
    }
    
    func scanPath(){
        let path = "\(NSHomeDirectory())/Documents/Inbox/"
        if let items = try? FileManager.default.contentsOfDirectory(atPath: path) {
            paths = items.map { "\(path)\($0)" }
        }
    }
    
    func fetchBook(path:String,completion:((BookDetail)->Void)?) {
        if let md5 = path.fileMD5() {
            // 存在则直接返回,不存在则需要进行解析
            if let obj = BookManager.shared.localBookInfo(key: md5) {
                books[path] = obj
                completion?(obj)
            } else {
                QSReaderParse.fetchBook(path: path) { (book) in
                    if let model = book {
                        self.books[path] = model
                        completion?(model)
                    }
                }
            }
        }
    }
    
}
