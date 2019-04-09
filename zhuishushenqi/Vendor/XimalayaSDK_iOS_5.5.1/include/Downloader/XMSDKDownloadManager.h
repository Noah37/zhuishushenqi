//
//  XMSDKDownloadManager.h
//  XMOpenPlatform
//
//  Created by chesterchen on 9/5/16.
//
//

#import <Foundation/Foundation.h>
#import "XMSDK.h"
#import "XMSingleTone.h"

@class XMTrackDownloadStatus;

@protocol SDKDownloadMgrDelegate <NSObject>

#pragma mark 代理回调

@optional

/**
 *   下载失败时被调用
 */
- (void)XMTrackDownloadDidFailed:(XMTrack *)track;

/**
 *   下载完成时被调用
 */
- (void)XMTrackDownloadDidFinished:(XMTrack *)track;

/**
 *   下载开始时被调用
 */
- (void)XMTrackDownloadDidBegan:(XMTrack *)track;

/**
 *   下载取消时被调用
 */
- (void)XMTrackDownloadDidCanceled:(XMTrack *)track;

/**
 *   下载暂停时被调用
 */
- (void)XMTrackDownloadDidPaused:(XMTrack *)track;

/**
 *   下载进度更新时被调用
 */
- (void)XMTrack:(XMTrack *)track updateDownloadedPercent:(double)downloadedPercent;

/**
 *   下载状态更新为ready时被调用
 */
- (void)XMTrackDownloadStatusUpdated:(XMTrack *)track;

/**
 *   从数据库载入数据完成时被调用
 */
- (void)XMTrackDownloadDidLoadFromDB;

@end

@interface XMSDKDownloadManager : NSObject

@property (nonatomic, assign) id <SDKDownloadMgrDelegate> sdkDownloadMgrDelegate;

//初始化方法
DECLARE_SINGLETON_METHOD(XMSDKDownloadManager, sharedSDKDownloadManager)


#pragma mark 全局配置接口

/**
 *  设置下载音频文件的保存目录
 *  默认路径：~/Documents/iDoc/Download/...
 *  请确保自定义设置的saveDir有效，否则仍会保存到默认路径
 *  @param saveDir NSString
 */
- (void)settingDownloadAudioSaveDir:(NSString *)saveDir;

/**
 *  获取下载音频文件的保存目录
 *
 *  @return saveDir
 */
- (NSString *)getDownloadAudioSaveDir;

/**
 *  获取下载文件已占用的磁盘空间，单位字节
 *
 *  @return bytes
 */
- (unsigned long long)getDownloadOccupationInBytes;

#pragma mark 下载接口

/**
 *  下载单条音频
 *
 *  @param track 
 *  @param ifImmediate 是否立即下载，若否，只注册不下载
 *
 *  @return 返回值含义 (0:已加入下载队列；1:已下载完成；2:URL无效；4:正在下载；5:数据库错误；9:此音频不允许被下载；10:已注册但不立即下载；21:此音频正在下载中；22:此音频已下载)
 */
- (int)downloadSingleTrack:(XMTrack *)track immediately:(BOOL)ifImmediate;

/**
 *  批量下载音频
 *
 *  @param tracks 单次批量下载数量不超过50
 *  @param ifImmediate 是否立即下载，若否，只注册不下载
 *
 */
- (void)downloadTracks:(NSMutableArray *)tracks immediately:(BOOL)ifImmediate;

#pragma mark 暂停下载接口

/**
 *  暂停单条音频下载
 *
 */
- (void)pauseDownloadSingleTrack:(XMTrack *)track;

/**
 *   批量暂停音频下载
 *
 */
- (void)pauseDownloadTracks:(NSMutableArray *)tracks;

/**
 *   暂停某专辑中全部音频下载
 *
 */
- (void)pauseDownloadTracksInAlbum:(NSInteger)albumId;

/**
 *  暂停全部音频下载
 *
 */
- (void)pauseAllDownloads;

#pragma mark 恢复下载接口

