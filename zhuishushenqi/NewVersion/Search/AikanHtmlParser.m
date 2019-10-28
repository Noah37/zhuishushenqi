//
//  AikanHtmlParser.m
//  CJDemo
//
//  Created by caonongyun on 2019/10/15.
//  Copyright © 2019 cj. All rights reserved.
//

#import "AikanHtmlParser.h"


@implementation AikanHtmlParser

- (NSString *)stringWithGumboNode:(OCGumboNode *)arg1 withAikanString:(NSString *)arg2 withText:(_Bool)arg3 {
    if (arg2 && arg1) {
        NSArray * regs = [arg2 componentsSeparatedByString:@"@"];
        if (regs.count != 4) {
            return @"";
        }
        NSString * reg1 = [regs objectAtIndex:1];
        if (reg1.length) {
            OCQueryObject * obj = [self elementArrayWithGumboNode:arg1 withRegexString:reg1];
            if (obj.count) {
                NSString * reg2 = [regs objectAtIndex:2];
                NSInteger reg2IntValue = [reg2 integerValue];
                BOOL full;
                OCGumboNode * node;
                if (obj.count > reg2IntValue) {
                    full = YES;
                    node = [obj objectAtIndex:reg2IntValue];
                } else {
                    full = NO;
                }
                if (full) {
                    NSString * reg3 = [regs objectAtIndex:3];
                    if ([reg3 isEqualToString:@"own:"]) {
                        NSArray * text = node.Query(@"");
                        OCGumboNode * node = text.lastObject;
                        return node.text();
                    } else if (reg3.length >= 5) {
                        NSString * sub3 = [reg3 substringToIndex:4];
                        if ([sub3 isEqualToString:@"abs:"]) {
                            NSString * reg3Last = [reg3 substringFromIndex:4];
                            NSString * attr = node.attr(reg3Last);
                            if (attr) {
                                NSString * attrRe = [NSString stringWithFormat:@"%@",attr];
                                if ([attrRe isEqualToString:@"<null>"]) {
                                    return @"";
                                } else {
                                    return attrRe;
                                }
                            } else {
                                return @"";
                            }
                        }
                    } else if (reg3.length > 0) {
                        NSString * sub3 = [reg3 substringToIndex:1];
                        if ([sub3 isEqualToString:@":"]) {
                            NSString * text = node.text();
                            NSString * reg3Last = [reg3 substringFromIndex:1];
                            NSString * matchString = [self getMatchString:text regString:reg3Last];
                            return matchString;
                        } else {
                            NSString * attr = node.attr(sub3);
                            if (attr) {
                                NSString * attrRe = [NSString stringWithFormat:@"%@",attr];
                                if ([attrRe isEqualToString:@"<null>"]) {
                                    return @"";
                                } else {
                                    return attrRe;
                                }
                            } else {
                                return @"";
                            }
                        }
                    }
                    if (arg3) {
                        NSString * text = node.text();
                        if (!text) {
                            return @"";
                        }
                        NSString * attrRe = [NSString stringWithFormat:@"%@",text];
                        if ([attrRe isEqualToString:@"<null>"]) {
                            return @"";
                        } else {
                            return attrRe;
                        }
                    } else {
                        NSString * html = node.html();
                        if (!html) {
                            return @"";
                        }
                        NSString * attrRe = [NSString stringWithFormat:@"%@",html];
                        if ([attrRe isEqualToString:@"<null>"]) {
                            return @"";
                        } else {
                            return attrRe;
                        }
                    }
                }
            }
        } else {
            NSString * reg3 = [regs objectAtIndex:3];
            if ([reg3 isEqualToString:@"own:"]) {
                NSArray * text = arg1.Query(@"");
                OCGumboNode * node = text.lastObject;
                return node.text();
            } else if (reg3.length >= 5) {
                NSString * sub3 = [reg3 substringToIndex:4];
                if ([sub3 isEqualToString:@"abs:"]) {
                    NSString * reg3Last = [reg3 substringFromIndex:4];
                    NSString * attr = arg1.attr(reg3Last);
                    if (attr) {
                        NSString * attrRe = [NSString stringWithFormat:@"%@",attr];
                        if ([attrRe isEqualToString:@"<null>"]) {
                            return @"";
                        } else {
                            return attrRe;
                        }
                    } else {
                        return @"";
                    }
                }
            } else if (reg3.length > 0) {
                NSString * sub3 = [reg3 substringToIndex:1];
                if ([sub3 isEqualToString:@":"]) {
                    NSString * text = arg1.text();
                    NSString * reg3Last = [reg3 substringFromIndex:1];
                    NSString * matchString = [self getMatchString:text regString:reg3Last];
                    return matchString;
                } else {
                    NSString * attr = arg1.attr(sub3);
                    if (attr) {
                        NSString * attrRe = [NSString stringWithFormat:@"%@",attr];
                        if ([attrRe isEqualToString:@"<null>"]) {
                            return @"";
                        } else {
                            return attrRe;
                        }
                    } else {
                        return @"";
                    }
                }
            }
            if (arg3) {
                NSString * text = arg1.text();
                if (!text) {
                    return @"";
                }
                NSString * attrRe = [NSString stringWithFormat:@"%@",text];
                if ([attrRe isEqualToString:@"<null>"]) {
                    return @"";
                } else {
                    return attrRe;
                }
            } else {
                NSString * html = arg1.html();
                if (!html) {
                    return @"";
                }
                NSString * attrRe = [NSString stringWithFormat:@"%@",html];
                if ([attrRe isEqualToString:@"<null>"]) {
                    return @"";
                } else {
                    return attrRe;
                }
            }
        }
    }
    return @"";
}

