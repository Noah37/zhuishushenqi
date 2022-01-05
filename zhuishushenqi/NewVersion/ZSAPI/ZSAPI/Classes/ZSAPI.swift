//
//  QSAPI.swift
//  zhuishushenqi
//
//  Created by yung on 2017/6/29.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit

public protocol ZSTargetType {
    var baseURLString:String { get }
    var path:String { get }
    var parameters:[String:Any]? { get }
}

public enum ZSBaseType {
    case normal
    case chapter
}

public enum ZSAPI {
    ///首次进入根据性别推荐书籍
    case genderRecommend(gender:String)
    ///追书书架信息
    case shelfMSG(_ placeHolder:AnyObject)
    ///书架更新信息
    case update(id:String)
    ///热门搜索
    case hotwords(_ placeHolder:AnyObject)
    ///搜索热词
    case searchHotwords(_ placeHolder:AnyObject)
    ///联想搜索
    case autoComplete(query:String)
    ///搜索书籍
    case searchBook(id:String,start:String,limit:String)
    ///排行榜
    case ranking(_ placeHolder:AnyObject)
    ///榜单数据
    case rankList(id:String)
    ///分类
    case category(_ placeHolder:AnyObject)
    ///分类详细
    case categoryList(gender:String,type:String,major:String,minor:String,start:String,limit:String)
    ///tag过滤
    case tagType(_ placeHolder:AnyObject)
    ///主题书单
    case themeTopic(sort:String,duration:String,start:String,gender:String,tag:String)
    ///主题书单详细
    case themeDetail(key:String)
    ///热门评论
    case hotComment(key:String)
    ///普通评论
    case normalComment(key:String,start:String,limit:String)
    ///热门动态
    case hotUser(key:String)
    ///都是热门，忘记干嘛的了
    case hotPost(key:String,start:String,limit:String)
    ///评论详情
    case commentDetail(key:String)
    ///社区
    case community(key:String,start:String)
    ///社区评论
    case communityComment(key:String,start:String)
    ///所有来源
    case allResource(key:String)
    ///所有章节
    case allChapters(key:String)
    ///某一章节
    case chapter(key:String,type:ZSBaseType)
    ///书籍信息
    case book(key:String)
    ///详情页热门评论
    case bookHot(key:String)
    ///详情页可能感兴趣
    case interested(key:String)
    ///详情页推荐书单
    case recommend(key:String)
    //随机看书
    case mysteryBook(_ placeHolder:AnyObject)
    ///登录
    case login(idfa:String,platform_code:String,platform_token:String,platform_uid:String,version:String,tag:String)
    ///账户信息
    case account(token:String)
    ///金币信息
    case golden(token:String)
    ///账户详情
    case userDetail(token:String)
    ///个人信息绑定账户
    case userBind(token:String)
    ///退出登录
    case logout(token:String)
    ///书架列表
    case bookshelf(token:String)
    ///获取手机验证码
    case SMSCode(mobile:String,Randstr:String,Ticket:String,captchaType:String,type:String)
    ///手机号登录
    case mobileLogin(mobile:String,idfa:String,platform_code:String,smsCode:String,version:String)
    ///书架书籍删除
    case booksheldDelete(books:String, token:String)
    ///书架书籍添加
    case bookshelfAdd(books:String,token:String)
    ///用户昵称修改
    case nicknameChange(nickname:String,token:String)
    ///
    case blessing_bag(token:String)
    ///查询活动
    case judgeSignIn(token:String)
    ///签到领金币
    case signIn(token:String,activityId:String,version:String,type:String)
    ///编写评论
    case reviewPost(token:String,id:String,content:String)
    ///已购章节信息
    case boughtChapters(id:String,token:String)
    ///书架信息diff
    case bookshelfdiff(books:String,token:String)
    ///追书券列表
    case voucherList(token:String, type:String, start:Int, limit:Int)
    ///有声书分类列表
    //    case voiceCategory()
    //    https://apidian2.lnk.la/system/rule?type=test&version=not_found&juhe=1
    // 第三方书籍来源接口
    case thirdPartSource(type:String, version:String,juhe:Int)
    // 社区
    case userTwitter(_ last:String)
    // 关注
    case userFollowings(_ id:String)
    // 粉丝
    case userFollowers(_ id:String)
    // 社区用户动态
    case userTwitters(_ id:String, last:String)
    // 关注用户
    case focus(token:String, followeeId:String)
    // 取消关注
    case unFocus(token:String, followeeId:String)
    // 通知阅读
    case readImportant(token:String)
    // 重要通知
    case important(token:String)
    // 不重要通知阅读
    case readUnimportant(token:String)
    // 不重要通知
    case unimportant(token:String)
    // 社区tweet详情
    case post(key:String)
    // 新版社区
    case communityHot(start:Int, limit:Int)
    // 社区回复
    case bookAidAnswer(key:String)
    // 热评
    case bookAidBestComment(key:String)
    // 一般评价
    case bookAidComments(key:String)
    // 社区提问
    case bookAidQuestion(key:String)
    // 社区书籍
    case forumBook(key:String)
    // 精确搜索
    case accurateSearch(author:String, key:String, userId:String)
    // 详情推荐
    case bookRecommend(key:String, position:String, ts:Double)
    // 章节内容
    case chapterContent(key:String, token:String, thirdToken:String)
//http://bookapi01.zhuishushenqi.com/book/crypto/chapterContent/5ec241a4f4fdb43320c34521?token=&third-token=0e05f2d6a4e2080EB811f1DA087eE362%3A75616d677637696a616a62627045d0b944fd1fa0ab281b3ce8f71eb65ae1ac96a6fbfe28829107b72e07c7f46375b7
}
//https://api.ximalaya.com/openapi-gateway-app/v2/albums/list?access_token=906bbf257eddd7ba84ceec277bdef5b5&app_key=e31646fa4555ea3472d4114921ee192e&client_os_type=1&device=iPhone&device_id=F6F542A1-1676-4D28-96C2-CF9D2F52F5FD&pack_id=com.ifmoc.ZhuiShuShenQi&sdk_version=5.4.7&calc_dimension=1&category_id=3&count=20&page=1&tag_name=%E8%A8%80%E6%83%85&type=0&sig=8db40bb73de647a3baba9afb4635eb8e&

