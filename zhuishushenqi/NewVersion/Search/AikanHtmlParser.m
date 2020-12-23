//
//  AikanHtmlParser.m
//  CJDemo
//
//  Created by yung on 2019/10/15.
//  Copyright © 2019 cj. All rights reserved.
//

#import "AikanHtmlParser.h"


@implementation AikanHtmlParser

- (NSString *)stringWithGumboNode:(OCGumboNode *)arg1 withAikanString:(NSString *)arg2 withText:(_Bool)arg3 {
    if (arg2 && arg1) {
        NSArray * regs = [arg2 componentsSeparatedByString:@"@"];
        if (regs.count != 4) {
            return @"";
        }
        NSString * reg1 = [regs objectAtIndex:1];
        if (reg1.length) {
            OCQueryObject * obj = [self elementArrayWithGumboNode:arg1 withRegexString:reg1];
            if (obj.count) {
                NSString * reg2 = [regs objectAtIndex:2];
                NSInteger reg2IntValue = [reg2 integerValue];
                BOOL full;
                OCGumboNode * node;
                if (obj.count > reg2IntValue) {
                    full = YES;
                    node = [obj objectAtIndex:reg2IntValue];
                } else {
                    full = NO;
                }
                if (full) {
                    NSString * reg3 = [regs objectAtIndex:3];
                    if ([reg3 isEqualToString:@"own:"]) {
                        NSArray * text = node.Query(@"");
                        OCGumboNode * node = text.lastObject;
                        return node.text();
                    } else if (reg3.length >= 5) {
                        NSString * sub3 = [reg3 substringToIndex:4];
                        if ([sub3 isEqualToString:@"abs:"]) {
                            NSString * reg3Last = [reg3 substringFromIndex:4];
                            NSString * attr = node.attr(reg3Last);
                            if (attr) {
                                NSString * attrRe = [NSString stringWithFormat:@"%@",attr];
                                if ([attrRe isEqualToString:@"<null>"]) {
                                    return @"";
                                } else {
                                    return attrRe;
                                }
                            } else {
                                return @"";
                            }
                        }
                    } else if (reg3.length > 0) {
                        NSString * sub3 = [reg3 substringToIndex:1];
                        if ([sub3 isEqualToString:@":"]) {
                            NSString * text = node.text();
                            NSString * reg3Last = [reg3 substringFromIndex:1];
                            NSString * matchString = [self getMatchString:text regString:reg3Last];
                            return matchString;
                        } else {
                            NSString * attr = node.attr(sub3);
                            if (attr) {
                                NSString * attrRe = [NSString stringWithFormat:@"%@",attr];
                                if ([attrRe isEqualToString:@"<null>"]) {
                                    return @"";
                                } else {
                                    return attrRe;
                                }
                            } else {
                                return @"";
                            }
                        }
                    }
                    if (arg3) {
                        NSString * text = node.text();
                        if (!text) {
                            return @"";
                        }
                        NSString * attrRe = [NSString stringWithFormat:@"%@",text];
                        if ([attrRe isEqualToString:@"<null>"]) {
                            return @"";
                        } else {
                            return attrRe;
                        }
                    } else {
                        NSString * html = node.html();
                        if (!html) {
                            return @"";
                        }
                        NSString * attrRe = [NSString stringWithFormat:@"%@",html];
                        if ([attrRe isEqualToString:@"<null>"]) {
                            return @"";
                        } else {
                            return attrRe;
                        }
                    }
                }
            }
        } else {
            NSString * reg3 = [regs objectAtIndex:3];
            if ([reg3 isEqualToString:@"own:"]) {
                NSArray * text = arg1.Query(@"");
                OCGumboNode * node = text.lastObject;
                return node.text();
            } else if (reg3.length >= 5) {
                NSString * sub3 = [reg3 substringToIndex:4];
                if ([sub3 isEqualToString:@"abs:"]) {
                    NSString * reg3Last = [reg3 substringFromIndex:4];
                    NSString * attr = arg1.attr(reg3Last);
                    if (attr) {
                        NSString * attrRe = [NSString stringWithFormat:@"%@",attr];
                        if ([attrRe isEqualToString:@"<null>"]) {
                            return @"";
                        } else {
                            return attrRe;
                        }
                    } else {
                        return @"";
                    }
                }
            } else if (reg3.length > 0) {
                NSString * sub3 = [reg3 substringToIndex:1];
                if ([sub3 isEqualToString:@":"]) {
                    NSString * text = arg1.text();
                    NSString * reg3Last = [reg3 substringFromIndex:1];
                    NSString * matchString = [self getMatchString:text regString:reg3Last];
                    return matchString;
                } else {
                    NSString * attr = arg1.attr(sub3);
                    if (attr) {
                        NSString * attrRe = [NSString stringWithFormat:@"%@",attr];
                        if ([attrRe isEqualToString:@"<null>"]) {
                            return @"";
                        } else {
                            return attrRe;
                        }
                    } else {
                        return @"";
                    }
                }
            }
            if (arg3) {
                NSString * text = arg1.text();
                if (!text) {
                    return @"";
                }
                NSString * attrRe = [NSString stringWithFormat:@"%@",text];
                if ([attrRe isEqualToString:@"<null>"]) {
                    return @"";
                } else {
                    return attrRe;
                }
            } else {
                NSString * html = arg1.html();
                if (!html) {
                    return @"";
                }
                NSString * attrRe = [NSString stringWithFormat:@"%@",html];
                if ([attrRe isEqualToString:@"<null>"]) {
                    return @"";
                } else {
                    return attrRe;
                }
            }
        }
    }
    return @"";
}

