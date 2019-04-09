//
//	XMColumnList.h
//
//	Create by 王瑞 on 26/8/2015
//	Copyright © 2015. All rights reserved.
//

//	 

#import <UIKit/UIKit.h>
#import "XMColumn.h"

@interface XMColumnList : NSObject

@property (nonatomic, strong) NSArray * columns;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, assign) NSInteger totalPage;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end