//
//  CoreTextImageData.h
//  CoreTextDemo
//
//  Created by caonongyun on 2017/7/25.
//  Copyright © 2017年 QS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CoreTextImageData : NSObject

@property (strong, nonatomic) NSString * name;
@property (nonatomic) int position;

// 此坐标是 CoreText 的坐标系，而不是UIKit的坐标系
@property (nonatomic) CGRect imagePosition;

@end
