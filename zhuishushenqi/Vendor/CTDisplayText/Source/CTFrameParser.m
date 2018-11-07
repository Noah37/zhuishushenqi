//
//  CTFrameParser.m
//  CoreTextDemo
//
//  Created by caonongyun on 2017/7/25.
//  Copyright (c) 2017年 caonongyun. All rights reserved.
//

#import "CTFrameParser.h"
#import "CTFrameParserConfig.h"
#import "CoreTextImageData.h"
#import "CoreTextLinkData.h"
#import "RegexKitLite.h"

//《❤温馨小贴士》
static NSString *const kImageViewPattern = @"(《.*?》)";

//static NSString *const kImageViewPattern = @"(?<name>《.*?》)";

//[[post:5b50550d6f788aef59667822 【传送门】告别燥热？这样玩转书单还有惊喜大礼！]]
static NSString *const kTextLinkPattern = @"(\\[\\[.*?\\]\\])";

//{{type:image,url:http%3A%2F%2Fstatics.zhuishushenqi.com%2Fpost%2F151678369762541,size:420-422}}
static NSString *const kBookPattern = @"(\\{\\{.*?\\}\\})";
// 环视
//static NSString *const kBookPattern = @"(?<name>《.*?》)";

static NSMutableArray *imageInfoArr;

@implementation CTFrameParser


static CGFloat ascentCallback(void *ref){
    NSDictionary *dict = [(__bridge NSDictionary*)ref copy];
    return [(NSNumber*)[dict objectForKey:@"height"] floatValue];
}

static CGFloat descentCallback(void *ref){
    return 0;
}

static CGFloat widthCallback(void* ref){
    return [(NSNumber*)[(__bridge NSDictionary*)ref objectForKey:@"width"] floatValue];

}

+ (NSMutableDictionary *)attributesWithConfig:(CTFrameParserConfig *)config {
    CGFloat fontSize = config.fontSize;
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)config.textFont.fontName, fontSize, NULL);
//    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
    CGFloat lineSpacing = config.lineSpace;
    const CFIndex kNumberOfSettings = 3;
    CTParagraphStyleSetting theSettings[kNumberOfSettings] = {
        { kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat), &lineSpacing },
        { kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(CGFloat), &lineSpacing },
        { kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(CGFloat), &lineSpacing }
    };
    
    CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, kNumberOfSettings);
    
    UIColor * textColor = config.textColor;
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[(id)kCTForegroundColorAttributeName] = (id)textColor.CGColor;
    dict[(id)kCTFontAttributeName] = (__bridge id)fontRef;
    dict[(id)kCTParagraphStyleAttributeName] = (__bridge id)theParagraphRef;
    
    CFRelease(theParagraphRef);
    CFRelease(fontRef);
    return dict;
}

+ (CoreTextData *)parseString:(NSString *)string config:(CTFrameParserConfig *)config{
    NSMutableArray *imageArray = [NSMutableArray array];
    NSMutableArray *linkArray = [NSMutableArray array];
    NSAttributedString *content = [self zs_loadString:string config:config imageArray:imageArray linkArray:linkArray];
    CoreTextData *data = [self parseAttributedContent:content config:config];
    data.imageArray = imageArray;
    data.linkArray = linkArray;
    return data;
}

