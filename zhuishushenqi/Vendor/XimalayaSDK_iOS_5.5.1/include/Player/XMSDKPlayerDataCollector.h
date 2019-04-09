//
//  XMSDKPlayerDataCollector.h
//  XMOpenPlatform
//
//  Created by nali on 16/1/29.
//
//

#import <Foundation/Foundation.h>



@interface XMTrackPlayDataCollectItem : NSObject

@property (nonatomic, assign) NSInteger     trackID;    //声音ID
@property (nonatomic, assign) double        duration;   //播放时长，单位秒。即播放一个音频过程中，真正处于播放中状态的总时间。
@property (nonatomic, assign) double        playedSecs; //播放第几秒或最后播放到的位置，是相对于这个音频开始位置的一个值。如果没有拖动播放条、快进、快退、暂停、单曲循环等操作，played_secs的值一般和duration一致。
@property (nonatomic, assign) long        startedAt;  //播放开始时刻，Unix毫秒数时间戳
@property (nonatomic, assign) NSInteger     playType;   //0：联网播放，1：断网播放
@end


@interface XMRadioPlayDataCollectItem : NSObject

@property (nonatomic, assign) NSInteger     radioID;            //电台ID
@property (nonatomic, assign) NSInteger     programScheduleID;  //节目排期ID
@property (nonatomic, assign) NSInteger     programID;          //节目ID
@property (nonatomic, assign) double        duration;           //播放时长，单位秒。即播放一个音频过程中，真正处于播放中状态的总时间。
@property (nonatomic, assign) double        playedSecs;         //播放第几秒或最后播放到的位置，是相对于这个音频开始位置的一个值。如果没有拖动播放条、快进、快退、暂停、单曲循环等操作，played_secs的值一般和duration一致。
@property (nonatomic, assign) long        startedAt;          //播放开始时刻，Unix毫秒数时间戳

@end


@interface XMSDKPlayerDataCollector : NSObject



+ (XMSDKPlayerDataCollector *)sharedInstance;

/**
 * 向喜马拉雅发送播放track的统计数据（单个）
 */
- (void)sendTrackPlayDataWithItem:(XMTrackPlayDataCollectItem*)item;

/**
 * 向喜马拉雅发送播放track的统计数据（批量）
 */
- (void)sendTrackPlayDataWithItems:(NSArray*)items;

/**
 * 向喜马拉雅发送播放radio的统计数据（单个）
 */
- (void)sendRadioPlayDataWithItem:(XMRadioPlayDataCollectItem*)item;

/**
 * 向喜马拉雅发送播放radio的统计数据（批量）
 */
- (void)sendRadioPlayDataWithItems:(NSArray*)items;

@end
