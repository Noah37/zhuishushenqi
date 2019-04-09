//
//	XMLiveCity.h
//
//	Create by 王瑞 on 21/9/2015
//	Copyright © 2015. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface XMLiveCity : NSObject

@property (nonatomic, assign) NSInteger cityCode;
@property (nonatomic, strong) NSString * cityName;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString * kind;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end