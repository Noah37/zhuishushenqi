//
//  NSString+Encode.m
//  zhuishushenqi
//
//  Created by yung on 2017/4/26.
//  Copyright © 2017年 QS. All rights reserved.
//

#import "NSString+Encode.h"
#import "uchardet.h"
#import <mach/mach.h>

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

+ (double)totalMemory {
    mach_port_t host_port;
    mach_msg_type_number_t host_size;
    vm_size_t pagesize;
    host_port = mach_host_self();
    host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);
    vm_statistics_data_t vm_stat;
    if(host_statistics(host_port,HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) !=KERN_SUCCESS) {
        return NSNotFound;
    }
     /* Stats in bytes */
    uintptr_t mem_used = (vm_stat.active_count + vm_stat.inactive_count + vm_stat.wire_count) * pagesize;
    
    uintptr_t mem_free = vm_stat.free_count* pagesize;

    uintptr_t mem_total = mem_used + mem_free;
    return mem_total/1024.0/1024.0;
}

+ (double)availableMemory {
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    return ((vm_page_size * vmStats.free_count)/1024.0)/1024.0;
}

// 获取当前应用的内存占用情况，和Xcode数值相近
+ (double)getMemoryUsage {
    task_vm_info_data_t vmInfo;
    mach_msg_type_number_t count = TASK_VM_INFO_COUNT;
    kern_return_t kernelReturn = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t) &vmInfo, &count);
    if(kernelReturn == KERN_SUCCESS) {
        return (double)vmInfo.phys_footprint / (1024 * 1024);
    } else {
        return -1.0;
    }
}

@end
