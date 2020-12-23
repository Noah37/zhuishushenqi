//
//  ZSPostReview.swift
//  zhuishushenqi
//
//  Created by yung on 2019/8/7.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit
import HandyJSON

struct ZSPostReview:HandyJSON {

    var _id:String = ""
    var rating:Int = 0
    var type:String = ""
    var book:ZSPostReviewBook = ZSPostReviewBook()
    var author:ZSPostReviewAuthor = ZSPostReviewAuthor()
    var helpful:ZSPostReviewHelpful = ZSPostReviewHelpful(no: 0, total: 0, yes: 0)
    var state:String = ""
    var updated:String = ""
    var created:String = ""
    var commentCount:Int = 0
    var content:String = ""
    var title:String = ""
    var shareLink:String = ""
    var id:String = ""
}


//{
//    "review": {
//        "_id": "5d47f6c109fdcf734ec03ec3",
//        "rating": 3,
//        "type": "review",
//        "book": {
//            "_id": "58c8b41a08eed7c070137872",
//            "author": "薄凉君子",
//            "title": "独步惊华，腹黑嫡女御天下",
//            "cover": "/agent/http%3A%2F%2Fimg.1391.com%2Fapi%2Fv1%2Fbookcenter%2Fcover%2F1%2F2066474%2F2066474_c1b2752e5649449c9a341556542dbfce.jpg%2F",
//            "safelevel": 5,
//            "allowFree": true,
//            "apptype": [0, 1, 2, 4, 6],
//            "id": "58c8b41a08eed7c070137872",
//            "latelyFollower": null,
//            "retentionRatio": null
//        },
//        "author": {
//            "_id": "5cfa56b67a823add1cf3e377",
//            "avatar": "/avatar/cf/46/cf4682dccd69c381ce4ebf4abbb44f5f",
//            "nickname": "晨",
//            "activityAvatar": "",
//            "type": "normal",
//            "lv": 5,
//            "gender": "female",
//            "rank": null,
//            "created": "2019-06-07T12:21:10.000Z",
//            "id": "5cfa56b67a823add1cf3e377"
//        },
//        "helpful": {
//            "total": -1,
//            "no": 2,
//            "yes": 1
//        },
//        "state": "normal",
//        "updated": "2019-08-06T13:46:47.643Z",
//        "created": "2019-08-05T09:28:33.410Z",
//        "commentCount": 0,
//        "content": "故事情节不错，作者用词要斟酌下了，看了一点就明显，秀色可餐的食物，秀色可餐是用来形容好看的人。男主看着女主，想让女主放下伪装。。。前几个词都不错，但醉生梦死。。这真的适合形容他俩吗？                                                         \n                                                                                                                                                                                                                                                                                                                                                              😂",
//        "title": "加油加油",
//        "shareLink": "http://share.zhuishushenqi.com/post/5d47f6c109fdcf734ec03ec3",
//        "id": "5d47f6c109fdcf734ec03ec3"
//    },
//    "ok": true
//}
