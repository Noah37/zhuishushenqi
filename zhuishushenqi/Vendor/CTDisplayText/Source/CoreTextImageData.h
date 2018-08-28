//
//  CoreTextImageData.h
//  CoreTextDemo
//
//  Created by caonongyun on 2017/7/25.
//  Copyright (c) 2017年 caonongyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface CoreTextImageData : NSObject

@property (strong, nonatomic) NSString * name;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, copy) NSString *url;

@property (nonatomic) long position;

// 此坐标是 CoreText 的坐标系，而不是UIKit的坐标系
@property (nonatomic, assign) CGRect imagePosition;

@end
