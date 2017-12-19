//
//  BookComment.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/3/13.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit

@objc(BookComment)
class BookComment: NSObject {
    
    var _id:String = ""
    var content:String = ""{
        didSet{
            calContentHeight()
        }
    }
    var rating:Int = 1
    var title:String = "" {
        didSet{
            calTitleHeight()
        }
    }
    var type:String = ""
    var likeCount:Int = 0
    var state:String = ""
    var updated:String = ""
    var created:String = ""
    var commentCount:Int = 0
    var shareLink:String = ""
    var id:String = ""
    
    var titleHeight:CGFloat = 0
    var contentHeight:CGFloat = 0
    
    var author:BookCommentAuthor = BookCommentAuthor()
    var helpful:Helpful = Helpful()
    
    var book:BookCommentBook = BookCommentBook()
    
    class func modelCustomPropertyMapper() ->NSDictionary{
        return ["_id":"_id","content":"content","rating":"rating","title":"title","likeCount":"likeCount","state":"state","updated":"updated","created":"created","commentCount":"commentCount","author":"author","helpful":"helpful"]
    }
    
    func calTitleHeight(){
        DispatchQueue.global().async {
            let height = self.title.qs_height(13, width: UIScreen.main.bounds.width - 30)
            self.titleHeight = height
        }
    }
    
    func calContentHeight(){
        DispatchQueue.global().async {            
            let height = self.content.qs_height(13, width: UIScreen.main.bounds.width - 30)
            self.contentHeight = height
        }
    }
}

@objc(BookCommentAuthor)
class BookCommentAuthor: NSObject {
    var _id:String = ""
    var avatar:String = ""
    var nickname:String = ""
    var activityAvatar:String = ""
    var type:String = ""
    var lv:Int = 0
    var gender:String = ""
    var rank:String = ""
    var created:String = ""
    var id:String = ""
    
    class func modelCustomPropertyMapper() ->NSDictionary{
        return ["_id":"_id","avatar":"avatar","nickname":"nickname","activityAvatar":"activityAvatar","type":"type","lv":"lv","gender":"gender","rank":"rank","created":"created","id":"id"]
    }
}

@objc(BookCommentBook)
class BookCommentBook: NSObject {
    var _id:String = "id"
    var cover:String = ""
    var title:String = ""
    var id:String = ""
    
    class func modelCustomPropertyMapper() ->NSDictionary{
        return ["_id":"_id","cover":"cover","title":"title","id":"id"
        ]
    }
}
