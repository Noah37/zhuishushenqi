//
//  ZSDBPropertyModel.h
//  zhuishushenqi
//
//  Created by caonongyun on 2018/11/23.
//  Copyright © 2018年 QS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSDBPropertyModel : NSObject

@property (nonatomic, copy) NSString *originalKey;
@property (nonatomic, copy) NSString *mappingKey;
@property (nonatomic, strong) id value;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) BOOL isPrimaryKey;

@end

