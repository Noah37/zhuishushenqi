//
//  ZSThirdLogin.m
//  ZSThirdPartSDK
//
//  Created by caony on 2019/6/22.
//  Copyright © 2019 cj. All rights reserved.
//

#import "ZSThirdLogin.h"
#import "WeiboSDK.h"
#import "WXApi.h"
#import "WechatAuthSDK.h"
#import "TencentOpenAPI/QQApiInterface.h"
#import "TencentOpenAPI/TencentOAuth.h"
#import <ZSThirdPartSDK-Swift.h>
#import <AdSupport/AdSupport.h>
#import "ZSLogin.h"
#import "WXApiRequestHandler.h"

NSString * const QQAppID = @"100497199";
NSString * const WXAppID = @"wxaf0fdeed6872dfcf";
NSString * const WXAppSecret = @"0464c67bdd87c303c5bfdc5761beb329";
NSString * const WBAppID = @"2023668704";
NSString * const WBAppSecret = @"26efa7a6a6bed540092c9535bda75db9";
NSString * const WBRedirectURI = @"http://ushaqi.com";

@interface ZSThirdLogin ()<TencentSessionDelegate,WeiboSDKDelegate,QQApiInterfaceDelegate>

@property (nonatomic, strong) TencentOAuth * tencentOAuth;
@property (nonatomic, strong) ZSLoginService * webService;
@property (nonatomic, strong) ZSQQLoginResponse * userInfo;
@property (nonatomic, strong) ZSWXAccessTokenResp * wxTokenResp;
@property (nonatomic, strong) WBAuthorizeResponse * wbAuthorizeResp;
@property (nonatomic, strong) NSArray <NSString *>* permissions;
@property (nonatomic, strong) NSString * wxAuthScope;

@end

@implementation ZSThirdLogin

+ (instancetype)shared {
    static ZSThirdLogin * sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQAppID andDelegate:self];
        ZSResponseModel * respModel = [ZSThirdLoginStorage share].localUserInfo;
        self.userInfo = respModel.qqResp;
        self.wxTokenResp = respModel.wxResp;
    }
    return self;
}

- (NSString *)token {
    return self.userInfo.token;
}

- (void)logout {
    self.userInfo = nil;
    self.wxTokenResp = nil;
}

- (void)QQAuth {
    [self.tencentOAuth authorize:self.permissions inSafari:NO];
}

- (void)WXAuth {
    [WXApi registerApp:WXAppID];
    [[WXApiRequestHandler share] sendWXAuthWithScope:self.wxAuthScope state:@"YouShaQi"];
}

- (void)WBAuth {
    WBAuthorizeRequest * request = [[WBAuthorizeRequest alloc] init];
    request.redirectURI = WBRedirectURI;
    request.scope = @"all";
    [WeiboSDK sendRequest:request];
}

- (void)loginWithType:(ThirdLoginType)type {
    switch (type) {
        case ThirdLoginTypeQQ:
            [self QQLogin];
            break;
        case ThirdLoginTypeWX:
            [self WXLogin];
            break;
            
        case ThirdLoginTypeWB:
            [self WBLogin];
            break;
            
        case ThirdLoginTypeXM:
            
            break;
        default:
            break;
    }
}

- (void)refreshWXToken {
    //    //        https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=APPID&grant_type=refresh_token&refresh_token=REFRESH_TOKEN
    //    // 一般第一次获取到access_token后直接登录追书d,获取token,后面基本不需要access_token了
    //
}

- (void)QQLogin {
    NSString * idfa =  [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString;
    NSString * platform_code = @"QQ";
    NSString * platform_token = _tencentOAuth.accessToken;
    NSString * platform_uid = _tencentOAuth.openId;
    NSString * version = @"2";
    [[ZSRequestHelper share] QQLoginWithWebService:self.webService idfa:idfa platform_code:platform_code platform_token:platform_token platform_uid:platform_uid version:version tag:@"" successHandler:^(ZSQQLoginResponse * _Nullable resp) {
        [ZSLogin share].token = resp.token;
        if (self.successHandler) {
            self.successHandler();
        }
    } loginResultHandler:^(BOOL result) {
        if (self.loginResultHandler) {
            self.loginResultHandler(result);
        }
    }];
}

- (void)WXLogin {
    NSString * idfa =  [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString;
    NSString * platform_code = @"WeixinNew";
    NSString * platform_token = _wxTokenResp.access_token;
    NSString * platform_uid = _wxTokenResp.openid;
    NSString * version = @"2";
    NSString * tag = @"zssq";
    [[ZSRequestHelper share] WXLoginWithWebService:self.webService idfa:idfa platform_code:platform_code platform_token:platform_token platform_uid:platform_uid version:version tag:tag successHandler:^(ZSQQLoginResponse * _Nullable resp) {
        [ZSLogin share].token = resp.token;
        if (self.successHandler) {
            self.successHandler();
        }
    } loginResultHandler:^(BOOL result) {
        if (self.loginResultHandler) {
            self.loginResultHandler(result);
        }
    }];
}

- (void)WBLogin {
    NSString * idfa =  [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString;
    NSString * platform_code = @"SinaWeibo";
    NSString * platform_token = _wbAuthorizeResp.accessToken;
    NSString * platform_uid = _wbAuthorizeResp.userID;
    NSString * version = @"2";
    NSString * tag = @"zssq";
    [[ZSRequestHelper share] WBLoginWithWebService:self.webService idfa:idfa platform_code:platform_code platform_token:platform_token platform_uid:platform_uid version:version tag:tag successHandler:^(ZSQQLoginResponse * _Nullable resp) {
        [ZSLogin share].token = resp.token;
        if (self.successHandler) {
            self.successHandler();
        }
    } loginResultHandler:^(BOOL result) {
        if (self.loginResultHandler) {
            self.loginResultHandler(result);
        }
    }];
}

- (NSArray<NSString *> *)permissions {
    return @[@"get_user_info",@"get_simple_userinfo",@"add_t"];
}

- (NSString *)wxAuthScope {
    return @"snsapi_userinfo,snsapi_friend,snsapi_contact,snsapi_message";
}

#pragma mark - TencentSessionDelegate
- (void)tencentDidLogin {
    [self loginWithType:(ThirdLoginTypeQQ)];
}

- (void)tencentDidNotLogin:(BOOL)cancelled {
    if (cancelled) {
#warning toast 用户取消了操作
        NSLog(@"用户取消了操作");
    }
}

- (void)tencentDidNotNetWork {
#warning toast 网络连接失败
    NSLog(@"网络连接失败");
}

#pragma mark - QQApiInterfaceDelegate
- (void)onReq:(QQBaseReq *)req {
    
}

- (void)onResp:(QQBaseResp *)resp {
    
}

- (void)isOnlineResponse:(NSDictionary *)response {
    
}

#pragma mark - WeiboSDKDelegate
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    WBAuthorizeResponse * authorize = (WBAuthorizeResponse *)response;
    if ([authorize isKindOfClass:[WBAuthorizeResponse class]]) {
        self.wbAuthorizeResp = authorize;
        [self loginWithType:(ThirdLoginTypeWB)];
    }
}

@end
