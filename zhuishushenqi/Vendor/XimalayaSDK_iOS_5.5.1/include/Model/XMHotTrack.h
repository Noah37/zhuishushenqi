//
//	XMHotTrack.h
//
//	Create by 王瑞 on 24/8/2015
//	Copyright © 2015. All rights reserved.
//

//	 

#import <UIKit/UIKit.h>
#import "XMTrack.h"

@interface XMHotTrack : NSObject

@property (nonatomic, assign) NSInteger categoryId;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSString * tagName;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, assign) NSInteger totalPage;
@property (nonatomic, strong) NSArray * tracks;

//可否下载，YES-可下载，NO-不可下载
@property (nonatomic, assign) BOOL canDownload;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end