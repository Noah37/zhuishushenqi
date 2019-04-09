//
//	XMProvince.h
//
//	Create by 王瑞 on 25/8/2015
//	Copyright © 2015. All rights reserved.
//

//	 

#import <UIKit/UIKit.h>

@interface XMProvince : NSObject

@property (nonatomic, assign) double createdAt;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString * kind;
@property (nonatomic, assign) NSInteger provinceCode;
@property (nonatomic, strong) NSString * provinceName;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end