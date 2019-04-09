//
//	XMRadio.h
//
//	Create by 王瑞 on 24/8/2015
//	Copyright © 2015. All rights reserved.
//

//	 

#import <UIKit/UIKit.h>

@interface XMRadio : NSObject

@property (nonatomic, strong) NSString * coverUrlLarge;
@property (nonatomic, strong) NSString * coverUrlSmall;
@property (nonatomic, assign) NSInteger radioId;
@property (nonatomic, strong) NSString * kind;
@property (nonatomic, strong) NSString * programName;
@property (nonatomic, strong) NSString * radioDesc;
@property (nonatomic, strong) NSString * radioName;
@property (nonatomic, assign) NSInteger radioPlayCount;
@property (nonatomic, strong) NSString * rate24AacUrl;
@property (nonatomic, strong) NSString * rate24TsUrl;
@property (nonatomic, strong) NSString * rate64AacUrl;
@property (nonatomic, strong) NSString * rate64TsUrl;
@property (nonatomic, assign) NSInteger scheduleId;
@property (nonatomic, strong) NSArray * supportBitrates;
@property (nonatomic, assign) double updatedAt;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end