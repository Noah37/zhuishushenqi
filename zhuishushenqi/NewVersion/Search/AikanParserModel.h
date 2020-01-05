//
//  AikanParserModel.h
//  ZSSouShu
//
//  Created by caonongyun on 2019/10/8.
//  Copyright © 2019 CJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AikanParserModel : NSObject<NSCoding, NSCopying>

@property(retain, nonatomic) NSDate *errDate; // @synthesize errDate=_errDate;
@property(copy, nonatomic) NSString *searchUrl; // @synthesize searchUrl=_searchUrl;
@property(copy, nonatomic) NSString *name; // @synthesize name=_name;
@property(nonatomic) unsigned long long type; // @synthesize type=_type;
@property(nonatomic) _Bool enabled; // @synthesize enabled=_enabled;
@property(nonatomic) _Bool checked; // @synthesize checked=_checked;
@property(copy, nonatomic) NSString *searchEncoding; // @synthesize searchEncoding=_searchEncoding;
@property(copy, nonatomic) NSString *host; // @synthesize host=_host;
@property(copy, nonatomic) NSString *contentReplace; // @synthesize contentReplace=_contentReplace;
@property(copy, nonatomic) NSString *contentRemove; // @synthesize contentRemove=_contentRemove;
@property(copy, nonatomic) NSString *content; // @synthesize content=_content;
@property(nonatomic) _Bool chaptersReverse; // @synthesize chaptersReverse=_chaptersReverse;
@property(copy, nonatomic) NSString *chapterUrl; // @synthesize chapterUrl=_chapterUrl;
@property(copy, nonatomic) NSString *chapterName; // @synthesize chapterName=_chapterName;
@property(copy, nonatomic) NSString *chapters; // @synthesize chapters=_chapters;
@property(copy, nonatomic) NSArray *chaptersModel; // @synthesize chapters=_chapters;
@property(copy, nonatomic) NSString *detailBookIcon; // @synthesize detailBookIcon=_detailBookIcon;
@property(copy, nonatomic) NSString *detailChaptersUrl; // @synthesize detailChaptersUrl=_detailChaptersUrl;
@property(copy, nonatomic) NSString *detailBookDesc; // @synthesize bookDesc=_bookDesc;
@property(copy, nonatomic) NSString *bookLastChapterName; // @synthesize bookLastChapterName=_bookLastChapterName;
@property(copy, nonatomic) NSString *bookUpdateTime; // @synthesize bookUpdateTime=_bookUpdateTime;
@property(copy, nonatomic) NSString *bookUrl; // @synthesize bookUrl=_bookUrl;
@property(copy, nonatomic) NSString *bookIcon; // @synthesize bookIcon=_bookIcon;
@property(copy, nonatomic) NSString *bookDesc; // @synthesize bookDesc=_bookDesc;
@property(copy, nonatomic) NSString *bookCategory; // @synthesize bookCategory=_bookCategory;
@property(copy, nonatomic) NSString *bookAuthor; // @synthesize bookAuthor=_bookAuthor;
@property(copy, nonatomic) NSString *bookName; // @synthesize bookName=_bookName;
@property(copy, nonatomic) NSString *books; // @synthesize books=_books;

@end

NS_ASSUME_NONNULL_END
