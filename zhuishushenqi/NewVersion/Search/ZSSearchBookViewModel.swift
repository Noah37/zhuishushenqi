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

let NET = ZSReaderDownloader.share

class ZSSearchBookViewModel {
    
    var viewDidLoad: ()->() = {}
    var reloadBlock: ()->() = {}
    
    var searchHotwords:[ZSSearchHotwords] = []
    var hotword:[ZSHotWord] = []
    
    var searchHotHeader:ZSHeaderSearch = ZSHeaderSearch()
    var searchRecHeader:ZSHeaderSearch = ZSHeaderSearch()
    var historyHeader:ZSHeaderSearch = ZSHeaderSearch()

    var source:[ZSAikanParserModel] = []
        
    private var stopBooks:Bool = false
    
    private let detailBookDesc = "detailBookDesc"
    private let detailBookIcon = "detailBookIcon"
    private let bookLastChapterName = "bookLastChapterName"
    private let bookUpdateTime = "bookUpdateTime"

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
        let hotHeight = cellY + cellHeight + 10
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
        let recHeight = cellY + cellHeight + 10
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
    
    func requestString(url:String, encoding:String.Encoding, handler:@escaping ZSBaseCallback<String>) {
        NET.requestData(url: url) { (data) in
            guard let responseData = data else { return }
            let htmlString = String(data: responseData, encoding: encoding)
            handler(htmlString)
        }
    }
    
    func request(text:String,completion:@escaping(_ book:ZSAikanParserModel)->Void) {
        for (_, src) in source.enumerated() {
            var searchUrl = src.searchUrl.replacingOccurrences(of: "%@", with: text)
            let character = CharacterSet.urlQueryAllowed
            searchUrl = searchUrl.addingPercentEncoding(withAllowedCharacters: character) ?? ""
            let encoding = String.Encoding.zs_encoding(str: src.searchEncoding )
            requestString(url: searchUrl, encoding: encoding) { [weak self, unowned src](string) in
                guard let sSelf = self else { return }
                guard let htmlString = string else { return }
                sSelf.getBook(src: src, htmlString: htmlString) { (book) in
                    completion(book)
                }
            }
        }
    }
    
    private func getBook(src:ZSAikanParserModel,
                          htmlString:String,
                          completion:@escaping(_ book:ZSAikanParserModel)->Void) {
        guard let document = OCGumboDocument(htmlString: htmlString) else { return }
        let reg = src.books
        let parse = AikanHtmlParser()
        let obj = parse.elementArray(with: document, withRegexString: reg)
        for node in obj {
            let book = src.copySelf()
            book.name = src.name
            book.bookAuthor = parse.string(withGumboNode: node, withAikanString: src.bookAuthor, withText: true).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            book.bookIcon = parse.string(withGumboNode: node, withAikanString: src.bookIcon, withText: false).httpScheme()
            book.bookName = parse.string(withGumboNode: node, withAikanString: src.bookName, withText: true).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            book.bookDesc = parse.string(withGumboNode: node, withAikanString: src.bookDesc, withText: true).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            book.bookUrl = parse.string(withGumboNode: node, withAikanString: src.bookUrl, withText: false).schemeURLString(src.host)
            book.bookUpdateTime = parse.string(withGumboNode: node, withAikanString: src.bookUpdateTime, withText: true)
            book.bookLastChapterName = parse.string(withGumboNode: node, withAikanString: src.bookLastChapterName, withText: true)

            if !book.available() {
                continue
            }
            getBookInfo(src: src, bookUrl: book.bookUrl) { [weak self] (chapters, bookDetailInfo) in
                guard let sself = self else { return }
                book.chaptersModel = chapters
                book.detailBookDesc = bookDetailInfo[string:sself.detailBookDesc]
                book.detailBookIcon = bookDetailInfo[string:sself.detailBookIcon]
                book.bookLastChapterName = book.bookLastChapterName.length > 0 ? book.bookLastChapterName: bookDetailInfo[string:sself.bookLastChapterName]
                book.bookUpdateTime = book.bookUpdateTime.length > 0 ? book.bookUpdateTime:bookDetailInfo[string:sself.bookUpdateTime]
                completion(book)
            }
        }
    }
    
