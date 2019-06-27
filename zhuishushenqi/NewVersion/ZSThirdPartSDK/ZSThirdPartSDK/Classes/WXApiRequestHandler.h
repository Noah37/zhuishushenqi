//
//  WXApiRequestHandler.h
//  ZSThirdPartSDK
//
//  Created by caony on 2019/6/22.
//  Copyright © 2019 cj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "WechatAuthSDK.h"

NS_ASSUME_NONNULL_BEGIN

@interface WXApiRequestHandler : NSObject<WXApiDelegate>

+ (instancetype)share;
- (BOOL)sendWXAuthWithScope:(NSString *)scope state:(NSString *)state;

@end

NS_ASSUME_NONNULL_END
