//
//  NSString+Encode.h
//  zhuishushenqi
//
//  Created by yung on 2017/4/26.
//  Copyright © 2017年 QS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Encode)

- (NSString*)urlEncode;
- (NSString *)urlDecode;
- (NSString *)zs_urlDecode;

@end
