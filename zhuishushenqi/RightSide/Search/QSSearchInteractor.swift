//
//  QSSearchInteractor.swift
//  zhuishushenqi
//
//  Created Nory Cao on 2017/4/10.
//  Copyright © 2017年 QS. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
//import YTKKeyValueStore
import ZSAPI

typealias ZSSearchWebCallback = (_ hotwords:[String]?)->Void
typealias ZSSearchWebAnyCallback<T> = (_ hotwords:T?)->Void


class ZSSearchWebService {
    
    //NARK: - webserver data
    func fetchHotwords (_ callback: ZSSearchWebCallback?){
        let api = ZSAPI.hotwords("" as AnyObject)
        zs_get(api.path, parameters: nil) { (response) in
            QSLog(response)
            if let hotwords:[String] = response?["hotWords"] as? [String] {
                callback?(hotwords)
            }else{
                callback?(nil)
            }
        }
    }
    
    func fetchAutoComplete(key:String,_ callback:ZSSearchWebCallback?){
        let api = ZSAPI.autoComplete(query: key)
        zs_get(api.path, parameters: api.parameters) { (response) in
            if let keywords = response?["keywords"] as? [String] {
                callback?(keywords)
            } else {
                callback?(nil)
            }
        }
    }
    
    func fetchBooks( key:String, start:Int, limit:Int, _ callback:ZSSearchWebAnyCallback<[Book]>?){
        let api = ZSAPI.searchBook(id: key, start: "\(start)", limit: "\(limit)")
        zs_get(api.path, parameters: api.parameters) { (response) in
            if let books = response?["books"] {
                if let models = [Book].deserialize(from: books as? [Any]) as? [Book] {
                    callback?(models)
                } else {
                    callback?(nil)
                }
            } else {
                callback?(nil)
            }
        }
    }
}

class QSSearchInteractor: QSSearchInteractorProtocol {

    weak var output: QSSearchInteractorOutputProtocol!
    var hotwords:[String] = []
    var offset:Int = 0
    
    private let SearchStoreKey = "SearchHistory"

    func fetchHotwords(){
        let api = ZSAPI.hotwords("" as AnyObject)
        zs_get(api.path, parameters: nil) { (response) in
            QSLog(response)
            if let hotwords:[String] = response?["hotWords"] as? [String] {
                self.hotwords = hotwords
                self.output.fetchHotwordsSuccess(hotwords: self.subWords())
            }else{
                self.output.fetchHotwordsFailed()
            }
        }
    }
    
    func fetchSearchList(){
        var list:[[String]] = []
        let hot:[String] = []
        var history:[String] = []
        history = getHistoryList()
        list.append(hot)
        list.append(history)
        self.output.searchListFetch(list: list)
    }
    
    func clearSearchList(){
        let store = getHistoryStore()
        let list:[[String]] = [[],[]]
        store?.clearTable(searchHistory)
    
        self.output.searchListFetch(list: list)
    }
    
    func autoComplete(key:String){
        let api = ZSAPI.autoComplete(query: key)
        zs_get(api.path, parameters: api.parameters) { (response) in
            guard let keywords = response?["keywords"] as? [String] else {
                return
            }
            self.output.fetchAutoComplete(keys: keywords)
        }
    }
    
    func updateHistoryList(history:String){
        if history == ""{
            return
        }
        var list = getHistoryList()
        if !isExistSearchWord(key: history, historyList:list) {
            let store = getHistoryStore()
            list.append(history.trimmingCharacters(in: CharacterSet(charactersIn: " ")))
            store?.clearTable(searchHistory)
            store?.put(list, withId: SearchStoreKey, intoTable: searchHistory)
            self.output.searchListFetch(list: [ [],list])
        }
    }
    
    func fetchBooks(key:String){
        let api = ZSAPI.searchBook(id: key, start: "0", limit: "100")
        zs_get(api.path, parameters: api.parameters) { (response) in
            if let books = response?["books"] {
                if let models = [Book].deserialize(from: books as? [Any]) as? [Book] {
                    self.output.fetchBooksSuccess(books: models,key:key)
                } else {
                    self.output.fetchBooksFailed(key: key)
                }
            } else {
                self.output.fetchBooksFailed(key: key)
            }
        }
    }
    
    func getHistoryList()->[String]{
        let store = getHistoryStore()
        return store?.getObjectById(SearchStoreKey, fromTable: searchHistory) as? [String] ?? []
    }
    
    func getHistoryStore()->YTKKeyValueStore?{
        let store  = YTKKeyValueStore(dbWithName: dbName)
        if store?.isTableExists(searchHistory) == false {
            store?.createTable(withName: searchHistory)
        }
        return store
    }
    
    func isExistSearchWord(key:String,historyList:[String])->Bool{
        var isExist = false
        for item in historyList {
            if item == key {
                isExist = true
            }
        }
        return isExist
    }
    
    func subWords()->[String]{
        if hotwords.count == 0 {
            return []
        }
        var subWords:[String] = []
        for item in offset..<offset+6 {
            subWords.append(hotwords[item%hotwords.count])
        }
        offset += 6
        return subWords
    }
}
