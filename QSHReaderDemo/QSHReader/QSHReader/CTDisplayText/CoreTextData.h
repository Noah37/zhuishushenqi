//
//  CoreTextData.h
//  CoreTextDemo
//
//  Created by caonongyun on 2017/7/25.
//  Copyright © 2017年 QS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@interface CoreTextData : NSObject

@property (assign, nonatomic) CTFrameRef ctFrame;
@property (assign, nonatomic) CGFloat height;

@property (strong, nonatomic) NSArray * imageArray;

@property (strong, nonatomic) NSArray * linkArray;

@end