- (NSString *)getMatchString:(NSString *)arg1 regString:(NSString *)arg2 {
    if (arg1.length) {
        NSMutableString * string = [NSMutableString stringWithCapacity:0];
        NSRegularExpression * reg = [NSRegularExpression regularExpressionWithPattern:arg2 options:(NSRegularExpressionCaseInsensitive) error:nil];
        NSArray <NSTextCheckingResult *>* results = [reg matchesInString:arg1 options:(NSMatchingReportProgress) range:NSMakeRange(0, arg1.length)];
        NSString * range1String;
        if (results.count) {
            for (NSInteger index = 0; index < results.count; index++) {
                NSTextCheckingResult * result =  [results objectAtIndex:index];
                NSRange range = [result range];
                NSString * subString = [arg1 substringWithRange:range];
                [string appendString:subString];
                if ([result numberOfRanges] >= 2) {
                    NSRange range1 = [result rangeAtIndex:1];
                     range1String = [arg1 substringWithRange:range1];
                }
            }
        } else {
            return @"";
        }
        if (results.count) {
            [string appendString:[arg1 substringFromIndex:0]];
        }
        return range1String;
    } else {
        return @"";
    }
    return nil;
}

- (void)parseSearchListWithModel:(AikanParserModel *)arg1 html:(NSString *)arg2 toArray:(NSMutableArray *)arg3 {
    OCGumboDocument * document = [[OCGumboDocument alloc] initWithHTMLString:arg2];
    NSString * booksReg = arg1.books;
    NSArray * elements = [self elementArrayWithGumboNode:document withRegexString:booksReg];
}

- (OCQueryObject *)elementArrayWithGumboNode:(OCGumboNode *)arg1 withRegexString:(NSString *)arg2 {
    NSArray * regs = [arg2 componentsSeparatedByString:@" "];
    OCQueryObject *next;
    if (regs.count > 0) {
        for (NSInteger index = 0; index < regs.count; index++) {
            NSString * reg = regs[index];
            reg = [reg stringByReplacingOccurrencesOfString:@"=" withString:@" "];
            if (index) {
                next = next.find(reg);
            } else {
                next = arg1.Query(reg);
            }
        }
    }
    return next;
}

@end
