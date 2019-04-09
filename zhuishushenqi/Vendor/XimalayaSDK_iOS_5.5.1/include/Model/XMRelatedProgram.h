//
//	XMRelatedProgram.h
//
//	Create by 王瑞 on 24/8/2015
//	Copyright © 2015. All rights reserved.
//

//	 

#import <UIKit/UIKit.h>
#import "XMLiveAnnouncer.h"

@interface XMRelatedProgram : NSObject

@property (nonatomic, strong) NSString * backPicUrl;
@property (nonatomic, assign) NSInteger radioProgramId;
@property (nonatomic, strong) NSString * kind;
@property (nonatomic, strong) NSArray * liveAnnouncers;
@property (nonatomic, strong) NSString * programName;
@property (nonatomic, strong) NSString * rate24AacUrl;
@property (nonatomic, strong) NSString * rate24TsUrl;
@property (nonatomic, strong) NSString * rate64AacUrl;
@property (nonatomic, strong) NSString * rate64TsUrl;
@property (nonatomic, strong) NSArray * supportBitrates;
@property (nonatomic, assign) double updatedAt;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end