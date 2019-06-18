//
//  NSDate+Date.m
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/3/14.
//  Copyright © 2017年 QS. All rights reserved.
//

#import "NSDate+Date.h"

@implementation NSDate (Date)

+ (NSDate*)getDateWithYear:(NSString *)year month:(NSString *)month day:(NSString *)day hour:(NSString *)hour mimute:(NSString *)minute second:(NSString*)second
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:[year integerValue]];
    [comps setMonth:[month integerValue]];
    [comps setDay:[day integerValue]];
    [comps setHour:[hour integerValue]];
    [comps setMinute:[minute integerValue]];
    [comps setSecond:[second integerValue]];
    
    NSDate *date = [calendar dateFromComponents:comps];
    NSTimeInterval timeInterval = [self offsetTimeIntervalFromCurrentTimeZoneForDate:date];
    return [NSDate dateWithTimeInterval:timeInterval sinceDate:date];
}

+ (NSTimeInterval)offsetTimeIntervalFromCurrentTimeZoneForDate:(NSDate *)anyDate {
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    return interval;
}


@end
