//
//  CTDisplayView.h
//  CoreTextDemo
//
//  Created by yung on 2017/7/25.
//  Copyright (c) 2017年 yung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreTextData.h"
#import <UIKit/UIKit.h>

extern NSString *const CTDisplayViewImagePressed;
extern NSString *const CTDisplayViewLinkPressed;

typedef void(^CTDisplayHandler)(NSDictionary *data);

@interface CTDisplayView : UIView

@property (strong, nonatomic) CoreTextData * data;

@property (nonatomic, copy) CTDisplayHandler handler;

@end
