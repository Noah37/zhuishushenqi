//
//  ZSThirdLogin.h
//  ZSThirdPartSDK
//
//  Created by caony on 2019/6/22.
//  Copyright © 2019 cj. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ZSLoginSuccess)(void);
typedef void(^ZSThirdLoginResultHandler)(BOOL);

@interface ZSThirdLogin : NSObject

@property (nonatomic, copy) ZSLoginSuccess successHandler;
@property (nonatomic, copy) ZSThirdLoginResultHandler loginResultHandler;

+ (instancetype)shared;

- (void)loginWithType:(NSInteger)type;

- (void)logout;

- (NSString *)token;

// 调起各种三方认证
- (void)QQAuth;
- (void)WXAuth;
- (void)WBAuth;

@end

FOUNDATION_EXTERN NSString * _Nullable const QQAppID;
FOUNDATION_EXTERN NSString * _Nullable const WXAppID;
FOUNDATION_EXTERN NSString * _Nullable const WXAppSecret;
FOUNDATION_EXTERN NSString * _Nullable const WBAppID;
FOUNDATION_EXTERN NSString * _Nullable const WBAppSecret;
FOUNDATION_EXTERN NSString * _Nullable const WBRedirectURI;