extension ZSAPI:ZSTargetType{
    public var path: String {
        var pathComponent = ""
        switch self {
        case .genderRecommend(_):
            pathComponent = "/book/recommend"
            break
        case .shelfMSG(_):
            pathComponent = "/notification/shelfMessage"
            break
        case .update(_):
            pathComponent = "/book"
            break
        case .hotwords(_):
            pathComponent = "/book/hot-word"
            break
        case .searchHotwords(_):
            pathComponent = "/book/search-hotwords"
            break
        case .autoComplete(_):
            pathComponent = "/book/auto-complete"
            break
        case .searchBook(_,_,_):
            pathComponent = "/book/fuzzy-search"
            break
        case .ranking(_):
            pathComponent = "/ranking/gender"
            break
        case let .rankList(id):
            pathComponent = "/ranking/\(id)"
            break
        case .category(_):
            pathComponent = "/cats/lv2/statistics"
            break
        case .categoryList(_,_,_,_,_,_):
            pathComponent = "/book/by-categories"
            break
        case .tagType(_):
            pathComponent = "/book-list/tagType"
            break
        case .themeTopic(_,_,_,_,_):
            pathComponent = "/book-list"
            break
        case let .themeDetail(key):
            pathComponent = "/book-list/\(key)"
            break
        case let .hotComment(key):
            pathComponent = "/post/\(key)/comment/best"
            break
        case let .normalComment(key,_,_):
            pathComponent = "/post/review/\(key)/comment"
            break
        case let .hotUser(key):
            pathComponent = "/user/twitter/\(key)/comments"
            break
        case let .hotPost(key,_,_):
            pathComponent = "/post/\(key)/comment"
            break
        case let .commentDetail(key):
            pathComponent = "/post/review/\(key)"
            break
        case let .community(key,start):
            pathComponent = "/post/by-book?book=\(key)&sort=updated&type=normal,vote&start=\(start)&limit=20"
            break
        case let .communityComment(key, start):
            pathComponent = "/post/review/by-book?book=\(key)&sort=updated&start=\(start)&limit=20"
            break
        case .allResource(_):
            pathComponent = "/toc"
            break
        case let .allChapters(key):
            pathComponent = "/toc/\(key)"
            break
        case let .chapter(key,_):
            pathComponent = "/\(key)?k=22870c026d978c75&t=1489933049"
            break
        case let .book(key):
            pathComponent = "/book/\(key)"
            break
        case let .bookHot(key):
            pathComponent = "/post/review/best-by-book?book=\(key)"
            break
        case let .interested(key):
            pathComponent = "/book/\(key)/recommend"
            break
        case let .recommend(key):
            pathComponent = "/book-list/\(key)/recommend?limit=3"
            break
        case .mysteryBook(_):
            pathComponent = "/book/mystery-box"
            break
        case .login(_,_,_,_,_,_):
            pathComponent = "/user/login"
            break
        case .account(_):
            pathComponent = "/user/account"
            break
        case .golden(_):
            pathComponent = "/account"
            break
        case .userDetail(_):
            pathComponent = "/user/detail-info"
            break
        case .userBind(_):
            pathComponent = "/user/loginBind"
            break
        case .logout(_):
            pathComponent = "/user/logout"
            break
        case .bookshelf(_):
            pathComponent = "/v3/user/bookshelf"
            break
        case .SMSCode(_, _, _, _, _):
            pathComponent = "/v2/sms/sendSms"
            break
        case .mobileLogin(_, _, _, _, _):
            pathComponent = "/user/login"
            break
        case .booksheldDelete(_, _):
            pathComponent = "/v3/user/bookshelf"
            break
        case .bookshelfAdd(_, _):
            pathComponent = "/v3/user/bookshelf"
            break
        case .nicknameChange(_, _):
            pathComponent = "/user/change-nickname"
            break
        case let .blessing_bag(token):
            //            https://goldcoin.zhuishushenqi.com/tasks/blessing-bag/detail?token=WupdmBZpkuzehCqdtDZF9IJR
            pathComponent = "/tasks/blessing-bag/detail?token=\(token)"
            break
        //    https://api.zhuishushenqi.com/user/v2/judgeSignIn?token=Abrv3NbHCuKKJSVzeSglLXns
        case .judgeSignIn(_):
            pathComponent = "/user/v2/judgeSignIn"
            break
        //    https://api.zhuishushenqi.com/user/signIn?token=Abrv3NbHCuKKJSVzeSglLXns&activityId=57eb9278b7b0f6fc1f2e1bc0&version=2&type=2
        case .signIn(_, _, _, _):
            pathComponent = "/user/signIn"
            break
        case let .reviewPost(_,id,_):
            //        https://api.zhuishushenqi.com/post/review/5be2ac16f6459891448e9b46/comment
            pathComponent = "/post/review/\(id)/comment"
            break
        case let .boughtChapters(id,_):
            //    https://api.zhuishushenqi.com/v2/purchase/book/5b10fd1b5d144d1b68581805/chapters/bought?token=rPcCW1GGh1hFPnSRJDjkwjtS
            pathComponent = "/v2/purchase/book/\(id)/chapters/bought"
            break
        case .bookshelfdiff(_, _):
            //            https://api.zhuishushenqi.com/v3/user/bookshelf/diff
            pathComponent = "/v3/user/bookshelf/diff"
            break
        case .voucherList(_, _, _, _):
            pathComponent = "/voucher"
            break
        case .thirdPartSource(_, _, _):
            pathComponent = "/system/rule"
            break
        case .userTwitter(_):
            pathComponent = "/user/twitter/hottweets"
            break
        case let .userFollowings(id):
            pathComponent = "/user/followings/\(id)"
            break
        case let .userFollowers(id):
            pathComponent = "/user/followers/\(id)"
            break
        case let .userTwitters(id, _):
            pathComponent = "/user/\(id)/twitter"
            break
        case .focus(_, _):
            pathComponent = "/user/follow"
            break
        case .unFocus(_, _):
            pathComponent = "/user/unfollow"
            break
        case .readImportant(_):
            pathComponent = "/user/notification/read-important"
            break
        case .important(_):
            pathComponent = "/user/notification/important"
            break
        case .readImportant(_):
            pathComponent = "/user/notification/read-unimportant"
            break
        case .unimportant(_):
            pathComponent = "/user/notification/unimportant"
            break
        case let .post(key):
            pathComponent = "/post/\(key)?keepImage=1"
            break
        case let .communityHot(_, _):
        //http://community.zhuishushenqi.com/community/hots?start=20&limit=20&group=-1
            pathComponent = "/community/hots"
            break
        case let .bookAidAnswer(key):
//        https://community.zhuishushenqi.com/bookAid/answer/61d51a802c4c7a0001fb6530
            pathComponent = "/bookAid/answer/\(key)"
            break
        case let .bookAidBestComment(key):
//        https://community.zhuishushenqi.com/bookAid/answer/61d51a802c4c7a0001fb6530/bestComments
            pathComponent = "/bookAid/answer/\(key)/bestComments"
            break
        case let .bookAidComments(key):
//        https://community.zhuishushenqi.com/bookAid/answer/61af751d2c4c7a0001fb52ca/comments
            pathComponent = "/bookAid/answer/\(key)/comments"
            break
        case let .bookAidQuestion(key):
//        https://community.zhuishushenqi.com/bookAid/question/61d3c9e82c4c7a0001fb6496?token=&packageName=com.ifmoc.ZhuiShuShenQi
            pathComponent = "/bookAid/question/\(key)?token=&packageName=com.ifmoc.ZhuiShuShenQi"
            break
        case let .forumBook(key):
//        http://community.zhuishushenqi.com/forum/book/5ec241a4f4fdb43320c34521/hot?block=all_review
            pathComponent = "/forum/book/\(key)/hot?block=all_review"
            break
        case let.accurateSearch(author, key, userId):
//        http://b.zhuishushenqi.com/books/accurate-search-author?author=%E5%86%99%E7%A6%BB%E5%A3%B0&packageName=com.ifmoc.ZhuiShuShenQi&bookId=5ec241a4f4fdb43320c34521&userid=yk_ff4ef77e9f4b19f3281bb
            pathComponent = "/books/accurate-search-author"
            break
        case let .bookRecommend(key, position, ts):
//        http://b.zhuishushenqi.com/book/5ec241a4f4fdb43320c34521/recommend?packageName=com.ifmoc.ZhuiShuShenQi&position=detail&ts=1641396502
            pathComponent = "/book/\(key)/recommend"
            break
        case let .chapterContent(key, token, thirdToken):
            //http://bookapi01.zhuishushenqi.com/book/crypto/chapterContent/5ec241a4f4fdb43320c34521?token=&third-token=0e05f2d6a4e2080EB811f1DA087eE362%3A75616d677637696a616a62627045d0b944fd1fa0ab281b3ce8f71eb65ae1ac96a6fbfe28829107b72e07c7f46375b7
            pathComponent = "/book/crypto/chapterContent/\(key)"
            break
        default:
            pathComponent = ""
            break
        }
        return "\(baseURLString)\(pathComponent)"
    }
    