/**
 *  恢复被暂停的单条音频下载任务
 *  注：此接口会立即开始下载 immediately
 *
 */
- (void)resumeDownloadSingleTrack:(XMTrack *)track;

/**
 *  批量恢复被暂停的音频下载任务
 *  注：此接口会立即开始下载 immediately
 *
 */
- (void)resumeDownloadTracks:(NSMutableArray *)tracks;

/**
 *  恢复被暂停的某专辑中的全部音频下载
 *  注：此接口会立即开始下载 immediately
 *
 */
- (void)resumeDownloadTracksInAlbum:(NSInteger)albumId;

/**
 *  恢复被暂停的全部音频下载任务
 *  注：此接口会立即开始下载 immediately
 *
 */
- (void)resumeAllDownloads;

#pragma mark 取消下载接口
//取消下载：只对准备下载和正在下载状态的音频有效

/**
 *  取消单条音频下载，已下载部分也会被删除
 *
 */
- (void)cancelDownloadSingleTrack:(XMTrack *)track;

/**
 *  批量取消音频下载，已下载部分也会被删除
 *
 */
- (void)cancelDownloadTracks:(NSMutableArray *)tracks;

/**
 *  取消某专辑中全部音频下载，已下载部分也会被删除
 *
 */
- (void)cancelDownloadTracksInAlbum:(NSInteger)albumId;

/**
 *  取消全部音频下载，已下载部分也会被删除
 *
 */
- (void)cancelAllDownloads;

#pragma mark 清除接口

/**
 *  清除单个音频，不管是已下载，正在下载还是准备下载，都会被删除
 *
 */
- (void)clearDownloadAudio:(XMTrack *)track;

/**
 *  批量清除音频，不管是已下载，正在下载还是准备下载，都会被删除
 *
 */
- (void)clearDownloadTracks:(NSMutableArray *)tracks;

/**
 *  指定清除某专辑中的音频，不管是已下载，正在下载还是准备下载，都会被删除
 *
 */
- (void)clearDownloadAlbum:(NSInteger)albumId;

/**
 *  清除全部音频，不管是已下载，正在下载还是准备下载，都会被删除
 *
 */
- (void)clearAllDownloads;

#pragma mark 获取下载状态／音频／专辑信息接口
/* 获取状态的接口请在XMTrackDownloadDidLoadFromDB回调触发后再调用，否则可能会出现获取不到状态的情况 */

/**
 *  获取单个音频下载状态
 *  @param trackId
 *
 */
- (XMTrackDownloadStatus *)getSingleTrackDownloadStatus:(NSInteger)trackId;

/**
 *  批量获取音频下载状态
 *  @param trackId的数组
 *  @return 字典 key:trackId NSNumber, value:XMTrackDownloadStatus
 */
- (NSMutableDictionary *)getBatchTrackDownloadStatus:(NSMutableArray *)trackIds;

/**
 *  获取某专辑中全部音频的下载状态
 *  @param albumId
 *  @return 字典 key:trackId NSNumber, value:XMTrackDownloadStatus
 */
- (NSMutableDictionary *)getTrackInAlbumDownloadStatus:(NSInteger)albumId;

/**
 *  获取全部音频下载状态
 *  @return 字典 key:trackId NSNumber, value:XMTrackDownloadStatus
 */
- (NSMutableDictionary *)getAllDownloadStatus;

/**
 *  获取全部下载中的音频
 *  @return XMCacheTrack array
 */
- (NSArray *)getDownloadingSounds;

/**
 *  获取已下载音频
 *  @return XMCacheTrack array
 */
- (NSMutableArray *)getDownloadedTracks;

/**
 *  获取已下载的专辑
 *  @return XMSubordinatedAlbum array
 */
- (NSMutableArray *)getDownloadedAlbums;

/**
 *  获取某专辑中已下载的音频
 *  @return XMCacheTrack array
 */
- (NSMutableArray *)getDownloadedTrackInAlbum:(NSInteger)albumId;


@end
