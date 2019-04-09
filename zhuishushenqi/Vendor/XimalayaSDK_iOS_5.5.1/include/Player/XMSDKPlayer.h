//
//  XMSDKPlayer.h
//  libXMOpenPlatform
//
//  Created by nali on 15/7/13.
//  Copyright (c) 2015年 ximalaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMSDK.h"
#import <CoreGraphics/CGBase.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSInteger, XMSDKPlayMode) {
    XMSDKPlayModeTrack = 0,
    XMSDKPlayModeLive
};

typedef NS_ENUM(NSInteger, XMSDKTrackPlayMode) {
    XMTrackPlayerModeList = 0,       // 列表 (默认)
    XMTrackModeSingle,         // 单曲循环
    XMTrackModeRandom,         // 随机顺序
    XMTrackModeCycle,          // 循环顺序
    
    XMTrackPlayerModeEnd          // mark for rounded
};

// PlayerState
typedef NS_ENUM(NSInteger, XMSDKPlayerState) {
    XMSDKPlayerStatePlaying = 0,         //正在播放
    XMSDKPlayerStatePaused,              //暂停
    XMSDKPlayerStateStop                 //停止或其他状态
};

// livePlayerState
typedef NS_ENUM(NSInteger, XMSDKLivePlayerState) {
    XMSDKLivePlayerStatePlaying = 0,         //正在播放
    XMSDKLivePlayerStatePaused,              //暂停
    XMSDKLivePlayerStateStop                 //停止或其他状态
};

//------------------------------------------------------------------------------------

#pragma mark - XMTrackPlayerDelegate

@protocol XMTrackPlayerDelegate <NSObject>

@optional
#pragma mark - process notification
//播放时被调用，频率为1s，告知当前播放进度和播放时间
- (void)XMTrackPlayNotifyProcess:(CGFloat)percent currentSecond:(NSUInteger)currentSecond;
//播放时被调用，告知当前播放器的缓冲进度
- (void)XMTrackPlayNotifyCacheProcess:(CGFloat)percent;

#pragma mark - player state change
//播放列表结束时被调用
- (void)XMTrackPlayerDidPlaylistEnd;
//将要播放时被调用
- (void)XMTrackPlayerWillPlaying;
//已经播放时被调用
- (void)XMTrackPlayerDidPlaying;
//暂停时调用
- (void)XMTrackPlayerDidPaused;
//停止时调用
- (void)XMTrackPlayerDidStopped;
//结束播放时调用
- (void)XMTrackPlayerDidEnd;
//切换声音时调用
- (void)XMTrackPlayerDidChangeToTrack:(XMTrack *)track;
//播放失败时调用
- (void)XMTrackPlayerDidFailedToPlayTrack:(XMTrack *)track withError:(NSError *)error;
//播放失败时是否继续播放下一首
- (BOOL)XMTrackPlayerShouldContinueNextTrackWhenFailed:(XMTrack *)track;
//成功替换播放列表时调用
- (void)XMTrackPlayerDidReplacePlayList:(NSArray *)list;
//播放数据请求失败时调用，data.description是错误信息
- (void)XMTrackPlayerDidErrorWithType:(NSString *)type withData:(NSDictionary*)data;
//- (void)XMTrackPlayerDidErrorWithType:(NSInteger)type withData:(NSDictionary*)data;

//没有网络情况下播放器因缓冲已播完而停止播放时触发
- (void)XMTrackPlayerDidPausePlayForBadNetwork;

@end

//------------------------------------------------------------------------------------

#pragma mark - XMLivePlayerDelegate

@protocol XMLivePlayerDelegate <NSObject>

@optional
#pragma mark - live radio

- (void)XMLiveRadioPlayerDidFailWithError:(NSError *)error;

- (void)XMLiveRadioPlayerNotifyCacheProgress:(CGFloat)percent;

- (void)XMLiveRadioPlayerNotifyPlayProgress:(CGFloat)percent currentTime:(NSInteger)currentTime;

- (void)XMLiveRadioPlayerDidEnd;

- (void)XMLiveRadioPlayerDidPaused;

- (void)XMLiveRadioPlayerDidPlaying;

- (void)XMLiveRadioPlayerDidStart;

- (void)XMLiveRadioPlayerDidStopped;

- (void)XMLivePlayerWillPlaying;

- (void)XMLivePlayerDidDataBufferStart;

- (void)XMLivePlayerDidDataBufferEnd;

@end

//------------------------------------------------------------------------------------

#pragma mark - XMSDKPlayer

@interface XMSDKPlayer : NSObject

+ (XMSDKPlayer *)sharedPlayer;

@property (nonatomic,assign) id<XMTrackPlayerDelegate>    trackPlayDelegate;
@property (nonatomic,assign) id<XMLivePlayerDelegate>    livePlayDelegate;

// 默认使用低码率的url进行播放，如果需要使用高码率，请将usingHighQualityUrl设置为YES；
@property (nonatomic,assign) BOOL usingHighQualityUrl;

