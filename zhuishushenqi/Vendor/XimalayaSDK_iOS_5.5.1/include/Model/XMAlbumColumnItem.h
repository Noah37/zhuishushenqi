//
//	XMAlbumColumnItem.h
//
//	Create by nali on 23/2/2017
//	Copyright © 2017. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>
#import "XMDimension.h"

@interface XMAlbumColumnItem : NSObject

@property (nonatomic, assign) NSInteger categoryId;
@property (nonatomic, assign) NSInteger channelPlayCount;
@property (nonatomic, assign) NSInteger contentType;
@property (nonatomic, strong) NSString * coverUrlLarge;
@property (nonatomic, strong) NSString * coverUrlMiddle;
@property (nonatomic, strong) NSString * coverUrlOriginal;
@property (nonatomic, strong) NSString * coverUrlSmall;
@property (nonatomic, assign) NSInteger createdAt;
@property (nonatomic, strong) NSArray * dimensions;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger includeTrackCount;
@property (nonatomic, strong) NSString * intro;
@property (nonatomic, assign) NSInteger isFinished;
@property (nonatomic, strong) NSString * kind;
@property (nonatomic, assign) NSInteger orderNum;
@property (nonatomic, assign) NSInteger playCount;
@property (nonatomic, assign) NSInteger publishAt;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) NSInteger updatedAt;
@property (nonatomic, assign) BOOL isPaid;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
-(NSDictionary *)toDictionary;
@end
