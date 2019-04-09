//
//	XMTrackColumnItem.h
//
//	Create by nali on 2/3/2017
//	Copyright © 2017. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>
#import "XMDimension.h"

@interface XMTrackColumnItem : NSObject

@property (nonatomic, assign) BOOL canDownload;
@property (nonatomic, assign) NSInteger categoryId;
@property (nonatomic, assign) NSInteger channelPlayCount;
@property (nonatomic, assign) NSInteger contentType;
@property (nonatomic, strong) NSString * coverUrlLarge;
@property (nonatomic, strong) NSString * coverUrlMiddle;
@property (nonatomic, strong) NSString * coverUrlOriginal;
@property (nonatomic, strong) NSString * coverUrlSmall;
@property (nonatomic, assign) NSInteger createdAt;
@property (nonatomic, strong) NSArray * dimensions;
@property (nonatomic, assign) NSInteger downloadSize;
@property (nonatomic, strong) NSString * downloadUrl;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * intro;
@property (nonatomic, assign) NSInteger isFinished;
@property (nonatomic, strong) NSString * kind;
@property (nonatomic, assign) NSInteger playCount;
@property (nonatomic, strong) NSString * playSize24M4a;
@property (nonatomic, strong) NSString * playSize32;
@property (nonatomic, strong) NSString * playSize64;
@property (nonatomic, strong) NSString * playSize64M4a;
@property (nonatomic, strong) NSString * playUrl24M4a;
@property (nonatomic, strong) NSString * playUrl32;
@property (nonatomic, strong) NSString * playUrl64;
@property (nonatomic, strong) NSString * playUrl64M4a;
@property (nonatomic, assign) NSInteger publishAt;
@property (nonatomic, strong) NSString * shortExtInfo;
@property (nonatomic, strong) NSArray * subordinatedAlbum;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) NSInteger updatedAt;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end