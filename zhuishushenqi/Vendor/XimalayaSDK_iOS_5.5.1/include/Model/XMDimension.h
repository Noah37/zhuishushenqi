//
//	XMDimension.h
//
//	Create by nali on 23/2/2017
//	Copyright © 2017. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface XMDimension : NSObject

@property (nonatomic, assign) NSInteger dimId;
@property (nonatomic, strong) NSString * dimName;
@property (nonatomic, strong) NSString * dimValue;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end