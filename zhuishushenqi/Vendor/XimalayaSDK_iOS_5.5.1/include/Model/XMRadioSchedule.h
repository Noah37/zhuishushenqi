//
//	XMRadioSchedule.h
//
//	Create by 王瑞 on 24/8/2015
//	Copyright © 2015. All rights reserved.
//

//	 

#import <UIKit/UIKit.h>
#import "XMRelatedProgram.h"

@interface XMRadioSchedule : NSObject

@property (nonatomic, strong) NSString * endTime;
@property (nonatomic, assign) NSInteger radioScheduleId;
@property (nonatomic, assign) NSInteger radioId;
@property (nonatomic, strong) NSString * kind;
@property (nonatomic, strong) NSString * listenBackUrl;
@property (nonatomic, assign) NSInteger playType;
@property (nonatomic, strong) XMRelatedProgram * relatedProgram;
@property (nonatomic, strong) NSString * startTime;
@property (nonatomic, assign) double updatedAt;

@property (nonatomic,assign) NSInteger totalPlayedTime;

@property (nonatomic,strong) NSDate *startDate;

@property (nonatomic,strong) NSDate *endDate;

@property (nonatomic,assign) NSTimeInterval  duration;


-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end