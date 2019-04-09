//
//	XMAttribute.h
//
//	Create by nali on 31/8/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>
#import "XMMetadata.h"

@class XMMetadata;

@interface XMAttribute : NSObject

@property (nonatomic, assign) NSInteger attrKey;
@property (nonatomic, strong) NSString * attrValue;
@property (nonatomic, strong) NSString * displayName;
@property (nonatomic, strong) XMMetadata * childMetadata;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end