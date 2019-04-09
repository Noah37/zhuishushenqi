//
//	XMTrackColumn.h
//
//	Create by nali on 2/3/2017
//	Copyright © 2017. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>
#import "XMTrackColumnItem.h"

@interface XMTrackColumn : NSObject

@property (nonatomic, assign) NSInteger channelPlayCount;
@property (nonatomic, strong) NSString * columnIntro;
@property (nonatomic, strong) NSString * columnTitle;
@property (nonatomic, assign) NSInteger createdAt;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * kind;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, assign) NSInteger totalPage;
@property (nonatomic, strong) NSArray * trackColumnItems;
@property (nonatomic, assign) NSInteger updatedAt;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end