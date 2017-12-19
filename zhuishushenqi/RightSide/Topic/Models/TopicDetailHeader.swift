//
//  TopicDetailHeader.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/3/10.
//  Copyright © 2017年 QS. All rights reserved.
//

//bookList": {
//"_id": "58ba10c10a121c9755fc7d4d",
//"updated": "2017-03-04T00:56:34.011Z",
//"title": "【女频】BOSS攻略最TOP",
//"author": {
//    "_id": "56c86c06e8a5daac0aa25819",
//    "avatar": "/avatar/db/4e/db4e2af927b6f744b75268982afd5acd",
//    "nickname": "桑桑（燃桑）",
//    "type": "author",
//    "lv": 8
//},
//"desc": "渣文虐我，推几本男女主不小白，剧情不狗血，文笔不弱智，有深度的爽文，双洁1V1，总裁深深宠，女主虐渣渣，一起爽歪歪~\r\n\r\n主推总裁高干",
//"gender": "female",
//"created": "2017-03-04T00:56:33.996Z",
//"tags": ["豪门世家", "现代言情", "总裁"],
//"stickStopTime": null,
//"isDraft": false,
//"isDistillate": true,
//"collectorCount": 703,
import UIKit

@objc(TopicDetailHeader)
class TopicDetailHeader: NSObject {
    var _id:String = ""
    var updated:String = ""
    var title:String = ""
    var author:TopicDetailAuthor = TopicDetailAuthor()
    var desc:String = ""{
        didSet{
            let width = UIScreen.main.bounds.width
            let height =  desc.qs_height(13, width: width - 22)
            descHeight = height
        }
    }
    var gender:String = ""
    var created:String = ""
    var tags:NSArray = [String]() as NSArray
    var stickStopTime:String = ""
    var isDraft:Bool = false
    var isDistillate:Bool = false
    var collectorCount:Int = 0
    
    var descHeight:CGFloat = 0.0
    
    class func modelCustomPropertyMapper() ->NSDictionary{
        return ["_id":"_id","updated":"updated","title":"title","author":"author","desc":"desc","gender":"gender","created":"created","tags":"tags","stickStopTime":"stickStopTime","isDraft":"isDraft","isDistillate":"isDistillate","collectorCount":"collectorCount"]
    }
}
@objc(TopicDetailAuthor)
class TopicDetailAuthor: NSObject {
    var _id:String = ""
    var avatar:String = ""
    var nickname:String = ""
    var type:String = ""
    var lv:Int = 0
    
    class func modelCustomPropertyMapper() ->NSDictionary{
        return ["_id":"_id","avatar":"avatar","nickname":"nickname","type":"type","lv":"lv"]
    }
    
}
