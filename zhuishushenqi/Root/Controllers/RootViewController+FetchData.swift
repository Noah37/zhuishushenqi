//
//  RootViewController+FetchData.swift
//  zhuishushenqi
//
//  Created by Nory Chao on 2017/3/19.
//  Copyright © 2017年 QS. All rights reserved.
//

import Foundation
import QSNetwork

extension RootViewController{
    
    func requetShelfMsg(){
//        http://api.zhuishushenqi.com/notification/shelfMessage?platform=ios
        let shelfUrl = "\(BASEURL)/notification/shelfMessage"
        QSNetwork.request(shelfUrl, method: HTTPMethodType.get, parameters: ["platform":"ios"], headers: nil) { (response) in
            if let _ = response.json {
                let message:AnyObject? = response.json?["message"] as AnyObject
                if message?.isKind(of: NSNull.self) == false {
                    let postLink = message?.object(forKey: "postLink")
                    self.bookShelfLB.text = "\(self.postLinkArchive(postLink as AnyObject?).1)"
                }
            }
        }
    }
    
    func requestBookShelf(){
        //已登录状态的书架
        
        //未登录中状态下，图书的信息保存在userdefault中
        if !User.user.isLogin {
            self.bookShelfArr = BookShelfInfo.books.bookShelf
            let url:NSString = "http://www.luoqiu.com/read/175859"
            QSLog(url.lastPathComponent)
            QSLog(url.deletingLastPathComponent)
            QSLog(url.pathComponents)
            QSLog(url.pathExtension)
            if url.pathExtension == "" {
                QSLog(url.pathExtension)
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //匹配当前书籍的更新信息
    func updateInfo(){
    //        http://api.zhuishushenqi.com/book?view=updated&id=5816b415b06d1d32157790b1,51d11e782de6405c45000068
        guard let update  = self.bookShelfArr else {
            return
        }
        let url = "\(BASEURL)/book"
        let ids = self.param(bookArr: update)
        let param = ["view":"updated","id":"\(ids)"]
        QSNetwork.request(url, method: HTTPMethodType.get, parameters: param, headers: nil) { (response) in
            if let json:[Any] = response.json as? [Any] {
                do{
                    self.updateInfoArr = try XYCBaseModel.model(withModleClass: UpdateInfo.self, withJsArray: json as [Any]!) as? [UpdateInfo]
                    guard let updateModels = self.updateInfoArr else {
                        return
                    }
                    self.updateToModel(updateModels: updateModels, bookShelfModels: update)
                }catch{
                    
                }
            }
        }
    }
    
    //需要将对应的update信息赋给model
    func updateToModel(updateModels:[UpdateInfo],bookShelfModels:[BookDetail]){
        for index in 0..<updateModels.count {
            let updateInfo = updateModels[index]
            for y in 0..<bookShelfModels.count {
                let bookShelf = bookShelfModels[y]
                if updateInfo._id == bookShelf._id {
                    bookShelf.updateInfo = updateInfo
                    var bookShelfs = bookShelfModels
                    bookShelfs[y] = bookShelf
                    self.bookShelfArr = bookShelfs
                    if let shelf = self.bookShelfArr {
                        BookShelfInfo.books.bookShelf = shelf
                    }
                }
            }
        }
        DispatchQueue.main.async {
            self.tableView.endAllRefreshing()
            self.tableView.reloadData()
        }
    }
    
    func requestAllChapters(withUrl url:String,param:[String:Any],index:Int){
        
        //先查询书籍来源，根据来源返回的id再查询所有章节
//        QSNetwork.request(url, method: HTTPMethodType.get, parameters: param, headers: nil) { (response) in
//            var res:[ResourceModel]?
//            if let resources = response.json  {
//                do{
//                    res = try XYCBaseModel.model(withModleClass: ResourceModel.self, withJsArray: resources as! [Any]) as? [ResourceModel]
//                }catch{
//                    QSLog(error)
//                }
//            }else{
//                res = [ResourceModel()]
//            }
//            if (res?.count ?? 0) > 0 {
                self.present(QSTextRouter.createModule(bookDetail:self.bookShelfArr![index]), animated: true, completion: nil)
//            }
//        }
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
    
    func postLinkArchive(_ postLink:AnyObject?) ->(String,String){
        return ("","")
        if postLink == nil{
            
        }
        let rangeRight = postLink?.range(of: "]]")
        let rangeBet = postLink?.range(of: ":")
        let rangeOfSpace = postLink?.range(of: "【")
        let urlLink = postLink?.substring(with: NSMakeRange(rangeBet!.location + 1, rangeOfSpace!.location - rangeBet!.location-1))
        let title = postLink?.substring(with: NSMakeRange(rangeOfSpace!.location, rangeRight!.location - rangeOfSpace!.location))
        return (urlLink!,title!)
    }
}
