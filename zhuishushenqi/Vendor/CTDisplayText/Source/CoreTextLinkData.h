//
//  CoreTextLinkData.h
//  CoreTextDemo
//
//  Created by yung on 2017/7/25.
//  Copyright (c) 2017年 yung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreTextLinkData : NSObject

@property (strong, nonatomic) NSString * title;
@property (strong, nonatomic) NSString * url;
@property (assign, nonatomic) NSRange range;
// post或者booklist
@property (nonatomic, copy) NSString *linkTo;

// key一般为24位的ID,可以手动拼接成URL
@property (nonatomic, copy) NSString *key;

@end
