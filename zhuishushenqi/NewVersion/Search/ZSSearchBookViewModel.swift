//
//  ZSSearchBookViewModel.swift
//  zhuishushenqi
//
//  Created by caony on 2019/10/22.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit
import ZSAPI
import Alamofire

class ZSSearchBookViewModel {
    
    var viewDidLoad: ()->() = {}
    var reloadBlock: ()->() = {}
    
    var searchHotwords:[ZSSearchHotwords] = []
    var hotword:[ZSHotWord] = []
    
    var searchHotHeader:ZSHeaderSearch = ZSHeaderSearch()
    var searchRecHeader:ZSHeaderSearch = ZSHeaderSearch()
    var historyHeader:ZSHeaderSearch = ZSHeaderSearch()

    var source:[AikanParserModel] = []
    
    private var stopBooks:Bool = false

    init() {
        viewDidLoad = { [weak self] in
            self?.request()
        }
        self.source = ZSSourceManager.share.sources.filter({ (model) -> Bool in
            return model.checked
        })
        historyHeader.type = .history
        historyHeader.items = ZSHistoryManager.share.historyList
        historyHeader.headerTitle = "搜索历史"
        historyHeader.headerDetail = "删除历史"
        historyHeader.height = 44
        historyHeader.headerIcon = ""
    }
    
    func stopRequestBooks() {
        stopBooks = true
    }
    
    func startRequestBooks() {
        stopBooks = false
    }
    
    private func calHotSearch(hot:[ZSSearchHotwords]) {
        var hotSearchs = hot
        let words = hotSearchs.filter { (word) -> Bool in
            if let index = hotSearchs.firstIndex(of: word) {
                return index < 8
            }
            return true
        }
        hotSearchs = words
        let marginX:CGFloat = 20
        let marginY:CGFloat = 10
        let cellHeight:CGFloat = 28
        let spaceX:CGFloat = 15
        let spaceY:CGFloat = 20
        var cellX = marginX
        var cellY = marginY
        var index = 0
        for hotword in words {
            var cell = hotword
            let cellWidth = hotword.word.qs_width(13, height: cellHeight/2) + 20
            if (cellX + cellWidth + marginX + spaceX) > UIScreen.main.bounds.width {
                cellY += (cellHeight + spaceY)
                cellX = marginX
            } else if index != 0 {
                cellX += spaceX
            }
            cell.frame = CGRect(x: cellX, y: cellY, width: cellWidth, height: cellHeight)
            cellX += cellWidth
            hotSearchs[index] = cell
            index += 1
        }
        let hotHeight = cellY + cellHeight + 55 + 10
        searchHotHeader.type = .hot
        searchHotHeader.items = hotSearchs
        searchHotHeader.headerTitle = "搜索热词"
        searchHotHeader.headerDetail = "查看更多"
        searchHotHeader.height = hotHeight
        searchHotHeader.headerIcon = ""
        self.searchHotwords = hotSearchs
    }
    
    private func calRecSearch(rec:[ZSHotWord]) {
        var recs:[ZSHotWord] = rec
        let words = recs.filter { (word) -> Bool in
            if let index = recs.firstIndex(of: word) {
                return index < 8
            }
            return true
        }
        recs = words
        let marginX:CGFloat = 20
        let marginY:CGFloat = 10
        let cellHeight:CGFloat = 28
        let spaceX:CGFloat = 0
        let spaceY:CGFloat = 10
        var cellX = marginX
        var cellY = marginY
        var index = 0
        for hot in words {
            var cell = hot
            let cellWidth = (UIScreen.main.bounds.width - 40)/2
            cellY = CGFloat(index/2) * (cellHeight + spaceY) + marginY
            cell.frame = CGRect(x: cellX, y: cellY, width: cellWidth, height: cellHeight)
            cellX += spaceX
            cellX += cellWidth
            if cellX + cellWidth + spaceX + marginX > UIScreen.main.bounds.width {
                cellX = marginX
            }
            recs[index] = cell
            index += 1
        }
        let recHeight = cellY + cellHeight + 55 + 10
        searchRecHeader.type = .recommend
        searchRecHeader.items = recs
        searchRecHeader.headerTitle = "热门推荐"
        searchRecHeader.headerDetail = "换一批"
        searchRecHeader.height = recHeight
        searchRecHeader.headerIcon = ""
    }
    
    func numberOfSections() ->Int {
        if historyHeader.items.count > 0 {
            return 3
        }
        return 2
    }
    
