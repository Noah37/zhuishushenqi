//
//  ZSBookShelfViewModel.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2019/6/30.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit

class ZSBookShelfViewModel {
    
    var viewDidLoad: ()->() = {}
    var reloadBlock: ()->() = {}
    var shelfMsg:ZSShelfMessage?
    var searchViewModel:ZSSearchBookViewModel = ZSSearchBookViewModel()
    fileprivate let shelvesWebService = ZSShelfWebService()
    
    init() {
        viewDidLoad = { [weak self] in
            self?.requestMsg(completion: {
                self?.reloadBlock()
            })
        }
    }
    
    func requestMsg() {
        requestMsg { [weak self] in
            self?.reloadBlock()
        }
    }
    
    func requestMsg(completion: @escaping()->Void) {
        shelvesWebService.fetchShelfMsg { [weak self] (message) in
            self?.shelfMsg = message
            completion()
        }
        let books = ZSShelfManager.share.books
        for book in books {
            if let src = ZSShelfManager.share.aikan(book) {
                searchViewModel.getChapter(src: src, bookUrl: book.bookUrl) { (chapters, info) in
                    let lastChapter = chapters.last
                    if chapters.count != src.chaptersModel.count {
                        src.chaptersModel = chapters
                        src.update = true
                    }
                    src.latestChapterName = lastChapter?.chapterName ?? ""
                    ZSShelfManager.share.modifyAikan(src)
                }
            }
        }
    }
    
    

}
