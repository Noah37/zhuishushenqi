//
//  MonitorFileCChangeHelp.m
//  MonitorFilesChange
//
//  Created by lingyohunl on 2016/11/17.
//  Copyright © 2016年 yohunl. All rights reserved.
//

#import "MonitorFileChangeHelp.h"
@interface MonitorFileChangeHelp ()
{
@private
  
  NSURL *_fileURL;
  dispatch_source_t _source;
  int _fileDescriptor;
  BOOL _keepMonitoringFile;
}
@property (nonatomic,copy) void (^fileChangeBlock)(NSInteger type);


@end
@implementation MonitorFileChangeHelp
- (void)watcherForPath:(NSString *)aPath block:(void (^)(NSInteger type))block;{
  self.fileChangeBlock = block;
  NSURL *url = [NSURL URLWithString:aPath];
  _fileURL = url;
  _keepMonitoringFile = NO;
  [self __beginMonitoringFile];
  
}


- (void)dealloc
{
  dispatch_source_cancel(_source);
}

- (void)__beginMonitoringFile
{
  
  _fileDescriptor = open([[_fileURL path] fileSystemRepresentation],
                         O_EVTONLY);
  dispatch_queue_t defaultQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
  _source = dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE,
                                   _fileDescriptor,
                                   DISPATCH_VNODE_ATTRIB | DISPATCH_VNODE_DELETE | DISPATCH_VNODE_EXTEND | DISPATCH_VNODE_LINK | DISPATCH_VNODE_RENAME | DISPATCH_VNODE_REVOKE | DISPATCH_VNODE_WRITE,
                                   defaultQueue);        
  dispatch_source_set_event_handler(_source, ^ {
    unsigned long eventTypes = dispatch_source_get_data(_source);
    [self __alertDelegateOfEvents:eventTypes];
  });
  
  dispatch_source_set_cancel_handler(_source, ^{
    close(_fileDescriptor);
    _fileDescriptor = 0;
    _source = nil;

    // If this dispatch source was canceled because of a rename or delete notification, recreate it
    if (_keepMonitoringFile) {
        _keepMonitoringFile = NO;
        [self __beginMonitoringFile];
    }
  });
  dispatch_resume(_source);
}

- (void)__recreateDispatchSource
{
  _keepMonitoringFile = YES;
  dispatch_source_cancel(_source);
}

- (void)__alertDelegateOfEvents:(unsigned long)eventTypes
{
  dispatch_async(dispatch_get_main_queue(), ^ {
    BOOL recreateDispatchSource = NO;
    NSMutableSet *eventSet = [[NSMutableSet alloc] initWithCapacity:7];
                 
    if (eventTypes & DISPATCH_VNODE_ATTRIB) {
      [eventSet addObject:@(DISPATCH_VNODE_ATTRIB)];
    }
    if (eventTypes & DISPATCH_VNODE_DELETE) {
      [eventSet addObject:@(DISPATCH_VNODE_DELETE)];
      recreateDispatchSource = YES;
    }
    if (eventTypes & DISPATCH_VNODE_EXTEND) {
       [eventSet addObject:@(DISPATCH_VNODE_EXTEND)];
    }
    if (eventTypes & DISPATCH_VNODE_LINK) {
       [eventSet addObject:@(DISPATCH_VNODE_LINK)];
    }
    if (eventTypes & DISPATCH_VNODE_RENAME){
      [eventSet addObject:@(DISPATCH_VNODE_RENAME)];
      recreateDispatchSource = YES;
    }
    if (eventTypes & DISPATCH_VNODE_REVOKE) {
      [eventSet addObject:@(DISPATCH_VNODE_REVOKE)];
    }
    if (eventTypes & DISPATCH_VNODE_WRITE) {
      [eventSet addObject:@(DISPATCH_VNODE_WRITE)];
    }
                 
    for (NSNumber *eventType in eventSet) {
       if (self.fileChangeBlock) {
         self.fileChangeBlock([eventType unsignedIntegerValue]);
       }
    } 
    if (recreateDispatchSource) {
      [self __recreateDispatchSource];
    }
  });
}

@end
