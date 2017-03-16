//
//  NSDate+Date.m
//  zhuishushenqi
//
//  Created by caonongyun on 2017/3/14.
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
    
    return [calendar dateFromComponents:comps];
}


@end
