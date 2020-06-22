//
//  NSString+Encode.h
//  zhuishushenqi
//
//  Created by caonongyun on 2017/4/26.
//  Copyright © 2017年 QS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Encode)

- (NSString*)urlEncode;
- (NSString *)urlDecode;
- (NSString *)zs_urlDecode;

+ (NSStringEncoding)nh_stringEncodingForData:(NSData *)data encodingOptions:(NSDictionary<NSStringEncodingDetectionOptionsKey, id> *)opts convertedString:(NSString * _Nullable *)string usedLossyConversion:(BOOL *)usedLossyConversion;

@end
