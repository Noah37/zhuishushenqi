//
//  XMADAudioPlayer.h
//  ting
//
//  Created by kuben on 15/5/6.
//
//

#import <Foundation/Foundation.h>
#import "XMSingleTone.h"

typedef  void (^XMDoneBlock)(void);

@class  XMADAudioItem;

/*
 * @brief  audio player start notification for NSNotificationCenter
 */
extern  NSString*    AdAudioPlayedDidStartNotification ;

/*
 * @brief
 */

extern  NSString*    AdAudioPlayedDidPauseNotification ;


extern  NSString*    AdAudioPlayedDidPauseStartNotification;

/*
 * @brief  audio player end  notification  for NSNotificationCenter
 */
extern  NSString*    AdAudioPlayedDidEndNotification ;

/**
 * @brief audio player data ready
 */

extern  NSString*    AdAudioDataDidGetNotification ;




@interface XMADAudioPlayer : NSObject

DECLARE_SINGLETON_METHOD(XMADAudioPlayer,sharedPlayer);

/* 
 * @brief audio player Done to do some thing
 *
 */

@property (nonatomic, copy)XMDoneBlock  playDoneBlock;

- (XMADAudioItem*)currentPlayAdItem;

- (void)playSound:(NSURL*)sounURL withSoundId:(long)soundId;

- (void)playAdSound:(XMADAudioItem*)adItem;

- (void)pause;

- (BOOL)isRunningSoundLogo;

- (BOOL)isAdAudioPlaying:(long)soundId;

- (void)setRunningSoundLogoStatus:(BOOL)status;

- (BOOL)isPlaying;
/**
 * remove ad cache
 */

- (void)checkAndRemoveAudioCache;

@end
