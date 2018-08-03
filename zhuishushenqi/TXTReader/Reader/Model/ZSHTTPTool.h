//
//  ZSHTTPTool.h
//  zhuishushenqi
//
//  Created by caonongyun on 2018/7/30.
//  Copyright © 2018年 QS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSHTTPTool : NSObject

+ (NSString *)getIPAddress:(BOOL)preferIPv4;

+ (BOOL)isValidatIP:(NSString *)ipAddress;

+ (NSDictionary *)getIPAddresses;

@end
