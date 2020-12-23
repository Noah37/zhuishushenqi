//
//  NSString+Encode.m
//  zhuishushenqi
//
//  Created by yung on 2017/4/26.
//  Copyright © 2017年 QS. All rights reserved.
//

#import "NSString+Encode.h"

@implementation NSString (Encode)


- (NSString*)urlEncode{
    //different library use slightly different escaped and unescaped set.
    //below is copied from AFNetworking but still escaped [] as AF leave them for Rails array parameter which we don't use.
    //https://github.com/AFNetworking/AFNetworking/pull/555
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)self, CFSTR("."), CFSTR(":/?#[]@!$&'()*+,;="), kCFStringEncodingUTF8));
    
    return result;
}

- (NSString *)urlDecode{
//    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,(__bridge CFStringRef)self,CFSTR(":/?#[]@!$&'()*+,;="),kCFStringEncodingUTF8));
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapes(kCFAllocatorDefault,(__bridge CFStringRef)self,CFSTR(":/?#[]@!$&'()*+,;=")));
    return result;
}

- (NSString *)zs_urlDecode{
    NSString *result = [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}

@end