    public var baseURLString: String{
        var urlString = "http://api.zhuishushenqi.com"
        switch self {
        case let .chapter(_, type):
            switch type {
            case .chapter:
                urlString = "http://chapter2.zhuishushenqi.com/chapter"
            default:
                urlString = "http://api.zhuishushenqi.com"
            }
        case .golden(_):
            urlString = "http://goldcoin.zhuishushenqi.com"
        case .blessing_bag(_):
            urlString = "https://goldcoin.zhuishushenqi.com"
        case .thirdPartSource(_, _, _):
            urlString = "https://apidian2.lnk.la"
        case .readImportant(_):
            urlString = "https://api.zhuishushenqi.com"
        case .important(_):
            urlString = "https://api.zhuishushenqi.com"
        case .communityHot(_, _):
            urlString = "http://community.zhuishushenqi.com"
        case .bookAidAnswer(_):
            urlString = "https://community.zhuishushenqi.com"
        case .bookAidBestComment(_):
            urlString = "https://community.zhuishushenqi.com"
        case .bookAidComments(_):
            urlString = "https://community.zhuishushenqi.com"
        case .bookAidQuestion(_):
            urlString = "https://community.zhuishushenqi.com"
        case .forumBook(_):
            urlString = "http://community.zhuishushenqi.com"
        case .accurateSearch(_, _, _):
            urlString = "http://b.zhuishushenqi.com"
        case .bookRecommend(_, _, _):
            urlString = "http://b.zhuishushenqi.com"
        case .chapterContent(_, _, _):
            urlString = "http://bookapi.zhuishushenqi.com"
        default:
            urlString = "http://api.zhuishushenqi.com"
        }
        return urlString
    }
    
