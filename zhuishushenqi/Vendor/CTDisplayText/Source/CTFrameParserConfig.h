//
//  CTFrameParserConfig.h
//  CoreTextDemo
//
//  Created by yung on 2017/7/25.
//  Copyright (c) 2017年 yung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CTFrameParserConfig : NSObject

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) CGFloat lineSpace;
@property (nonatomic, assign) CGFloat paragraphSpace;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *textFont;

@end
