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
    
    var searchHotwords:[ZSSearchHotwords] = [] { didSet {} }
    var hotword:[ZSHotWord] = []
    
    var source:[AikanParserModel] = []
    
    private var stopBooks:Bool = false

    init() {
        viewDidLoad = { [weak self] in
            self?.request()
        }
        let filePath = Bundle(for: ZSSearchBookViewModel.self).path(forResource: "HtmlParserModelData.dat", ofType: nil) ?? ""
        if let objs = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [AikanParserModel] {
            self.source = objs
        }
    }
    
    func stopRequestBooks() {
        stopBooks = true
    }
    
    func startRequestBooks() {
        stopBooks = false
    }
    
    func model(for row:Int) ->ZSHeaderSearch {
        let search = ZSHeaderSearch(type: .hot, items: searchHotwords as! [Any], height: 0, headerTitle: "搜索热词", headerDetail: "查看更多", headerIcon: "")
        return search
    }
    
    func height(for row:Int) ->CGFloat {
        if row == 0 {
            let marginX:CGFloat = 20
            let marginY:CGFloat = 15
            let cellHeight:CGFloat = 28
            let spaceX:CGFloat = 15
            let spaceY:CGFloat = 20
            var cellX = marginX
            var cellY = marginY
            var index = 0
            for hotword in searchHotwords {
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
                searchHotwords[index] = cell
                index += 1
            }
            return cellY + cellHeight + 55
        }
        return 100
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
            if bookAuthor.length == 0 && bookName.length == 0 {
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
            getChapter(src: src, bookUrl: bookUrl) { (chapters) in
                let book = AikanParserModel()
                book.bookAuthor = bookAuthor
                book.bookIcon = bookIcon
                book.bookName = bookName
                book.bookDesc = bookDesc
                book.bookUrl = bookUrl
                book.name = src.name
                book.chaptersModel = chapters
                completion(book)
            }
        }
    }
    
    private func getChapter(src:AikanParserModel, bookUrl:String, completion:@escaping(_ chapters:[[String:Any]])->Void) {
        var headers = SessionManager.defaultHTTPHeaders
        headers["User-Agent"] = YouShaQiUserAgent
        Alamofire.request(bookUrl, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseData { (data) in
            if let htmlData = data.data {
                let htmlString = String(data: htmlData, encoding: .utf8) ?? ""
                guard let document = OCGumboDocument(htmlString: htmlString) else { return }
                let reg = src.detailChaptersUrl
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
                        completion(chaptersArr)
                    }
                })
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
            completion()
        }
    }
}
