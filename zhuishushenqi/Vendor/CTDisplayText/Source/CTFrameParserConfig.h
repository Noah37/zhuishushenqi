//
//  CTFrameParserConfig.h
//  CoreTextDemo
//
//  Created by caonongyun on 2017/7/25.
//  Copyright (c) 2017年 caonongyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CTFrameParserConfig : NSObject

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) CGFloat lineSpace;
@property (nonatomic, assign) CGFloat paragraphSpace;
@property (nonatomic, strong) UIColor *textColor;

@end