+ (NSAttributedString *)zs_loadString:(NSString *)string
                                  config:(CTFrameParserConfig*)config
                              imageArray:(NSMutableArray *)imageArray
                               linkArray:(NSMutableArray *)linkArray {
    NSString *pattern = [NSString stringWithFormat:@"%@|%@|%@",kImageViewPattern,kTextLinkPattern,kBookPattern];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] init];
    imageInfoArr = @[].mutableCopy;
    __block NSRange lastRange = NSMakeRange(0, 0);
    __block BOOL exist = NO;
    [string enumerateStringsMatchedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        exist = YES;
//        NSLog(@"%@ %@", *capturedStrings, NSStringFromRange(*capturedRanges));
        NSString *text = [string substringWithRange:NSMakeRange(lastRange.location +lastRange.length, (*capturedRanges).location - lastRange.location - lastRange.length)];
        NSLog(@"text:%@",text);
        // 1.处理文字
        if (text.length > 0) {
            NSDictionary *textDict = @{@"size":@"13",
                                       @"type":@"txt",
                                       @"color":@"black",
                                       @"content":text
                                       };
            NSAttributedString *as = [self parseOnlyContentFromNSDictionary:textDict config:config];
            [attributeString appendAttributedString:as];
        }
        //2.处理图片
        if ([*capturedStrings rangeOfString:@"{{"].location != NSNotFound) {
            NSString *string = [*capturedStrings stringByReplacingOccurrencesOfString:@"{{" withString:@""];
            string = [*capturedStrings stringByReplacingOccurrencesOfString:@"}}" withString:@""];
            NSDictionary *imageDict = [self parseImageStr:string];
            NSString *size = imageDict[@"size"];
            NSArray *sizeInfo = [size componentsSeparatedByString:@"-"];
            CoreTextImageData *imageData = [[CoreTextImageData alloc] init];
            imageData.url = imageDict[@"url"];
            imageData.size = CGSizeMake([sizeInfo.firstObject floatValue], [sizeInfo.lastObject floatValue]);
            imageData.position = [attributeString length];
            [imageArray addObject:imageData];
            // 图片宽度如果大于config的宽度,按比例缩放
            CGFloat imageWidth = [sizeInfo.firstObject floatValue];
            CGFloat imageHeight  = [sizeInfo.lastObject floatValue];
            if (imageWidth > config.width) {
                CGFloat scale = config.width/imageWidth;
                imageWidth = config.width;
                imageHeight = imageHeight * scale;
            }
            NSDictionary *imageInfo = @{@"width": @(imageWidth),
                                        @"height":@(imageHeight),
                                        @"type":[NSString stringWithFormat:@"%@",imageDict[@"type"]],
                                        @"url":[NSString stringWithFormat:@"%@",imageDict[@"url"] ],
                                        @"name":@"1234"
                                        };
            [imageInfoArr addObject:imageInfo];
            NSAttributedString *as = [self parseImageDataFromNSDictionary:imageInfo config:config];
            [attributeString appendAttributedString:as];
        } else
        //3.处理链接
        if ([*capturedStrings rangeOfString:@"[["].location != NSNotFound) {
//[[post:5b45ac11137888850bb1c69e 【传送门】报名阶段：7月11日~8月1日]]
            NSRange maohaoRange = [*capturedStrings rangeOfString:@":"];
            NSRange range = [*capturedStrings rangeOfString:@"[["];
            NSString *linkKey = [*capturedStrings substringWithRange:NSMakeRange(range.location + 2, maohaoRange.location - range.location - 2)];
            
            NSString *key = [*capturedStrings substringWithRange:NSMakeRange(maohaoRange.location + 1, 24)];
            NSString *content = [*capturedStrings substringFromIndex:maohaoRange.location + 26];
            content = [content stringByReplacingOccurrencesOfString:@"]]" withString:@""];
            NSUInteger startPos = attributeString.length;
            NSDictionary *linkInfo = @{@"type":@"link",
                                       @"key":key,
                                       @"color":@"orange",
                                       @"content":content,
                                       };
            NSAttributedString *as = [self parseAttributedContentFromNSDictionary:linkInfo
                                                                           config:config];
            [attributeString appendAttributedString:as];
            // 创建 CoreTextLinkData
            NSUInteger length = attributeString.length - startPos;
            NSRange linkRange = NSMakeRange(startPos, length);
            CoreTextLinkData *linkData = [[CoreTextLinkData alloc] init];
            linkData.title = [NSString stringWithFormat:@"%@",linkInfo[@"content"]];
            linkData.url = [NSString stringWithFormat:@"%@",linkInfo[@"url"]];
            linkData.key = [NSString stringWithFormat:@"%@",linkInfo[@"key"]];
            linkData.linkTo = [NSString stringWithFormat:@"%@",linkKey];
            linkData.range = linkRange;
            [linkArray addObject:linkData];
        } else
        //4.处理书籍传送
        if ([*capturedStrings rangeOfString:@"《"].location != NSNotFound) {
            NSUInteger startPos = attributeString.length;
            NSString *key = [*capturedStrings stringByReplacingOccurrencesOfString:@"《" withString:@""];
            key = [key stringByReplacingOccurrencesOfString:@"》" withString:@""];

            NSDictionary *linkInfo = @{@"type":@"link",
                                      @"key":key,
                                      @"color":@"orange",
                                      @"content":*capturedStrings
                                      };
            NSAttributedString *as = [self parseAttributedContentFromNSDictionary:linkInfo
                                                                           config:config];
            [attributeString appendAttributedString:as];
            // 创建 CoreTextLinkData
            NSUInteger length = attributeString.length - startPos;
            NSRange linkRange = NSMakeRange(startPos, length);
            CoreTextLinkData *linkData = [[CoreTextLinkData alloc] init];
            linkData.title = [NSString stringWithFormat:@"%@",linkInfo[@"content"]];
            linkData.url = [NSString stringWithFormat:@"%@",linkInfo[@"url"]];
            linkData.key = [NSString stringWithFormat:@"%@",linkInfo[@"key"]];
            linkData.range = linkRange;
            linkData.linkTo = @"search";
            [linkArray addObject:linkData];
        }
        // 如果后续
        lastRange = *capturedRanges;
    }];
    if (exist) {
        // 还需要添加最后的文本
        if (lastRange.location + lastRange.length < string.length) {
            NSString *lastString = [string substringFromIndex:lastRange.location + lastRange.length];
            NSDictionary *textDict = @{@"size":@"13",
                                       @"type":@"txt",
                                       @"color":@"black",
                                       @"content":lastString
                                       };
            NSAttributedString *as = [self parseOnlyContentFromNSDictionary:textDict config:config];
            [attributeString appendAttributedString:as];
        }
        return  attributeString;
    } else {
        UIColor *textColor = [UIColor blackColor];
        UIFont *textFont = [UIFont systemFontOfSize:15];
        if (config.textColor) {
            textColor = config.textColor;
        }
        if (config.textFont) {
            textFont = config.textFont;
        }
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
        [attr addAttributes:@{NSForegroundColorAttributeName:textColor,
                              NSFontAttributeName:textFont
                              } range:NSMakeRange(0, attr.length)];
        [attributeString appendAttributedString:attr];
    }
    return attributeString;
}

