//
//  WXApiRequestHandler.m
//  ZSThirdPartSDK
//
//  Created by caony on 2019/6/22.
//  Copyright © 2019 cj. All rights reserved.
//

#import "WXApiRequestHandler.h"
#import "ZSThirdLogin.h"
#import "ZSThirdPartSDK-Swift.h"

@implementation WXApiRequestHandler

+ (instancetype)share {
    static WXApiRequestHandler * sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (BOOL)sendWXAuthRequestScope:(NSString *)scope state:(NSString *)state inViewController:(UIViewController *)inViewController {
    SendAuthReq * req = [[SendAuthReq alloc] init];
    req.scope = scope;
    req.state = state;
    return [WXApi sendAuthReq:req viewController:inViewController delegate:self];
}

- (BOOL)sendWXAuthWithScope:(NSString *)scope state:(NSString *)state {
    SendAuthReq * req = [[SendAuthReq alloc] init];
    req.scope = scope;
    req.state = state;
    return [WXApi sendReq:req];
}

- (void)onReq:(BaseReq *)req {
    
}

- (void)onResp:(BaseResp *)resp {
    SendAuthResp * res = (SendAuthResp *)resp;
    if (res.errCode == 0) {
        NSString * code = res.code;
        NSString * getAccessTokenUrl = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", WXAppID, WXAppSecret, code];
        [[ZSRequestHelper share] request:getAccessTokenUrl parameters:nil :^(ZSWXAccessTokenResp * _Nullable resp) {
            [[ZSThirdLoginStorage share] saveWXTokenWithWxTokenResp:resp];
            [[ZSThirdLogin shared] loginWithType:(ThirdLoginTypeWX)];
        }];
    } else {
        NSLog(@"请求出错,code：%d \nerror:%@", resp.errCode, resp.errStr);
    }
}


@end
