//
//  CTFrameParser.h
//  CoreTextDemo
//
//  Created by caonongyun on 2017/7/25.
//  Copyright (c) 2017年 caonongyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreTextData.h"
#import "CTFrameParserConfig.h"

@interface CTFrameParser : NSObject

+ (NSMutableDictionary *)attributesWithConfig:(CTFrameParserConfig *)config;

+ (CoreTextData *)parseContent:(NSString *)content config:(CTFrameParserConfig*)config;

+ (CoreTextData *)parseAttributedContent:(NSAttributedString *)content config:(CTFrameParserConfig*)config;

+ (CoreTextData *)parseTemplateFile:(NSString *)path config:(CTFrameParserConfig*)config;

+ (CoreTextData *)parseString:(NSString *)string config:(CTFrameParserConfig *)config;
@end
