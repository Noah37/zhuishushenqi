//
//  MonitorFileChangeHelp.h
//  MonitorFilesChange
//
//  Created by lingyohunl on 2016/11/17.
//  Copyright © 2016年 yohunl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MonitorFileChangeHelp : NSObject
- (void)watcherForPath:(NSString *)aPath block:(void (^)(NSInteger type))block;
@end
