//
//  ZSDBManager.h
//  zhuishushenqi
//
//  Created by yung on 2018/11/22.
//  Copyright © 2018年 QS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZSDBPropertyModel.h"

@protocol ZSDBModel <NSObject>

- (NSString *)tableName;
- (NSString *)primaryKey;
- (NSString *)foreignKey;
- (NSDictionary <NSString *,NSString *>*)dbColumnMapping;
- (NSArray <NSString *>*)ignoredKeys;

@end

@interface ZSDBManager : NSObject

+ (instancetype)share;

- (NSArray <ZSDBPropertyModel *>*)getPropertys:(NSObject *)model;

@end

