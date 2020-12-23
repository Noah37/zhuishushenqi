//
//  ZSForumComment.swift
//  zhuishushenqi
//
//  Created by yung on 2019/8/12.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit
import HandyJSON

struct ZSForumComment: HandyJSON {
    
    var id : String = ""
    var author : ZSForumAuthor = ZSForumAuthor()
    var content : String = ""
    var created : String = ""
    var floor : Int = 0
    var likeCount : Int = 0
    var replyTo : AnyObject?
    
    init() {}
}

struct ZSForumAuthor: HandyJSON {
    
    var id : String = ""
    var activityAvatar : String = ""
    var avatar : String = ""
    var gender : String = ""
    var lv : Int = 0
    var nickname : String = ""
    var type : String = ""
    
    init() {}
}