+ (NSDictionary *)parseImageStr:(NSString *)imageStr{
    NSMutableDictionary *dict = @{}.mutableCopy;
    NSArray *params = [imageStr componentsSeparatedByString:@","];
    for (NSString *param in params) {
        NSArray *arr = [param componentsSeparatedByString:@":"];
        if (arr.count > 1) {
            dict[arr[0]] = arr[1];
        }
    }
    return [dict copy];
}

+ (CoreTextData *)parseTemplateFile:(NSString *)path config:(CTFrameParserConfig*)config {
    NSMutableArray *imageArray = [NSMutableArray array];
    NSMutableArray *linkArray = [NSMutableArray array];
    NSAttributedString *content = [self loadTemplateFile:path config:config
                                              imageArray:imageArray linkArray:linkArray];
    CoreTextData *data = [self parseAttributedContent:content config:config];
    data.imageArray = imageArray;
    data.linkArray = linkArray;
    return data;
}

+ (NSAttributedString *)loadTemplateFile:(NSString *)path
                                  config:(CTFrameParserConfig*)config
                              imageArray:(NSMutableArray *)imageArray
                               linkArray:(NSMutableArray *)linkArray {
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    if (data) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingAllowFragments
                                                           error:nil];
        if ([array isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in array) {
                NSString *type = dict[@"type"];
                if ([type isEqualToString:@"txt"]) {
                    NSAttributedString *as = [self parseAttributedContentFromNSDictionary:dict
                                                                                   config:config];
                    [result appendAttributedString:as];
                } else if ([type isEqualToString:@"img"]) {
                    // 创建 CoreTextImageData
                    CoreTextImageData *imageData = [[CoreTextImageData alloc] init];
                    imageData.name = dict[@"name"];
                    imageData.position = [result length];
                    [imageArray addObject:imageData];
                    // 创建空白占位符，并且设置它的CTRunDelegate信息
                    NSAttributedString *as = [self parseImageDataFromNSDictionary:dict config:config];
                    [result appendAttributedString:as];
                } else if ([type isEqualToString:@"link"]) {
                    NSUInteger startPos = result.length;
                    NSAttributedString *as = [self parseAttributedContentFromNSDictionary:dict
                                                                                   config:config];
                    [result appendAttributedString:as];
                    // 创建 CoreTextLinkData
                    NSUInteger length = result.length - startPos;
                    NSRange linkRange = NSMakeRange(startPos, length);
                    CoreTextLinkData *linkData = [[CoreTextLinkData alloc] init];
                    linkData.title = dict[@"content"];
                    linkData.url = dict[@"url"];
                    linkData.range = linkRange;
                    [linkArray addObject:linkData];
                }
            }
        }
    }
    return result;
}

