//
//	XMCategory.h
//
//	Create by 王瑞 on 24/8/2015
//	Copyright © 2015. All rights reserved.
//

//	 

#import <UIKit/UIKit.h>

@interface XMCategory : NSObject

@property (nonatomic, strong) NSString * categoryName;
@property (nonatomic, strong) NSString * coverUrlLarge;
@property (nonatomic, strong) NSString * coverUrlMiddle;
@property (nonatomic, strong) NSString * coverUrlSmall;
@property (nonatomic, assign) NSInteger categoryId;
@property (nonatomic, strong) NSString * kind;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end