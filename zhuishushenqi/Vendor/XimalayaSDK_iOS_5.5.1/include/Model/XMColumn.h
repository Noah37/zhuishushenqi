//
//	XMColumn.h
//
//	Create by 王瑞 on 26/8/2015
//	Copyright © 2015. All rights reserved.
//



#import <UIKit/UIKit.h>

@interface XMColumn : NSObject

@property (nonatomic, assign) NSInteger columnContentType;
@property (nonatomic, strong) NSString * columnFootNote;
@property (nonatomic, strong) NSString * columnSubTitle;
@property (nonatomic, strong) NSString * columnTitle;
@property (nonatomic, strong) NSString * coverUrlLarge;
@property (nonatomic, strong) NSString * coverUrlSmall;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) BOOL isHot;
@property (nonatomic, strong) NSString * kind;
@property (nonatomic, assign) NSInteger releasedAt;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end