//
//  XMCacheTrack.h
//  XMOpenPlatform
//
//  Created by chesterchen on 8/30/16.
//
//

#import "XMTrack.h"

@interface XMCacheTrack : XMTrack


@property   (nonatomic, assign) NSTimeInterval  cacheTime;

// 下载信息
- (void)updateDownloadInfoFromDict:(NSDictionary *)dict;

- (void)copyPropertiesFrom:(XMCacheTrack *)sound;

@end