    func getBookInfo(src:ZSAikanParserModel, bookUrl:String, completion:@escaping(_ chapters:[ZSBookChapter], _ bookDetailInfo:[String:String])->Void) {
        NET.requestData(url: bookUrl) { [weak self](data) in
            guard let sself = self else { return }
            guard let responseData = data else { return }
            let htmlString = String(data: responseData, encoding: String.Encoding.zs_encoding(str: src.searchEncoding)) ?? ""
            let noTagString = sself.contentTagRemove(string: htmlString, reg: src.contentTagReplace, encoding: src.searchEncoding)
            guard let document = OCGumboDocument(htmlString: noTagString) else { return }
            let parse = AikanHtmlParser()
            var bookDetailInfo:[String:String] = [:]
            bookDetailInfo[sself.detailBookDesc] = parse.string(withGumboNode: document, withAikanString: src.detailBookDesc, withText: false)
            bookDetailInfo[sself.detailBookIcon] = parse.string(withGumboNode: document, withAikanString: src.detailBookIcon, withText: false)
            bookDetailInfo[sself.bookLastChapterName] = parse.string(withGumboNode: document, withAikanString: src.bookLastChapterName, withText: true)
            bookDetailInfo[sself.bookUpdateTime] = parse.string(withGumboNode: document, withAikanString: src.bookUpdateTime, withText: true)
            // 如果detailChaptersUrl不存在，则直接取chapters字段，无需重新请求
            var reg = src.detailChaptersUrl
            if reg.length > 0 {
                var chapterDir = parse.string(withGumboNode: document, withAikanString: reg, withText: false)
                chapterDir = chapterDir.schemeURLString(src.host)
                sself.getDetailChapters(chaptersUrl: chapterDir, bookUrl: bookUrl, src: src) { (chapters) in
                    guard let chapterModels = chapters else { return }
                    completion(chapterModels, bookDetailInfo)
                }
            } else {
                reg = src.chapters
                let obj = parse.elementArray(with: document, withRegexString: reg)
                var chaptersArr:[ZSBookChapter] = []
                for node in obj {
                    autoreleasepool {
                        let index = obj.index(of: node)
                        let chapter = sself.getChapter(node: node, index: index, src: src)
                        chapter.bookUrl = bookUrl
                        chaptersArr.append(chapter)
                    }
                }
                if !sself.stopBooks {
                    completion(chaptersArr,bookDetailInfo)
                }
            }
        }
    }
    
    func getChapter(node:Any, index:Int, src:ZSAikanParserModel)->ZSBookChapter {
        let parse = AikanHtmlParser()
        var chapterUrl = parse.string(withGumboNode: node, withAikanString: src.chapterUrl, withText: false)
        chapterUrl = chapterUrl.schemeURLString(src.host)
        let chapterName = parse.string(withGumboNode: node, withAikanString: src.chapterName, withText: true)
        let info:ZSBookChapter = ZSBookChapter()
        info.chapterUrl = chapterUrl
        info.chapterName = chapterName
        info.chapterIndex = index
        return info
    }
    
    func getDetailChapters(chaptersUrl:String, bookUrl:String, src:ZSAikanParserModel, handler:@escaping ZSBaseCallback<[ZSBookChapter]>) {
        NET.requestData(url: chaptersUrl) { [weak self](data) in
            guard let strongSelf = self else { return }
            guard let responseData = data else { return }
            let htmlString = String(data: responseData, encoding: String.Encoding.zs_encoding(str: src.searchEncoding)) ?? ""
            guard let document = OCGumboDocument(htmlString: htmlString) else { return }
            let parse = AikanHtmlParser()
            let chalters = parse.elementArray(with: document, withRegexString: src.chapters)
            var chaptersArr:[ZSBookChapter] = []
            for node in chalters {
                autoreleasepool {
                    let index = chalters.index(of: node)
                    var chapterUrl = parse.string(withGumboNode: node, withAikanString: src.chapterUrl, withText: false)
                    let chapterTitle = parse.string(withGumboNode: node, withAikanString: src.chapterName, withText: true)
                    chapterUrl = chapterUrl.schemeURLString(src.host)
                    let info:ZSBookChapter = ZSBookChapter()
                    info.chapterUrl = chapterUrl
                    info.chapterName = chapterTitle
                    info.chapterIndex = index
                    info.bookUrl = bookUrl
                    chaptersArr.append(info)
                }
            }
            if !strongSelf.stopBooks {
                handler(chaptersArr)
            }
        }
    }
    
    private func contentTagRemove(string:String, reg:String, encoding:String) ->String {
        var resultString = string
        guard let data = reg.data(using: .utf8) else { return resultString }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [[String:Any]] else {
            return resultString
        }
        for regInfo in json {
            let noRegular = regInfo[bool:"noRegular"]
            let regString = regInfo[string:"reg"]
            if noRegular {
                resultString = resultString.replacingOccurrences(of: regString, with: "")
            } else {
                let reg = try? NSRegularExpression(pattern: regString, options: NSRegularExpression.Options.allowCommentsAndWhitespace)
                let subString = resultString.nsString.substring(with: NSMakeRange(0, resultString.nsString.length))
                print(subString)
                if let results = reg?.matches(in: resultString, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, resultString.nsString.length)) {
                    for result in results {
                        if let subString = resultString.substingInRange(result.range.location..<(result.range.location + result.range.length)) {
                            resultString = resultString.replacingOccurrences(of: subString, with: "")
                        }
                    }
                }
            }
        }
        return resultString
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


