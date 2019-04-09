//
//	XMTrack.h
//
//	Create by 王瑞 on 24/8/2015
//	Copyright © 2015. All rights reserved.
//

//	 

#import <UIKit/UIKit.h>
#import "XMAnnouncer.h"
#import "XMSubordinatedAlbum.h"

// 下载状态
typedef NS_ENUM(NSInteger, XMCacheTrackStatus) {
    XMCacheTrackStatusReady = 20, //!<准备下载
    XMCacheTrackStatusDownloading, //!<下载中
    XMCacheTrackStatusDownloaded, //!<已下载
    XMCacheTrackStatusPausedBySystem, //!<非人为暂停
    XMCacheTrackStatusPausedByUser, //!<人为暂停
    XMCacheTrackStatusCancelled, //!<已取消下载
    XMCacheTrackStatusFailed, //!<下载失败
    
    XMCacheTrackStatusHeld //!<只注册，不立即下载
};

@interface XMTrack : NSObject<NSCoding>

@property (nonatomic, strong) XMAnnouncer * announcer;
@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic, strong) NSString * coverUrlLarge;
@property (nonatomic, strong) NSString * coverUrlMiddle;
@property (nonatomic, strong) NSString * coverUrlSmall;
@property (nonatomic, assign) NSInteger downloadCount;
@property (nonatomic, assign) NSInteger downloadSize;
@property (nonatomic, strong) NSString * downloadUrl;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, assign) NSInteger favoriteCount;
@property (nonatomic, assign) NSInteger trackId;
@property (nonatomic, strong) NSString * kind;
@property (nonatomic, assign) NSInteger orderNum;
@property (nonatomic, assign) NSInteger playCount;
@property (nonatomic, assign) NSInteger playSize24M4a;
@property (nonatomic, assign) NSInteger playSize32;
@property (nonatomic, assign) NSInteger playSize64;
@property (nonatomic, assign) NSInteger playSize64M4a;
@property (nonatomic, strong) NSString * playUrl24M4a; //!< 24码率M4A格式播放地址
@property (nonatomic, strong) NSString * playUrl32;    //!< 32码率MP3格式播放地址
@property (nonatomic, strong) NSString * playUrl64;    //!< 64码率MP3格式播放地址
@property (nonatomic, strong) NSString * playUrl64M4a; //!< 64码率M4A格式播放地址

@property (nonatomic, strong) NSString * playUrlAmr;   //!< 声音AMR格式地址
@property (nonatomic, assign) NSInteger playSizeAmr;  //!< 声音AMR格式大小

@property (nonatomic, assign) NSInteger source;
@property (nonatomic, strong) XMSubordinatedAlbum * subordinatedAlbum;
@property (nonatomic, strong) NSString * trackIntro;
@property (nonatomic, strong) NSString * trackTags;
@property (nonatomic, strong) NSString * trackTitle;

@property (nonatomic, assign) double updatedAt;
@property (nonatomic, assign) double createdAt;

//可否下载，YES-可下载，NO-不可下载
@property (nonatomic, assign) BOOL canDownload;

@property (nonatomic, assign) BOOL  playing;
@property (nonatomic, assign) BOOL  pause;

@property (nonatomic, strong) NSDate *startPlayTime;

@property (nonatomic, assign) NSInteger   listenedTime;
@property (nonatomic, assign) NSInteger   listenedPosition;


@property (nonatomic, assign) XMCacheTrackStatus status;
@property (nonatomic, copy  ) NSString       *filePath;

@property (nonatomic, assign) unsigned long  downloadedBytes;
@property (nonatomic, assign) unsigned long  totalBytes;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;

- (void)copyPropertiesFrom:(XMTrack *)sound;

//--------------------------------付费相关----------------------------------------------------
/**
 *   是否付费，固定值true
 */
@property (nonatomic, assign) BOOL isPaid;

/**
 *   声音是否整条免费听
 */
@property (nonatomic, assign) BOOL isFree;

/**
 *   是否加V。如果这条声音是转采的，则announcer是上传原始专辑的主播
 */
@property (nonatomic, assign) BOOL isVerified;

/**
 *   是否片花，片花声音一定是整条免费听声音
 */
@property (nonatomic, assign) BOOL isTrailer;

/**
 *   是否支持试听
 */
@property (nonatomic, assign) BOOL hasSample;

/**
 *   是否已购买
 */
@property (nonatomic, assign) BOOL isBought;

/**
 *   试听时长，如果不支持试听则这个试听时长为0
 */
@property (nonatomic, assign) NSInteger sampleDuration;

/**
 *   判断是否为付费音频
 */
- (BOOL)isPayTrack;

@end
