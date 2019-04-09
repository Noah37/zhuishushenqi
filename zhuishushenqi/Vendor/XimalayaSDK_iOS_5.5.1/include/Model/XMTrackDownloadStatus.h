//
//  XMTrackDownloadStatus.h
//  XMOpenPlatform
//
//  Created by chesterchen on 9/27/16.
//
//

#import <Foundation/Foundation.h>
#import "XMTrack.h"

@interface XMTrackDownloadStatus : NSObject

@property (nonatomic, assign) XMCacheTrackStatus state;
@property (nonatomic, assign) unsigned long  downloadedBytes;
@property (nonatomic, assign) unsigned long  totalBytes;
@property (nonatomic, assign) NSTimeInterval  timeStamp;

@end
