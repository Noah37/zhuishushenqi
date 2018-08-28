//
//  CTDisplayView.h
//  CoreTextDemo
//
//  Created by caonongyun on 2017/7/25.
//  Copyright (c) 2017年 caonongyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreTextData.h"
#import <UIKit/UIKit.h>

extern NSString *const CTDisplayViewImagePressedNotification;
extern NSString *const CTDisplayViewLinkPressedNotification;

@interface CTDisplayView : UIView

@property (strong, nonatomic) CoreTextData * data;

@end
