//
//	XMLastUptrack.h
//
//	Create by 王瑞 on 28/8/2015
//	Copyright © 2015. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface XMLastUptrack : NSObject

@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, assign) NSInteger trackId;
@property (nonatomic, strong) NSString * trackTitle;

@property (nonatomic, assign) double createdAt;
@property (nonatomic, assign) double updatedAt;

//可否下载，YES-可下载，NO-不可下载
@property (nonatomic, assign) BOOL canDownload;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end