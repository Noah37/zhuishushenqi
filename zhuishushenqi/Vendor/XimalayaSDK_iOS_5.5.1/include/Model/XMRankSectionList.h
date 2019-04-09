//
//	XMRankSectionList.h
//
//	Create by 王瑞 on 25/8/2015
//	Copyright © 2015. All rights reserved.
//

//	 

#import <UIKit/UIKit.h>
#import "XMIndexRankItem.h"

@interface XMRankSectionList : NSObject

@property (nonatomic, assign) NSInteger categoryId;
@property (nonatomic, strong) NSString * coverUrl;
@property (nonatomic, strong) NSArray * indexRankItems;
@property (nonatomic, strong) NSString * kind;
@property (nonatomic, strong) NSString * rankContentType;
@property (nonatomic, assign) NSInteger rankFirstItemId;
@property (nonatomic, strong) NSString * rankFirstItemTitle;
@property (nonatomic, assign) NSInteger rankItemNum;
@property (nonatomic, strong) NSString * rankKey;
@property (nonatomic, assign) NSInteger rankOrderNum;
@property (nonatomic, assign) NSInteger rankPeriod;
@property (nonatomic, strong) NSObject * rankPeriodType;
@property (nonatomic, strong) NSString * rankSubTitle;
@property (nonatomic, strong) NSString * rankTitle;
@property (nonatomic, assign) NSInteger rankType;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end