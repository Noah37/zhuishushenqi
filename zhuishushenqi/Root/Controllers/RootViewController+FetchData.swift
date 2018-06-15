//
//  RootViewController+FetchData.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/3/19.
//  Copyright © 2017年 QS. All rights reserved.
//

import Foundation
import QSNetwork

extension RootViewController{
    
    func requetShelfMsg(){
        autoreleasepool {
            self.bookShelfLB.text = USER_DEFAULTS.object(forKey: PostLink) as? String ?? ""
            let shelfApi = QSAPI.shelfMSG()
            QSNetwork.request(shelfApi.path, method: HTTPMethodType.get, parameters: shelfApi.parameters, headers: nil) { (response) in
                if let json = response.json {
                    let message = json["message"] as? NSDictionary
                    if let msg = message{
                        let postLink = msg.object(forKey: "postLink") as? String
                        if let highlight = msg.object(forKey: "highlight") as? Bool {
                            if highlight {
                                self.bookShelfLB.textColor = UIColor.red
                            } else {
                                self.bookShelfLB.textColor = UIColor.gray
                            }
                        }
                        let post = self.getPost(postLink)
                        USER_DEFAULTS.set(post.1, forKey: PostLink)
                        self.bookShelfLB.attributedText = NSAttributedString(string: "\(post.1)")
                    }
                }
            }
        }
    }
    
    func requestBookShelf(){
        //已登录状态的书架
        
        //未登录中状态下，图书的信息保存在userdefault中
        if !User.user.isLogin {
            self.bookshelf = BookManager.shared.books
            self.books = BookManager.shared.bookshelf()
            let url:NSString = "http://www.luoqiu.com/read/175859"
            QSLog(url.lastPathComponent)
            QSLog(url.deletingLastPathComponent)
            QSLog(url.pathComponents)
            QSLog(url.pathExtension)
            if url.pathExtension == "" {
                QSLog(url.pathExtension)
            }
        }
    }
    
    //匹配当前书籍的更新信息
    func updateInfo(){
        guard self.bookshelf != nil else {
            return
        }
        let ids = self.booksID(books: self.bookshelf)
        
        let api = QSAPI.update(id: ids)
        QSNetwork.request(api.path, method: HTTPMethodType.get, parameters: api.parameters, headers: nil) { (response) in
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            // 防止返回时卡顿，采用子线程
            DispatchQueue.global().async {
                if let json:[Any] = response.json as? [Any] {
                    if let models = [UpdateInfo].deserialize(from: json) as? [UpdateInfo] {
                        BookManager.shared.updateToModel(updateModels: models)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func isUpdated(update:UpdateInfo,book:BookDetail)->Bool{
        if (update.updated ?? "1") != (book.updateInfo?.updated ?? "2") {
            return true
        }
        return false
    }
    
    func requestAllChapters(withUrl url:String,param:[String:Any],index:Int){
        self.present(QSTextRouter.createModule(bookDetail:self.bookShelfArr![index],callback: {(book:BookDetail) in
            
        }), animated: true, completion: nil)
    }
    
    func booksID(books:[String:Any]?)->String{
        if let keys = books{
            var ids = ""
            for book in keys.keys {
                if ids != "" {
                    ids.append(",")
                }
                ids.append(book)
            }
            
            return ids
        }
        return ""
    }
    
    func param(bookArr:[BookDetail])->String{
        var idString = ""
        var index = 0
        for item in bookArr {
            idString = idString.appending(item._id)
            if index != bookArr.count - 1 {
                idString = idString.appending(",")
            }
            index += 1
        }
        return idString
    }
    
    func getPost(_ postLink:String?) ->(String,String){
        var id:String = ""
        var title:String = ""
        if let link =  postLink {
            // 此处如果过滤方式不正确，则返回空,按中文【 开头，]]结尾
            let qsLink:NSString = link as NSString
            let startRange = qsLink.range(of: "【")
            let endRange = qsLink.range(of: "]]")
            let endContainRange = qsLink.range(of: "]]]")
            let post = qsLink.range(of: "post:")
            if startRange.location == NSNotFound {
                if endRange.location != NSNotFound {
                    if qsLink.length > 32 {
                        // 过滤方式变更
                        title = link.qs_subStr(start: 32, end: endRange.location)
                        id = link.qs_subStr(start: 7, length: 24)
                    }
                }
                return (id,title)
            }
            title = link.qs_subStr(start: startRange.location, end: endRange.location)
            if endContainRange.location != NSNotFound {
                title = link.qs_subStr(start: startRange.location, end: endContainRange.location - 1)
            }
            if post.location == NSNotFound {
                return (id,title)
            }
            id = link.qs_subStr(start: post.location + post.length, end: startRange.location)
            return (id,title)
        }
        return (id,title)
    }
    
    func setupReachability(_ hostName: String?, useClosures: Bool) {
        
        let reachability = hostName == nil ? Reachability() : Reachability(hostname: hostName!)
        self.reachability = reachability
        
        if useClosures {
            reachability?.whenReachable = { reachability in
                DispatchQueue.main.async {
                    self.hudAddTo(view: self.view, text: "网络已连接", animated: true)
                }
            }
            reachability?.whenUnreachable = { reachability in
                DispatchQueue.main.async {
                    self.hudAddTo(view: self.view, text: "网络未连接", animated: true)
                }
            }
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(_:)), name: ReachabilityChangedNotification, object: reachability)
        }
    }
    
    @objc func reachabilityChanged(_ no:Notification){
        let reachability = no.object as! Reachability
        DispatchQueue.main.async {
            self.typeOfNetwork(type: reachability.networkType)
        }
    }
    
    func typeOfNetwork(type:QSNetworkType){
        switch type {
        case .WWAN2G:
            hudAddTo(view: self.view, text: "当前为2G网络", animated: true)
            break
        case .WWAN3G:
            hudAddTo(view: self.view, text: "当前为3G网络", animated: true)
            break
        case .WWAN4G:
            hudAddTo(view: self.view, text: "当前为4G网络", animated: true)
            break
        case .WiFi:
            hudAddTo(view: self.view, text: "当前为WiFi网络", animated: true)
            break
        case .UnKnown:
            hudAddTo(view: self.view, text: "当前网络状态未知", animated: true)
            break
        default:
            hudAddTo(view: self.view, text: "当前网络不可达", animated: true)
            break
        }
    }
    
    func startNotifier() {
        print("--- start notifier")
        do {
            try reachability?.startNotifier()
        } catch {
            //            networkStatus.textColor = .red
            //            networkStatus.text = "Unable to start\nnotifier"
            return
        }
    }
    
    func stopNotifier() {
        print("--- stop notifier")
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: ReachabilityChangedNotification, object: nil)
        reachability = nil
    }
}
