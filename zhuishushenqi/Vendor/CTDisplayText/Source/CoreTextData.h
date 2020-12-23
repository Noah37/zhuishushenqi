//
//  CoreTextData.h
//  CoreTextDemo
//
//  Created by yung on 2017/7/25.
//  Copyright (c) 2017年 yung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreTextImageData.h"
#import <CoreText/CoreText.h>

@interface CoreTextData : NSObject

@property (assign, nonatomic) CTFrameRef ctFrame;
@property (assign, nonatomic) CGFloat height;
@property (strong, nonatomic) NSArray * imageArray;
@property (strong, nonatomic) NSArray * linkArray;
@property (strong, nonatomic) NSAttributedString *content;

@end