    func model(for row:Int) ->ZSHeaderSearch {
        if row == 0 {
            return searchHotHeader
        } else if row == 1 {
            return searchRecHeader
        }
        historyHeader.items = ZSHistoryManager.share.historyList
        return historyHeader
    }
    
    func height(for row:Int) ->CGFloat {
        let header = model(for: row)
        return header.height
    }
    
    func wordClick(word:String) {
        ZSHistoryManager.share.add(word: word)
    }
    
    func delete(word:String) {
        ZSHistoryManager.share.remove(word: word)
    }
    
    func request() {
        requestSearchHotwords { [weak self] in
            self?.reloadBlock()
        }
        requestHotWord { [weak self] in
            self?.reloadBlock()
        }
    }
    
    func request(text:String,completion:@escaping(_ book:AikanParserModel)->Void) {
        for src in self.source {
            var searchUrl = src.searchUrl.replacingOccurrences(of: "%@", with: text)
            let character = CharacterSet.urlQueryAllowed
            searchUrl = searchUrl.addingPercentEncoding(withAllowedCharacters: character) ?? ""
            var headers = SessionManager.defaultHTTPHeaders
            headers["User-Agent"] = YouShaQiUserAgent
            Alamofire.request(searchUrl, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseData { [weak self] (data) in
                if let htmlData = data.data {
                    let htmlString = String(data: htmlData, encoding: .utf8) ?? ""
                    self?.getBooks(src: src, htmlString: htmlString, completion: { (book) in
                        completion(book)
                    })
                }
            }
        }
    }
    
    private func getBooks(src:AikanParserModel, htmlString:String, completion:@escaping(_ book:AikanParserModel)->Void) {
        guard let document = OCGumboDocument(htmlString: htmlString) else { return }
        let reg = src.books
        let parse = AikanHtmlParser()
        let obj = parse.elementArray(with: document, withRegexString: reg)
        for index in 0..<obj.count {
            var bookAuthor = parse.string(withGumboNode: obj[index], withAikanString: src.bookAuthor, withText: true)
            var bookIcon = parse.string(withGumboNode: obj[index], withAikanString: src.bookIcon, withText: false)
            var bookName = parse.string(withGumboNode: obj[index], withAikanString: src.bookName, withText: true)
            var bookDesc = parse.string(withGumboNode: obj[index], withAikanString: src.bookDesc, withText: true)
            var bookUrl = parse.string(withGumboNode: obj[index], withAikanString: src.bookUrl, withText: false)
            if bookAuthor.length == 0 && bookName.length == 0 || bookUrl.length == 0 {
                continue
            }
            if !bookUrl.hasPrefix("http") {
                if bookUrl.hasPrefix("/") && src.host.hasSuffix("/") {
                    let host = src.host.qs_subStr(start: 0, length: src.host.length - 1)
                    bookUrl = "\(host)\(bookUrl)"
                } else {
                    bookUrl = "\(src.host)\(bookUrl)"
                }
            }
            if bookIcon.hasPrefix("//") {
                bookIcon = bookIcon.replacingOccurrences(of: "//", with: "http://")
            }
            bookAuthor = bookAuthor.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            bookName = bookName.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            bookDesc = bookDesc.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            getChapter(src: src, bookUrl: bookUrl) { (chapters, bookDetailInfo) in
                let book = AikanParserModel()
                book.bookAuthor = bookAuthor
                book.bookIcon = bookIcon
                book.bookName = bookName
                book.bookDesc = bookDesc
                book.bookUrl = bookUrl
                book.name = src.name
                book.chaptersModel = chapters
                book.detailBookDesc = bookDetailInfo["detailBookDesc"] ?? ""
                book.detailBookIcon = bookDetailInfo["detailBookIcon"] ?? ""
                book.bookLastChapterName = bookDetailInfo["bookLastChapterName"] ?? ""
                book.bookUpdateTime = bookDetailInfo["bookUpdateTime"] ?? ""
                completion(book)
            }
        }
    }
    
    private func getChapter(src:AikanParserModel, bookUrl:String, completion:@escaping(_ chapters:[[String:Any]], _ bookDetailInfo:[String:String])->Void) {
        var headers = SessionManager.defaultHTTPHeaders
        headers["User-Agent"] = YouShaQiUserAgent
        let manager = SessionManager.default
        manager.delegate.sessionDidReceiveChallenge = {
            session,challenge in
            return  (URLSession.AuthChallengeDisposition.useCredential,URLCredential(trust:challenge.protectionSpace.serverTrust!))
        }
        Alamofire.request(bookUrl, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseData { (data) in
            if let htmlData = data.data {
                let htmlString = String(data: htmlData, encoding: .utf8) ?? ""
                guard let document = OCGumboDocument(htmlString: htmlString) else { return }
                // 如果detailChaptersUrl不存在，则直接去chapters
                var reg = src.detailChaptersUrl
                if reg.length > 0 {
                    let parse = AikanHtmlParser()
                    var chapterDir = parse.string(withGumboNode: document, withAikanString: reg, withText: false)
                    if !chapterDir.hasPrefix("http") {
                        if chapterDir.hasPrefix("/") && src.host.hasSuffix("/") {
                            let host = src.host.qs_subStr(start: 0, length: src.host.length - 1)
                            chapterDir = "\(host)\(chapterDir)"
                        } else {
                            chapterDir = "\(src.host)\(chapterDir)"
                        }
                    }
                    Alamofire.request(chapterDir, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseData(completionHandler: { (data) in
                        guard let htmlData = data.data else { return }
                        let htmlString = String(data: htmlData, encoding: .utf8) ?? ""
                        guard let document = OCGumboDocument(htmlString: htmlString) else { return }
                        let parse = AikanHtmlParser()
                        let chalters = parse.elementArray(with: document, withRegexString: src.chapters)
                        var chaptersArr:[[String:Any]] = []
                        for node in chalters {
                            let chapterUrl = parse.string(withGumboNode: node, withAikanString: src.chapterUrl, withText: false)
                            let chapterTitle = parse.string(withGumboNode: node, withAikanString: src.chapterName, withText: true)
                            chaptersArr.append(["chapterUrl":chapterUrl,
                                                "chapterName":chapterTitle])
                        }
                        if !self.stopBooks {
                            completion(chaptersArr,[:])
                        }
                    })
                } else {
                    reg = src.chapters
                    let parse = AikanHtmlParser()
                    let detailBookDesc = parse.string(withGumboNode: document, withAikanString: src.detailBookDesc, withText: false)
                    let detailBookIcon = parse.string(withGumboNode: document, withAikanString: src.detailBookIcon, withText: false)
                    let bookLastChapterName = parse.string(withGumboNode: document, withAikanString: src.bookLastChapterName, withText: true)
                    let bookUpdateTime = parse.string(withGumboNode: document, withAikanString: src.bookUpdateTime, withText: true)
                    let bookDetailInfo:[String:String] = ["detailDesc":detailBookDesc,
                                                          "detailBookIcon":detailBookIcon,
                                                          "bookLastChapterName":bookLastChapterName,
                                                          "bookUpdateTime":bookUpdateTime]
                    let obj = parse.elementArray(with: document, withRegexString: reg)
                    var chaptersArr:[[String:Any]] = []
                    for index in 0..<obj.count {
                        var chapterUrl = parse.string(withGumboNode: obj[index], withAikanString: src.chapterUrl, withText: false)
                        if chapterUrl.length > 0 && !chapterUrl.hasPrefix("http") {
                            chapterUrl = bookUrl + chapterUrl
                        }
                        let chapterName = parse.string(withGumboNode: obj[index], withAikanString: src.chapterName, withText: true)
                        chaptersArr.append(["chapterUrl":chapterUrl,
                        "chapterName":chapterName])
                    }
                    if !self.stopBooks {
                        completion(chaptersArr,bookDetailInfo)
                    }
                }
            }
        }
    }
    
    private func requestSearchHotwords(completion:@escaping()->Void) {
        let api = ZSAPI.searchHotwords("" as AnyObject)
        zs_get(api.path) { [weak self] (json) in
            guard let searchHotwordsDict = json?["searchHotWords"] as? [[String:Any]] else {
                completion()
                return
            }
            guard let searchModels = [ZSSearchHotwords].deserialize(from: searchHotwordsDict) as? [ZSSearchHotwords] else {
                completion()
                return
            }
            self?.searchHotwords = searchModels
            self?.calHotSearch(hot: searchModels)
            completion()
        }
    }
    
    private func requestHotWord(completion:@escaping()->Void) {
        let api = ZSAPI.hotwords("" as AnyObject)
        zs_get(api.path) { [weak self] (json) in
            guard let searchHotwordsDict = json?["newHotWords"] as? [[String:Any]] else {
                completion()
                return
            }
            guard let searchModels = [ZSHotWord].deserialize(from: searchHotwordsDict) as? [ZSHotWord] else {
                completion()
                return
            }
            self?.hotword = searchModels
            self?.calRecSearch(rec: searchModels)
            completion()
        }
    }
}
