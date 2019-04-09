//
//	XMAlbum.h
//
//	Create by 王瑞 on 28/8/2015
//	Copyright © 2015. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>
#import "XMAnnouncer.h"
#import "XMLastUptrack.h"

@interface XMAlbum : NSObject

@property (nonatomic, strong) NSString * albumIntro;
@property (nonatomic, strong) NSString * albumTags;
@property (nonatomic, strong) NSString * albumTitle;
@property (nonatomic, strong) XMAnnouncer * announcer;
@property (nonatomic, strong) NSString * coverUrlLarge;
@property (nonatomic, strong) NSString * coverUrlMiddle;
@property (nonatomic, strong) NSString * coverUrlSmall;
@property (nonatomic, assign) NSInteger favoriteCount;
@property (nonatomic, assign) NSInteger albumId;
@property (nonatomic, assign) NSInteger includeTrackCount;
@property (nonatomic, assign) NSInteger isFinished;
@property (nonatomic, strong) NSString * kind;
@property (nonatomic, strong) XMLastUptrack * lastUptrack;
@property (nonatomic, assign) NSInteger playCount;
@property (nonatomic, assign) NSInteger subscribeCount;

@property (nonatomic, assign) double createdAt;
@property (nonatomic, assign) double updatedAt;

//可否下载，YES-可下载，NO-不可下载
@property (nonatomic, assign) BOOL canDownload;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;


//--------------------------------付费相关----------------------------------------------------
/**
 *   是否是付费专辑，-1 - 无此属性；0 - 免费专辑；1 - 付费专辑
 */
@property (nonatomic, assign) NSInteger isPaid;

/**
 *   专辑内声音排序是否自然序，自然序是指先上传的声音在前面，晚上传的声音在后面
 */
@property (nonatomic, assign) BOOL tracksNaturalOrdered;

/**
 *   是否支持试听
 */
@property (nonatomic, assign) BOOL hasSample;

/**
 *   预计更新多少集
 */
@property (nonatomic, assign) NSInteger estimatedTrackCount;

/**
 *   专辑内包含的整条免费听声音总数
 */
@property (nonatomic, assign) NSInteger freeTrackCount;

/**
 *   支持的购买类型，1-只支持分集购买，2-只支持整张专辑购买，3-同时支持分集购买和整张专辑购买
 */
@property (nonatomic, assign) NSInteger composedPriceType;

/**
 *   专辑富文本简介
 */
@property (nonatomic, strong) NSString *albumRichIntro;

/**
 *   主讲人介绍
 */
@property (nonatomic, strong) NSString *speakerIntro;

/**
 *   专辑内整条免费听声音ID列表，英文逗号分隔
 */
@property (nonatomic, strong) NSString *freeTrackIds;

/**
 *   营销简介
 */
@property (nonatomic, strong) NSString *saleIntro;

/**
 *   对应喜马拉雅APP上的“你将获得”，主要卖点，是由UGC主播提供的富文本
 */
@property (nonatomic, strong) NSString *expectedRevenue;

/**
 *   购买须知，富文本
 */
@property (nonatomic, strong) NSString *buyNotes;

/**
 *   主讲人自定义标题
 */
@property (nonatomic, strong) NSString *speakerTitle;

/**
 *   主讲人自定义标题下的内容，富文本
 */
@property (nonatomic, strong) NSString *speakerContent;

/**
 *   付费专辑详情页焦点图，无则返回空字符串””
 */
@property (nonatomic, strong) NSString *detailBannerUrl;

/**
 *   支持的详细价格模型列表
 */
//@property (nonatomic, strong) XMPriceTypeDetail *priceTypeDetail;
@property (nonatomic, strong) NSString *priceTypeDetail;

/**
 *   专辑评分
 */
@property (nonatomic, assign) NSInteger albumScore;

/**
 *   目标人群或适合谁听
 */
@property (nonatomic, strong) NSString *targetCloud;

@end
