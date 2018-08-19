//
//  BookComment.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/3/13.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit
import HandyJSON

@objc(BookComment)
class BookComment: NSObject,HandyJSON {
    
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
    
    required override init() {
        
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
class BookCommentAuthor: NSObject,HandyJSON {
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
    
    required override init() {
        
    }
}

@objc(BookCommentBook)
class BookCommentBook: NSObject,HandyJSON {
    var _id:String = "id"
    var cover:String = ""
    var title:String = ""
    var id:String = ""
    var type = ""
    
    required override init() {
        
    }
}
