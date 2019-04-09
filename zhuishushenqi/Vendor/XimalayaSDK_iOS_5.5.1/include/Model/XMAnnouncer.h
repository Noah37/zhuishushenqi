//
//	XMAnnouncer.h
//
//	Create by 王瑞 on 28/8/2015
//	Copyright © 2015. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface XMAnnouncer : NSObject

@property (nonatomic, strong) NSString * avatarUrl;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) BOOL isVerified;
@property (nonatomic, strong) NSString * kind;
@property (nonatomic, strong) NSString * nickname;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end