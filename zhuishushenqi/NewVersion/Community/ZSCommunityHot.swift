//
//  ZSCommunityHot.swift
//  zhuishushenqi
//
//  Created by yung on 2022/1/6.
//  Copyright © 2022 QS. All rights reserved.
//

import Foundation
import HandyJSON


struct ZSCommunityHot : HandyJSON {

    var id : String = ""
    var author : ZSCommunityAuthor!
    var authorId : String = ""
    var block : String = ""
    var book : ZSCommunityBook!
    var bookCount : Int = 0
    var bookRecommend : Int = 0
    var commentCount : Int!
    var content : String = ""
    var created : String = ""
    var dataId : String = ""
    var from : String = ""
    var isLike : Bool = false
    var likeCount : Int = 0
    var readCount : Int = 0
    var title : String = ""
    var updated : String = ""
}

struct ZSCommunityBook : HandyJSON {

}

struct ZSCommunityAuthor : HandyJSON {

    var id : String = ""
    var avatar : String = ""
    var follower : Int = 0
    var following : Int = 0
    var gender : String = ""
    var isFollowing : Bool = false
    var lv : Int = 0
    var mobile : Int = 0
    var nickname : String = ""
    var type : String = ""

}