    public var parameters: [String : Any]?{
        switch self {
        case let .genderRecommend(gender):
            return ["gender":gender]
        case let .update(id):
            return ["view":"updated","id":id]
        case let .autoComplete(query):
            return ["query":query]
        case let .searchBook(id,start,limit):
            return ["query":id,"start":start,"limit":limit]
        case .shelfMSG(_):
            return ["platform":"ios"]
        case let .categoryList(gender,type,major,minor,start,limit):
            return ["gender":gender,"type":type,"major":major,"minor":minor,"start":start,"limit":limit]
        case let .themeTopic(sort,duration,start,gender,tag):
            return ["sort":sort,"duration":duration,"start":start,"gender":gender,"tag":tag]
        case let .normalComment(_,start,limit):
            return ["start":start,"limit":limit]
        case let .hotPost(_,start,limit):
            return ["start":start,"limit":limit]
        case let .allResource(key):
            return ["view":"summary","book":key]
        case .allChapters(_):
            return ["view":"chapters"]
        case let .login(idfa, platform_code, platform_token, platform_uid, version, tag):
            return ["idfa":idfa,
                    "platform_code":platform_code,
                    "platform_token":platform_token,
                    "platform_uid":platform_uid,
                    "version":version,
                    "tag":tag]
        case let .account(token):
            return ["token":token]
        case let .golden(token):
            return ["token":token]
        case let .userDetail(token):
            return ["token":token]
        case let .userBind(token):
            return ["token":token]
        case let .logout(token):
            return ["token":token]
        case let .bookshelf(token):
            return ["token":token]
        case let .SMSCode(mobile,Randstr,Ticket,captchaType,type):
            return ["mobile":mobile,
                    "Randstr":Randstr,
                    "Ticket":Ticket,
                    "captchaType":captchaType,
                    "type":type]
        case let .mobileLogin(mobile, idfa, platform_code, smsCode, version):
            return ["mobile":mobile,
                    "idfa":idfa,
                    "platform_code":platform_code,
                    "smsCode":smsCode,
                    "version":version]
        case let .booksheldDelete(books, token):
            return ["books":books,
                    "token":token]
        case let .bookshelfAdd(books, token):
            return ["books":books,
                    "token":token]
        case let .nicknameChange(nickname,token):
            return ["nickname":nickname,
                    "token":token]
        case let .judgeSignIn(token):
            return ["token":token]
        case let .signIn(token, activityId, version, type):
            return ["token": token,
                    "activityId": activityId,
                    "version": version,
                    "type": type]
        case let .reviewPost(token, _, content):
            return ["token":token,
                    "content":content]
        case let .boughtChapters(_, token):
            return ["token":token,
            ]
        case let .bookshelfdiff(books, token):
            return ["books":books,
                    "token":token]
        case let .voucherList(token, type, start, limit):
            return ["token":token,
                    "type":"\(type)",
                "start":"\(start)",
                "limit":"\(limit)"]
        case let .thirdPartSource(type, version, juhe):
            return ["type":type,
                    "version":version,
                    "juhe":"\(juhe)"]
        case let .userTwitter(last):
            if last.count == 0 {
                return nil
            }
            return ["last":last]
        case let .userTwitters(_, last):
            if last.count == 0 {
                return nil
            }
            return ["last":last]
        case let .focus(token, followeeId):
            return ["token":"\(token)",
                "followeeId":"\(followeeId)"]
        case let .unFocus(token, followeeId):
            return ["token":"\(token)",
                "followeeId":"\(followeeId)"]
        case let .readImportant(token):
            return ["token":"\(token)"]
        case let .important(token):
            return ["token":"\(token)"]
        case let .readUnimportant(token):
            return ["token":"\(token)"]
        case let .unimportant(token):
            return ["token":"\(token)"]
        case let .communityHot(start, limit):
            return ["start":start,
                    "limit":limit,
                    "group":-1]
        case .bookAidAnswer(_):
            return nil
        case .bookAidBestComment(_):
            return nil
        case .bookAidComments(_):
            return nil
        case .bookAidQuestion(_):
            return nil
        case let .accurateSearch(author, key, userId):
            return [
                "author":"\(author)",
                "bookId":"\(key)",
                "userid":"\(userId)",
                "packageName":"com.ifmoc.ZhuiShuShenQi"
            ]
        case let .bookRecommend(key, position, ts):
            return [
                "ts":"\(ts)",
                "position":"\(position)",
                "packageName":"com.ifmoc.ZhuiShuShenQi"
            ]
        case let .chapterContent(key, token, thirdToken):
            return [
                "token":"\(token)",
                "third-token":"\(thirdToken)"
            ]
        default:
            return nil
        }
    }
}

//https://api.zhuishushenqi.com/v3/user/bookshelf?token=oRSd5bVUCpSunbwiKe5NOpOM
//https://api.zhuishushenqi.com/v2/purchase/book/5b10fd1b5d144d1b68581805/chapters/bought?token=rPcCW1GGh1hFPnSRJDjkwjtS