+ (NSAttributedString *)parseImageDataFromNSDictionary:(NSDictionary *)dict
                                                config:(CTFrameParserConfig*)config {
    CTRunDelegateCallbacks callbacks;
    memset(&callbacks, 0, sizeof(CTRunDelegateCallbacks));
    callbacks.version = kCTRunDelegateVersion1;
    callbacks.getAscent = ascentCallback;
    callbacks.getDescent = descentCallback;
    callbacks.getWidth = widthCallback;
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (__bridge void *)(dict));

    // 使用0xFFFC作为空白的占位符
    unichar objectReplacementChar = 0xFFFC;
    NSString * content = [NSString stringWithCharacters:&objectReplacementChar length:1];
    NSDictionary * attributes = [self attributesWithConfig:config];
    NSMutableAttributedString * space = [[NSMutableAttributedString alloc] initWithString:content
                                                                               attributes:attributes];
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)space, CFRangeMake(0, 1),
                                   kCTRunDelegateAttributeName, delegate);
    CFRelease(delegate);
    return space;
}

+ (NSAttributedString *)parseAttributedContentFromNSDictionary:(NSDictionary *)dict
                                                        config:(CTFrameParserConfig*)config {
    NSMutableDictionary *attributes = [self attributesWithConfig:config];
    // set color
    UIColor *color = [self colorFromTemplate:dict[@"color"]];
    if (color) {
        attributes[(id)kCTForegroundColorAttributeName] = (id)color.CGColor;
    }
    // set font size
    CGFloat fontSize = [dict[@"size"] floatValue];
    if (fontSize > 0) {
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
        attributes[(id)kCTFontAttributeName] = (__bridge id)fontRef;
        CFRelease(fontRef);
    }
    NSString *content = dict[@"content"];
    return [[NSAttributedString alloc] initWithString:content attributes:attributes];
}

+ (NSAttributedString *)parseOnlyContentFromNSDictionary:(NSDictionary *)dict
                                                        config:(CTFrameParserConfig*)config {
    NSMutableDictionary *attributes = [self attributesWithConfig:config];
    // set color
    UIColor *color = [self colorFromTemplate:dict[@"color"]];
    if (config.textColor) {
        color = config.textColor;
    }
    if (color) {
        attributes[(id)kCTForegroundColorAttributeName] = (id)color.CGColor;
    }
    // set font size
    CGFloat fontSize = [dict[@"size"] floatValue];
    if (config.textFont) {
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)config.textFont.fontName, config.fontSize, NULL);
        attributes[(id)kCTFontAttributeName] = (__bridge id)fontRef;
        CFRelease(fontRef);
    } else if (fontSize > 0) {
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
        attributes[(id)kCTFontAttributeName] = (__bridge id)fontRef;
        CFRelease(fontRef);
    }
    NSString *content = dict[@"content"];
    return [[NSAttributedString alloc] initWithString:content attributes:attributes];
}

+ (UIColor *)colorFromTemplate:(NSString *)name {
    if ([name isEqualToString:@"blue"]) {
        return [UIColor blueColor];
    } else if ([name isEqualToString:@"red"]) {
        return [UIColor redColor];
    } else if ([name isEqualToString:@"black"]) {
        return [UIColor blackColor];
    } else if ([name isEqualToString:@"orange"]) {
        return [UIColor orangeColor];
    } else {
        return nil;
    }
}

+ (CoreTextData *)parseContent:(NSString *)content config:(CTFrameParserConfig*)config {
    NSDictionary *attributes = [self attributesWithConfig:config];
    NSAttributedString *contentString = [[NSAttributedString alloc] initWithString:content
                                                                        attributes:attributes];
    return [self parseAttributedContent:contentString config:config];
}

+ (CoreTextData *)parseAttributedContent:(NSAttributedString *)content config:(CTFrameParserConfig*)config {
    // 创建CTFramesetterRef实例
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)content);
    
    // 获得要缓制的区域的高度
    CGSize restrictSize = CGSizeMake(config.width, CGFLOAT_MAX);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0,0), nil, restrictSize, nil);
    CGFloat textHeight = coreTextSize.height;
    
    // 生成CTFrameRef实例
    CTFrameRef frame = [self createFrameWithFramesetter:framesetter config:config height:textHeight];
    
    // 将生成好的CTFrameRef实例和计算好的缓制高度保存到CoreTextData实例中，最后返回CoreTextData实例
    CoreTextData *data = [[CoreTextData alloc] init];
    data.ctFrame = frame;
    data.height = textHeight;
    data.content = content;
    
    // 释放内存
    CFRelease(frame);
    CFRelease(framesetter);
    return data;
}

+ (CTFrameRef)createFrameWithFramesetter:(CTFramesetterRef)framesetter
                                  config:(CTFrameParserConfig *)config
                                  height:(CGFloat)height {
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, config.width, height));
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(path);
    return frame;
}

@end
