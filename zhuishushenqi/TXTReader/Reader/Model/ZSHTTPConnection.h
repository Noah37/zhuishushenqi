//
//  ZSHTTPConnection.h
//  zhuishushenqi
//
//  Created by yung on 2018/7/30.
//  Copyright © 2018年 QS. All rights reserved.
//

#import "HTTPConnection.h"

@class MultipartFormDataParser;


@interface ZSHTTPConnection : HTTPConnection{
    MultipartFormDataParser *parser;
    NSFileHandle *storeFile;
    NSMutableArray *uploadedFiles;
    
}

@end

FOUNDATION_EXTERN NSString *const ZSHTTPConnectionUploadFileFinished;
