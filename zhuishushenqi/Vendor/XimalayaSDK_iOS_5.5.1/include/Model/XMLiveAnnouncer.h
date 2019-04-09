//
//	XMLiveAnnouncer.h
//
//	Create by 王瑞 on 24/8/2015
//	Copyright © 2015. All rights reserved.
//

//	 

#import <UIKit/UIKit.h>

@interface XMLiveAnnouncer : NSObject

@property (nonatomic, strong) NSString * avatarUrl;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString * kind;
@property (nonatomic, strong) NSString * nickname;

@property (nonatomic, assign) double createdAt;
@property (nonatomic, assign) double updatedAt;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end