//
//  NSString+Encode.m
//  zhuishushenqi
//
//  Created by caonongyun on 2017/4/26.
//  Copyright © 2017年 QS. All rights reserved.
//

#import "NSString+Encode.h"
#import "uchardet.h"

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

+ (NSStringEncoding)nh_stringEncodingForData:(NSData *)data encodingOptions:(NSDictionary<NSStringEncodingDetectionOptionsKey, id> *)opts convertedString:(NSString * _Nullable *)string usedLossyConversion:(BOOL *)usedLossyConversion {
    return [NSString stringEncodingForData:data encodingOptions:opts convertedString:string usedLossyConversion:usedLossyConversion];
}

+ (NSString *)fileEncoding:(NSString *)path {
    FILE* file;
    char buf[2048];
    size_t len;
    uchardet_t ud;

    /* 打开被检测文本文件，并读取一定数量的样本字符 */
       file = fopen([path UTF8String], "rt");
    if (file==NULL) {
        printf("文件打开失败！\n");
        return @"";
    }
    len = fread(buf, sizeof(char), 2048, file);
    fclose(file);

    ud = uchardet_new();
    if(uchardet_handle_data(ud, buf, len) != 0) {
        printf("分析编码失败！\n");
        return @"";
    }
    uchardet_data_end(ud);
    const char * encode = uchardet_get_charset(ud);
    printf("文本的编码方式是%s。\n", encode);
    NSString * encodeString = [NSString stringWithFormat:@"%s", encode];
    uchardet_delete(ud);
    return encodeString;
}

@end
