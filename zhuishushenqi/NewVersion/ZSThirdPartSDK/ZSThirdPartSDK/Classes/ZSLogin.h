//
//  ZSLogin.h
//  ZSThirdPartSDK
//
//  Created by caony on 2019/6/22.
//  Copyright © 2019 cj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZSThirdLogin.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZSLogin : NSObject

@property (nonatomic, copy) NSString * token;
@property (nonatomic, assign) NSInteger lastLoginType;
@property (nonatomic, assign) BOOL mobileLogin;

+ (instancetype)share;
- (BOOL)hasLogin;
- (void)logout;
@end

NS_ASSUME_NONNULL_END
