//
//  CTFrameParserConfig.m
//  CoreTextDemo
//
//  Created by caonongyun on 2017/7/25.
//  Copyright © 2017年 QS. All rights reserved.
//

#import "CTFrameParserConfig.h"

#define RGB(A, B, C)    [UIColor colorWithRed:A/255.0 green:B/255.0 blue:C/255.0 alpha:1.0]


@implementation CTFrameParserConfig

- (id)init {
    self = [super init];
    if (self) {
        _width = [UIScreen mainScreen].bounds.size.width;
        _fontSize = 20.0f;
        _lineSpace = 5.0f;
        _textColor = RGB(108, 108, 108);
    }
    return self;
}


@end
