//
//  AikanHtmlParser.h
//  CJDemo
//
//  Created by yung on 2019/10/15.
//  Copyright © 2019 cj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AikanParserModel.h"
#import "OCGumbo.h"
#import "OCGumbo+Query.h"

NS_ASSUME_NONNULL_BEGIN

@interface AikanHtmlParser : NSObject

- (void)parseSearchListWithModel:(AikanParserModel *)arg1 html:(NSString *)arg2 toArray:(NSMutableArray *)arg3;

- (OCQueryObject *)elementArrayWithGumboNode:(OCGumboNode *)arg1 withRegexString:(NSString *)arg2;

- (NSString *)stringWithGumboNode:(id)arg1 withAikanString:(id)arg2 withText:(_Bool)arg3;

- (id)getMatchString:(id)arg1 regString:(id)arg2;

@end

NS_ASSUME_NONNULL_END
