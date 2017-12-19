//
//  BookManager.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2017/8/9.
//  Copyright © 2017年 QS. All rights reserved.
//

import Foundation

enum BookManager {
    case add
    case delete
    case update
}

extension BookManager {
    
    static func bookExistAtShelf(_ bookDetail:BookDetail?)->Bool{
        let mArr:[BookDetail] = BookShelfInfo.books.bookShelf
        var exist = false
        for item in mArr {
            if item._id == (bookDetail?._id ?? "") {
                exist = true
            }
        }
        return exist
    }
    
    static func book(_ bookDetail:BookDetail?, existAt books:[BookDetail])->Bool{
        var exist = false
        for item in books {
            if item._id == (bookDetail?._id ?? "") {
                exist = true
            }
        }
        return exist
    }
    
    static func updateShelfWithBook(_ bookDetail:BookDetail?){
        DispatchQueue.global().async {
            var mArr:[BookDetail] = BookShelfInfo.books.bookShelf
            var index = 0
            for item in mArr {
                let model = item
                if item._id == (bookDetail?._id ?? "") {
                    model.chapter = bookDetail?.chapter ?? 0
                    model.page = bookDetail?.page ?? 0
                    model.sourceIndex = bookDetail?.sourceIndex ?? 0
                    model.chapters = bookDetail?.chapters
                    model.resources = bookDetail?.resources
                    mArr[index] = model
                    BookShelfInfo.books.bookShelf = mArr
                    NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: BOOKSHELF_REFRESH)))
                }
                index += 1
            }
        }
    }
    
    static func replaceBook(with book:BookDetail,at books:[BookDetail]?)->[BookDetail]?{
        var index = 0
        if var mutaBooks = books {
            for item in mutaBooks {
                if item._id == book._id {
                    mutaBooks[index] = book
                    break
                }
                index += 1
            }
            return mutaBooks
        }
        return books
    }
    
    static func removeBookAtShelf(model:BookDetail,arr:[BookDetail])->[BookDetail]{
        var models = arr
        var index = 0
        for item in arr {
            if item._id == model._id {
                models.remove(at: index)
            }
            index += 1
        }
        return models
    }
    
    static func updateShelf(with bookDetail:BookDetail?,type:BookManager,refresh:Bool){
        DispatchQueue.global().async {
            
            var mArr:[BookDetail] = BookShelfInfo.books.bookShelf
            var index = 0
            var existIndex = -1
            for item in mArr {
                if item._id == (bookDetail?._id ?? "") {
                    existIndex = index
                    break
                }
                index += 1
            }
            if let model = bookDetail{
                if type == .add {
                    if existIndex == -1 {
                        mArr.append(model)
                        BookShelfInfo.books.bookShelf = mArr
                        if refresh {
                            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: BOOKSHELF_REFRESH)))
                        }
                    }
                }else if type == .delete {
                    if  existIndex != -1 {
                        mArr.remove(at: existIndex)
                        BookShelfInfo.books.bookShelf = mArr
                        if refresh {
                            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: BOOKSHELF_REFRESH)))
                        }
                    }
                }else if type == .update {
                    if existIndex != -1 {
                        mArr[existIndex] = model
                        BookShelfInfo.books.bookShelf = mArr
                        if refresh {
                            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: BOOKSHELF_REFRESH)))
                        }
                    }
                }
            }
        }
    }

    
}