// 每个声音都默认从上次中断处开始播放，如需要从头开始播放，请将usingResumeFromStart设置为YES；
@property (nonatomic,assign) BOOL usingResumeFromStart;
//如需要从指定时间开始播放，请将usingStartFromAppointedTime设置为YES，并设置指定时间appointedTime;
@property (nonatomic,assign) BOOL usingStartFromAppointedTime;
@property (nonatomic,assign) float appointedTime;

//音量属性，用于显示音量
@property (nonatomic,assign) float sdkPlayerVolume;

//播放状态
@property (nonatomic,assign,readonly) XMSDKPlayerState playerState;          //track播放状态
@property (nonatomic,assign,readonly) XMSDKLivePlayerState livePlayerState;  //live播放状态

//播放速率(范围：0.5~2.0)
@property (nonatomic, assign) CGFloat playRate; /* The play rate for the sound. 1.0 is normal, 0.5 is half speed, 2.0 is double speed. */

#pragma mark 配置相关方法

/**
 * 设置播放器播放模式：专辑播放、电台播放
 */
- (void)setPlayMode:(XMSDKPlayMode)playMode;
/**
 * 设置播放器的音量,volume范围：0～1
 */
- (void)setVolume:(float)volume;
/**
 *  获得播放器缓存的大小，第三方可以自己统计缓存大小
 */
- (unsigned long long)getTotalCacheSize;
/**
 *  重置播放速率，即恢复正常速率playRate=1.0
 */
- (void)resetPlaySpeed;

#pragma mark 播放相关方法

/**
 * 播放声音列表
 */
- (void)playWithTrack:(XMTrack *)track playlist:(NSArray *)playlist;
/**
 * 通过url进行播放
 */
- (void)playWithDecryptedUrl:(NSURL *)dUrl;
/**
 * 接着播上一次正在播放的专辑
 */
- (void)continuePlayFromAlbum:(NSInteger)albumID track:(NSInteger)trackID;
/**
 * 暂停当前播放
 */
- (void)pauseTrackPlay;
/**
 * 恢复当前播放
 */
- (void)resumeTrackPlay;
/**
 * 停止当前播放
 */
- (void)stopTrackPlay;
/**
 * 更新当前播放列表
 */
- (void)replacePlayList:(NSArray *)playlist;
/**
 * 是否有下一首
 */
+ (BOOL)hasNextTrack;
/**
 * 是否有上一首
 */
+ (BOOL)hasPrevTrack;
/**
 * 播放下一首
 */
- (BOOL)playNextTrack;
/**
 * 播放上一首
 */
- (BOOL)playPrevTrack;
/**
 * 设置播放器自动播放下一首
 */
- (void)setAutoNexTrack:(BOOL)status;
/**
 * 返回当前播放列表
 */
- (NSArray *)playList;
/**
 * 返回下一首
 */
- (XMTrack *)nextTrack;
/**
 * 返回上一首
 */
- (XMTrack *)prevTrack;
/**
 * 设置播放器从特定的时间播放
 */
- (void)seekToTime:(CGFloat)time;
/**
 * 清空缓存
 */
- (void)clearCacheSafely;
/**
 * 设置当前播放器的下一首选择模式：列表播放、单曲循环、随机、列表循环
 */
- (void)setTrackPlayMode:(XMSDKTrackPlayMode)trackPlayMode;
/**
 * 获取当前播放器的下一首选择模式：列表播放、单曲循环、随机、列表循环
 */
- (XMSDKTrackPlayMode)getTrackPlayMode;
/**
 * 返回当前播放的声音
 */
- (XMTrack*)currentTrack;

#pragma mark 电台相关方法

/**
 * 开始播放直播电台
 */
- (void)startLivePlayWithRadio:(XMRadio*)radio;
/**
 * 停止当前电台播放
 */
- (void)pauseLivePlay;
/**
 * 恢复当前电台播放
 */
- (void)resumeLivePlay;
/**
 * 停止当前电台播放
 */
- (void)stopLivePlay;
/**
 * 播放直播电台当前时间之前的节目
 */
- (void)startHistoryLivePlayWithRadio:(XMRadio*)radio withProgram:(XMRadioSchedule*)program;
/**
 * 播放直播电台当前时间之前的节目列表
 */
- (void)startHistoryLivePlayWithRadio:(XMRadio*)radio withProgram:(XMRadioSchedule*)program inProgramList:(NSArray*)list;
/**
 * 设置播放器到指定的时间播放
 */
- (BOOL)seekHistoryLivePlay:(double)durtion;
/**
 * 播放下一个录播电台节目
 */
- (void)playNextProgram;
/**
 * 播放上一个录播电台节目
 */
- (void)playPreProgram;
/**
 * 清理缓存(即上文同名方法)
 */
//- (void)clearCacheSafely;
/**
 * 返回当前正在播放的电台
 */
- (XMRadio*)currentPlayingRadio;
/**
 * 返回当前正在播放的节目
 */
- (XMRadioSchedule*)currentPlayingProgram;

@end
