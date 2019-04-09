//
//	XMMetadata.h
//
//	Create by nali on 31/8/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>
#import "XMAttribute.h"

@interface XMMetadata : NSObject

@property (nonatomic, strong) NSArray * attributes;
@property (nonatomic, strong) NSString * displayName;
@property (nonatomic, strong) NSString * kind;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end