- (NSString *)getMatchString:(NSString *)arg1 regString:(NSString *)arg2 {
    if (arg1.length) {
        NSMutableString * string = [NSMutableString stringWithCapacity:0];
        NSRegularExpression * reg = [NSRegularExpression regularExpressionWithPattern:arg2 options:(NSRegularExpressionCaseInsensitive) error:nil];
        NSArray <NSTextCheckingResult *>* results = [reg matchesInString:arg1 options:(NSMatchingReportProgress) range:NSMakeRange(0, arg1.length)];
        NSString * range1String;
        if (results.count) {
            for (NSInteger index = 0; index < results.count; index++) {
                NSTextCheckingResult * result =  [results objectAtIndex:index];
                NSRange range = [result range];
                NSString * subString = [arg1 substringWithRange:range];
                [string appendString:subString];
                if ([result numberOfRanges] >= 2) {
                    NSRange range1 = [result rangeAtIndex:1];
                     range1String = [arg1 substringWithRange:range1];
                }
            }
        } else {
            return @"";
        }
        if (results.count) {
            [string appendString:[arg1 substringFromIndex:0]];
        }
        return range1String;
    } else {
        return @"";
    }
    return nil;
}

- (void)parseSearchListWithModel:(AikanParserModel *)arg1 html:(NSString *)arg2 toArray:(NSMutableArray *)arg3 {
    OCGumboDocument * document = [[OCGumboDocument alloc] initWithHTMLString:arg2];
    NSString * booksReg = arg1.books;
    NSArray * elements = [self elementArrayWithGumboNode:document withRegexString:booksReg];
}

- (OCQueryObject *)elementArrayWithGumboNode:(OCGumboNode *)arg1 withRegexString:(NSString *)arg2 {
    NSArray * regs = [arg2 componentsSeparatedByString:@" "];
    OCQueryObject *next;
    if (regs.count > 0) {
        for (NSInteger index = 0; index < regs.count; index++) {
            NSString * reg = regs[index];
            reg = [reg stringByReplacingOccurrencesOfString:@"=" withString:@" "];
            if (index) {
                next = next.find(reg);
            } else {
                next = arg1.Query(reg);
            }
        }
    }
    return next;
}

@end

