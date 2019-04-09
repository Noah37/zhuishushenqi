//
//	XMAlbumGuessLike.h
//
//	Create by 王瑞 on 6/11/2015
//	Copyright © 2015. All rights reserved.
//



#import <UIKit/UIKit.h>

@interface XMAlbumGuessLike : NSObject

@property (nonatomic, assign) NSInteger basedRelativeAlbumId;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSObject * isFinished;
@property (nonatomic, strong) NSString * kind;
@property (nonatomic, strong) NSString * recommendSrc;
@property (nonatomic, strong) NSString * recommendTrace;

//可否下载，YES-可下载，NO-不可下载
@property (nonatomic, assign) BOOL canDownload;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end