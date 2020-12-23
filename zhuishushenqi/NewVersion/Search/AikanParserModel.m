//
//  AikanParserModel.m
//  ZSSouShu
//
//  Created by yung on 2019/10/8.
//  Copyright © 2019 CJ. All rights reserved.
//

#import "AikanParserModel.h"

@implementation AikanParserModel

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.errDate = [coder decodeObjectForKey:@"errDate"];
        self.books = [coder decodeObjectForKey:@"books"];
        self.searchUrl = [coder decodeObjectForKey:@"searchUrl"];
        self.name = [coder decodeObjectForKey:@"name"];
        self.type = [coder decodeIntegerForKey:@"type"];
        self.enabled = [coder decodeBoolForKey:@"enabled"];
        self.checked = [coder decodeBoolForKey:@"checked"];
        self.searchEncoding = [coder decodeObjectForKey:@"searchEncoding"];
        self.host = [coder decodeObjectForKey:@"host"];
        self.contentReplace = [coder decodeObjectForKey:@"contentReplace"];
        self.contentRemove = [coder decodeObjectForKey:@"contentRemove"];
        self.content = [coder decodeObjectForKey:@"content"];
        self.chaptersReverse = [coder decodeBoolForKey:@"chaptersReverse"];
        self.chapterUrl = [coder decodeObjectForKey:@"chapterUrl"];
        self.chapterName = [coder decodeObjectForKey:@"chapterName"];
        self.chapters = [coder decodeObjectForKey:@"chapters"];
        self.detailBookIcon = [coder decodeObjectForKey:@"detailBookIcon"];
        self.detailBookDesc = [coder decodeObjectForKey:@"detailBookDesc"];
        self.detailChaptersUrl = [coder decodeObjectForKey:@"detailChaptersUrl"];
        self.bookLastChapterName = [coder decodeObjectForKey:@"bookLastChapterName"];
        self.bookUpdateTime = [coder decodeObjectForKey:@"bookUpdateTime"];
        self.bookUrl = [coder decodeObjectForKey:@"bookUrl"];
        self.bookIcon = [coder decodeObjectForKey:@"bookIcon"];
        self.bookDesc = [coder decodeObjectForKey:@"bookDesc"];
        self.bookCategory = [coder decodeObjectForKey:@"bookCategory"];
        self.bookAuthor = [coder decodeObjectForKey:@"bookAuthor"];
        self.bookName = [coder decodeObjectForKey:@"bookName"];

    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.books forKey:@"books"];
    [coder encodeObject:self.errDate forKey:@"errDate"];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeInteger:self.type forKey:@"type"];
    [coder encodeBool:self.enabled forKey:@"enabled"];
    [coder encodeBool:self.checked forKey:@"checked"];
    [coder encodeObject:self.searchUrl forKey:@"searchUrl"];
    [coder encodeObject:self.searchEncoding forKey:@"searchEncoding"];
    [coder encodeObject:self.host forKey:@"host"];
    [coder encodeObject:self.contentReplace forKey:@"contentReplace"];
    [coder encodeObject:self.contentRemove forKey:@"contentRemove"];
    [coder encodeObject:self.content forKey:@"content"];
    [coder encodeBool:self.chaptersReverse forKey:@"chaptersReverse"];
    [coder encodeObject:self.chapterUrl forKey:@"chapterUrl"];
    [coder encodeObject:self.chapterName forKey:@"chapterName"];
    [coder encodeObject:self.chapters forKey:@"chapters"];
    [coder encodeObject:self.detailBookIcon forKey:@"detailBookIcon"];
    [coder encodeObject:self.detailBookDesc forKey:@"detailBookDesc"];
    [coder encodeObject:self.detailChaptersUrl forKey:@"detailChaptersUrl"];
    [coder encodeObject:self.bookLastChapterName forKey:@"bookLastChapterName"];
    [coder encodeObject:self.bookUpdateTime forKey:@"bookUpdateTime"];
    [coder encodeObject:self.bookUrl forKey:@"bookUrl"];
    [coder encodeObject:self.bookIcon forKey:@"bookIcon"];
    [coder encodeObject:self.bookDesc forKey:@"bookDesc"];
    [coder encodeObject:self.bookCategory forKey:@"bookCategory"];
    [coder encodeObject:self.bookAuthor forKey:@"bookAuthor"];
    [coder encodeObject:self.bookName forKey:@"bookName"];

}

- (id)copyWithZone:(NSZone *)zone {
    AikanParserModel * model = [[AikanParserModel alloc] init];
    model.books = self.books;
    model.errDate = self.errDate;
    model.name = self.name;
    model.type = self.type;
    model.enabled = self.enabled;
    model.checked = self.checked;
    model.searchUrl = self.searchUrl;
    model.searchEncoding = self.searchEncoding;
    model.host = self.host;
    model.contentReplace = self.contentReplace;
    model.contentRemove = self.contentRemove;
    model.content = self.content;
    model.chaptersReverse = self.chaptersReverse;
    model.chapterUrl = self.chapterUrl;
    model.chapterName = self.chapterName;
    model.chapters = self.chapters;
    model.detailBookIcon = self.detailBookIcon;
    model.detailChaptersUrl = self.detailChaptersUrl;
    model.bookLastChapterName = self.bookLastChapterName;
    model.bookUpdateTime = self.bookUpdateTime;
    model.bookUrl = self.bookUrl;
    model.bookIcon = self.bookIcon;
    model.bookDesc = self.bookDesc;
    model.bookCategory = self.bookCategory;
    model.bookAuthor = self.bookAuthor;
    model.bookName = self.bookName;
    return model;
}

@end