//<html xmlns="//www.w3.org/1999/xhtml" style="overflow-x: auto;"><head>
//<title>学霸的黑科技系统TXT下载_学霸的黑科技系统晨星LL - 笔趣阁</title>
//<meta name="keywords" content="学霸的黑科技系统,学霸的黑科技系统最新章节,学霸的黑科技系统TXT下载">
//<meta name="description" content="笔趣阁提供学霸的黑科技系统，学霸的黑科技系统最新章节免费阅读">
//<meta name="copyright" content="晨星LL">
//<meta http-equiv="content-type" content="text/html; charset=gbk">
//<link rel="shortcut icon" href="/favicon.ico">
//<link rel="alternate" type="application/vnd.wap.xhtml+xml" media="handheld" href="//m.boquge.com/wapbook/81837.html">
//<meta name="mobile-agent" content="format=html5; url=//m.boquge.com/wapbook/81837.html">
//<script src="https://zz.bdstatic.com/linksubmit/push.js"></script><script type="text/javascript">var murl="//m.boquge.com/wapbook/81837.html";</script>
//<meta http-equiv="Cache-Control" content="no-siteapp">
//<meta http-equiv="Cache-Control" content="no-transform">
//<link rel="stylesheet" href="//www.boquge.com/css/b.css">
//<link rel="stylesheet" href="//www.boquge.com/css/m.css">
//<script src="//apps.bdimg.com/libs/jquery/1.10.2/jquery.min.js" type="text/javascript"></script>
//<script src="//apps.bdimg.com/libs/jquery.cookie/1.4.1/jquery.cookie.min.js" type="text/javascript"></script>
//<script src="//www.boquge.com/main.js?v=1" type="text/javascript"></script>
//<meta property="og:type" content="novel">
//<meta property="og:title" content="学霸的黑科技系统">
//<meta property="og:description" content="“系统，积分能兑钱吗？”“不能。”“干，那我要你何用！”“本系统能让你当上学爸，全人类爸爸的爸，你还要钱有什么用？”">
//<meta property="og:image" content="http://qidian.qpic.cn/qdbimg/349573/1011449273/180">
//<meta property="og:novel:category" content="科幻小说">
//<meta property="og:novel:author" content="晨星LL">
//<meta property="og:novel:book_name" content="学霸的黑科技系统">
//<meta property="og:novel:read_url" content="http://www.boquge.com/book/81837/">
//<meta property="og:novel:latest_chapter_url" content="http://www.boquge.com/book/81837/169064600.html">
//<meta property="og:novel:latest_chapter_name" content="咳咳，假酒喝多了，请个假">
//</head>
//<body id="btop-info" style="">
//<div class="container">
//    <nav class="navbar navbar-default col-xs-12 pl20" role="navigation">
//        <div class="navbar-header"><a href="//www.boquge.com" class="logo" title="笔趣阁"><img src="http://www.boquge.com/images/logo.gif"></a></div>
//        <div>
//            <ul class="nav navbar-nav">
//                <li><a href="//www.boquge.com/shuku.htm">分类</a></li>
//                <li><a href="//www.boquge.com/search.htm" rel="nofollow">搜索</a></li>
//                <li><a href="//www.boquge.com/zuji.htm" rel="nofollow">足迹</a></li>
//                <li><a href="//www.boquge.com/home/" rel="nofollow">我的书架</a></li>
//                <li id="login"><a href="//www.boquge.com/login.htm" rel="nofollow">登陆</a></li>
//                <li id="regist"><a href="//www.boquge.com/register.php" rel="nofollow">注册</a></li>
//                <li id="logout" style="display:none;"><a href="//www.boquge.com/home/logout.htm" rel="nofollow">退出登陆</a></li>
//                <li style="width:300px;margin-top:10px;"><form class="" role="form" action="/search.htm" onsubmit="return doFormSubmit();">
//                        <div class="input-group"><input type="text" id="keyword" name="keyword" class="form-control" placeholder="请输入书名或作者"><span class="input-group-addon" onclick="doFormSubmit();">搜索</span>
//                        </div>
//                    </form>
//                </li>
//            </ul>
//        </div>
//    </nav>
//    <article class="panel panel-warning">
//        <ol class="breadcrumb">
//            <li><a href="//www.boquge.com">笔趣阁</a></li>
//            <li><a href="/kehuanxiaoshuo/">科幻小说</a></li>
//          <li class="active">学霸的黑科技系统</li>
//        </ol>
//        <div class="panel-body">
//            <div class="col-xs-2"><img class="img-thumbnail" src="http://qidian.qpic.cn/qdbimg/349573/1011449273/180" onerror="this.src=''" height="160" width="120"></div>
//            <div class="col-xs-8">
//                <ul class="list-group">
//                    <li class="col-xs-12 list-group-item no-border"><h1>学霸的黑科技系统　<small>作者：晨星LL</small></h1></li>
//                    <li class="col-xs-4 list-group-item no-border">类别：<a href="/kehuanxiaoshuo/">科幻小说</a></li>
//                    <li class="col-xs-4 list-group-item no-border">写作进度：连载</li>
//                    <li class="col-xs-4 list-group-item no-border">更新时间：2020-01-06 23:13</li>
//                    <li class="col-xs-12 list-group-item no-border">最新章节：<a href="/book/81837/169064600.html">咳咳，假酒喝多了，请个假</a></li>
//                    <li class="col-xs-12 list-group-item no-border tac">
//                        <a href="/book/81837/" class="btn btn-danger">开始阅读</a>
//                        <a href="javascript:pl(81837, 0);" class="btn btn-info">加入书架</a>
//                        <a href="javascript:tj('81837', '1');" class="btn btn-info">推荐本书</a>
//                        <a href="javascript:nu('81837');" title="亲，我们会以神一样的速度为您更新的。" class="btn btn-info">更新提醒</a>
//                        <a href="" class="btn btn-info">下载TXT合集</a>
//                    </li>
//                </ul>
//                <div class="clearfix"></div>
//                <div class="panel panel-default mt20">
//                    <div class="panel-heading"><h2>学霸的黑科技系统简介</h2></div>
//                    <div class="panel-body">
//                    <p id="shot">“系统，积分能兑钱吗？”“不能。”“干，那我要你何用！”“本系统能让你当上学爸，全人类爸爸的爸，你还要钱有什么用？”</p>
//
//                    </div>
//                    <ul class="list-group">
//                    <li class="list-group-item active">章节目录</li>
//                    <li class="list-group-item"><a href="/book/81837/169064600.html">咳咳，假酒喝多了，请个假</a></li><li class="list-group-item"><a href="/book/81837/169056339.html">第1429章 地狱归来</a></li><li class="list-group-item"><a href="/book/81837/169056338.html">第1428章 相隔一个世纪的返航</a></li><li class="list-group-item"><a href="/book/81837/169041719.html">第1427章 远方的故人</a></li><li class="list-group-item"><a href="/book/81837/169041712.html">第1426章 天宫！</a></li>
//                    <li class="list-group-item tac"><a href="/book/81837/"><strong>查看全部章节</strong></a></li>
//                    </ul>
//                </div>
//                <div class="panel panel-default">
//                    <div class="panel-heading"><h2>学霸的黑科技系统书友评论</h2></div>
//                    <div class="panel-body" id="novel-list">
//
//                        <div style="padding:10px 20px;text-align:right;">
//                            <textarea class="form-control" rows="3" id="comment"></textarea>
//                            <input type="button" class="btn btn-default mt10" value="提交">
//                        </div>
//                    </div>
//                </div>
//            </div>
//        </div>
//    </article>
//    <script type="text/javascript">ac('6', '81837');</script>
//    <footer class="footer">
//<p class="links"><a href="//m.boquge.com">笔趣阁手机版</a><i>　|　</i><a href="//mail.qq.com/cgi-bin/qm_share?t=qm_mailme&amp;email=" rel="nofollow">问题反馈</a><i>　|　</i><a href="#btop-info" class="go_top">返回顶部</a></p>
//<p>请所有作者发布作品时务必遵守国家互联网信息管理办法规定，我们拒绝任何色情小说，一经发现，即作删除<br>
//本站所收录作品、社区话题、书库评论及本站所做之广告均属其个人行为，与本站立场无关<br>
//Copyright©2015-2016 <a href="//www.boquge.com">www.boquge.com</a> All   rights Reserved &nbsp;版权所有&nbsp;<br>
//</p>
//</footer>
//<div class="hidden">
//<script type="text/javascript">showTongJi();</script><script src="https://s11.cnzz.com/z_stat.php?id=1259606950&amp;web_id=1259606950" language="JavaScript"></script><script src="https://c.cnzz.com/core.php?web_id=1259606950&amp;t=z" charset="utf-8" type="text/javascript"></script><a href="https://www.cnzz.com/stat/website.php?web_id=1259606950" target="_blank" title="站长统计">站长统计</a>
//<script>
//(function(){
//    var bp = document.createElement('script');
//    var curProtocol = window.location.protocol.split(':')[0];
//    if (curProtocol === 'https') {
//        bp.src = 'https://zz.bdstatic.com/linksubmit/push.js';
//    }
//    else {
//        bp.src = 'http://push.zhanzhang.baidu.com/push.js';
//    }
//    var s = document.getElementsByTagName("script")[0];
//    s.parentNode.insertBefore(bp, s);
//})();
//</script>
//
//</div>
//</div>
//
//</body></html>
