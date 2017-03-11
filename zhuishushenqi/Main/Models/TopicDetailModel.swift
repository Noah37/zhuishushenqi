//
//  TopicDetailModel.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2017/3/9.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit

@objc(TopicDetailModel)
class TopicDetailModel: NSObject {

    var book:TopicDetailBook = TopicDetailBook()
    var comment:String = "" {
        didSet{
            let width = UIScreen.main.bounds.width - 46
            let height = heightOfString(comment, font: UIFont.systemFont(ofSize: 11), width: width)
            self.commentHeight = height + 15
        }
    }
    var commentHeight:CGFloat = 0.0

    
    class func modelCustomPropertyMapper() ->NSDictionary{
        return ["book":"book","comment":"comment"]
    }

}

@objc(TopicDetailBook)
class TopicDetailBook: NSObject {
    var book:String = ""
    var _id:String = ""
    var author:String = ""
    var cover:String = ""
    var longIntro:String = ""
    var title:String = ""
    var site:String = ""
    var cat:String = ""
    var majorCate:String = ""
    var minorCate:String = ""
    var banned:Int  = 0
    var latelyFollower:Int = 0
    var latelyFollowerBase:Int = 0
    var wordCount:Int = 0
    var minRetentionRatio:Int = 0
    var retentionRatio:Float = 0.0
    
    class func modelCustomPropertyMapper() ->NSDictionary{
        return ["book":"book","_id":"_id","author":"author","cover":"cover","longIntro":"longIntro","title":"title","site":"site","cat":"cat","majorCate":"majorCate","minorCate":"minorCate","banned":"banned","latelyFollower":"latelyFollower","latelyFollowerBase":"latelyFollowerBase","wordCount":"wordCount","minRetentionRatio":"minRetentionRatio","retentionRatio":"retentionRatio"]
    }
}

//    "book": {
//    "_id": "50adada05da9cfc66300007a",
//    "author": "黄金战士",
//    "cover": "/agent/http://image.cmfu.com/books/1321240/1321240.jpg",
//    "longIntro": "重生不可怕，就怕重生妖孽化。
//    林风重生回到1999年，这一年，网络和电子商务刚刚兴起，网络游戏逐渐进入玩家眼界。而林风的重生人生，将从打造他的游戏帝国开始。
//    《传奇》在他手中成为真正的传奇，收购3DO，吞并暴雪，强购“KONAMI”，让“第二世界”成为世界最火爆的游戏公司。
//    再踏足英超，和切尔西比富，和曼城比有钱，打造全新的《冠军教父》。
//    而这只是林风妖孽人生的开始...
//    ",
//    "title": "重生之妖孽人生",
//    "site": "zhuishuvip",
//    "cat": "都市",
//    "majorCate": "都市",
//    "minorCate": "都市生活",
//    "banned": 0,
//    "latelyFollower": 8561,
//    "latelyFollowerBase": 0,
//    "wordCount": 22731216,
//    "minRetentionRatio": 0,
//    "retentionRatio": 45.96
//},
//"comment": "其实我在14年就知道唐纳德要当总统，别问我为什么，我不会告诉你是在那时候看了这本书，作者预言帝不解释"
