//
//  ZSBookShelfViewModel.swift
//  zhuishushenqi
//
//  Created by yung on 2019/6/30.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit

class ZSBookShelfViewModel {
    
    var viewDidLoad: ()->() = {}
    var reloadBlock: (_ row:Int)->() = { row in }
    var shelfMsg:ZSShelfMessage?
    var searchViewModel:ZSSearchBookViewModel = ZSSearchBookViewModel()
    fileprivate let shelvesWebService = ZSShelfWebService()
    
    init() {
        viewDidLoad = { [weak self] in
            self?.requestMsg(completion: { index in
                self?.reloadBlock(index)
            })
        }
    }
    
    func requestMsg() {
        requestMsg { [weak self] index in
            self?.reloadBlock(index)
        }
    }
    
    func requestMsg(completion: @escaping(_ index:Int)->Void) {
        shelvesWebService.fetchShelfMsg { [weak self] (message) in
            self?.shelfMsg = message
            self?.update(completion: completion)
        }
    }
    
    func update(completion:@escaping(_ index:Int) ->Void) {
        func callback(index:Int) {
            DispatchQueue.main.async {
                completion(index)
            }
        }
        let books = ZSShelfManager.share.books
        if books.count == 0 {
            completion(-1)
        }
        for bookPath in books {
            guard let book = ZSShelfManager.share.getShelfModel(bookPath: bookPath) else {
                callback(index: -1)
                return
            }
            ZSShelfManager.share.getAikanModel(book) { [weak self] (result) in
                guard let src = result else {
                    callback(index: -1)
                    return
                }
                self?.searchViewModel.getBookInfo(src: src, bookUrl: book.bookUrl) { (chapters, info) in
                    let lastChapter = chapters.last
                    if chapters.count != src.chaptersModel.count {
                        src.chaptersModel = chapters
                        src.update = true
                    }
                    src.latestChapterName = lastChapter?.chapterName ?? ""
                    DispatchQueue.global().sync {
                        ZSShelfManager.share.modifyAikan(src)
                    }
                    let index = books.firstIndex(of: bookPath) ?? -1
                    if index == books.count - 1 {
                        callback(index: -1)
                    }
                }
            }
        }
    }
}
