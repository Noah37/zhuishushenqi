//
//  ZSLogin.m
//  ZSThirdPartSDK
//
//  Created by caony on 2019/6/22.
//  Copyright © 2019 cj. All rights reserved.
//

#import "ZSLogin.h"
#import "ZSThirdPartSDK-Swift.h"

@interface ZSLogin ()

@end

@implementation ZSLogin

+ (instancetype)share {
    static ZSLogin * shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString * token = [[ZSThirdLogin shared] token];
        NSString * mobileToken = [ZSMobileLogin share].userInfo.token;
        if (token.length > 0) {
            self.token = token;
        } else if (mobileToken.length > 0) {
            self.token = mobileToken;
            self.mobileLogin = YES;
        }
    }
    return self;
}

- (BOOL)hasLogin {
    return self.token.length == 0;
}

- (void)logout {
    [[ZSThirdLoginStorage share] resetLocalUserInfo];
    [[ZSThirdLogin shared] logout];
}

- (NSInteger)lastLoginType {
    return [ZSThirdLoginStorage share].lastLoginType;
}

@end
