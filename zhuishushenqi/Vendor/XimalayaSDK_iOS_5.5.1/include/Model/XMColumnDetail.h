//
//	XMColumnDetail.h
//
//	Create by 王瑞 on 26/8/2015
//	Copyright © 2015. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "XMColumnEditor.h"


@interface XMColumnDetail : NSObject

@property (nonatomic, assign) NSInteger columnContentType;
@property (nonatomic, strong) XMColumnEditor * columnEditor;
@property (nonatomic, strong) NSString * columnIntro;
@property (nonatomic, strong) NSArray * columnItems;
@property (nonatomic, strong) NSString * coverUrlLarge;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) BOOL isHot;
@property (nonatomic, strong) NSString * kind;
@property (nonatomic, strong) NSString * logoSmall;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end