//
//  CTFrameParser.h
//  CoreTextDemo
//
//  Created by caonongyun on 2017/7/25.
//  Copyright © 2017年 QS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreTextData.h"
#import "CTFrameParserConfig.h"


@interface CTFrameParser : NSObject

+ (CoreTextData *)parseTemplateFile:(NSString *)path config:(CTFrameParserConfig*)config;
+ (NSMutableDictionary *)attributesWithConfig:(CTFrameParserConfig *)config;
+ (CoreTextData *)parseAttributedContent:(NSAttributedString *)attributeContext config:(CTFrameParserConfig*)config;
+ (CoreTextData *)parseContent:(NSString *)content config:(CTFrameParserConfig*)config;

@end

