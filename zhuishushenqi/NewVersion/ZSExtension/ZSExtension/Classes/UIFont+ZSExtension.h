//
//  UIFont+ZSExtension.h
//  zhuishushenqi
//
//  Created by caony on 2018/9/14.
//  Copyright © 2018年 QS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (ZSExtension)

/**
 *  Create a font array from path while ttc is a colleciton of font.
 *
 *  @param path       Path of the font.
 *  @param size       Font size that you want.
 */
-(NSArray*)customFontArrayWithPath:(NSString*)path size:(CGFloat)size;

/**
 *  Create a font from path,TTF,OTF available.
 *
 *  @param path       Path of the font.
 *  @param size       Font size that you want.
 */
-(UIFont*)customFontWithPath:(NSString*)path size:(CGFloat)size;

@end
