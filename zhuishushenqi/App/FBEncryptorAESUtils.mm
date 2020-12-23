//
//  FBEncryptorAESUtils.m
//  zhuishushenqi
//
//  Created by yung on 2018/11/9.
//  Copyright © 2018年 QS. All rights reserved.
//

#import "FBEncryptorAESUtils.h"
#import "FBEncryptorAES.h"

       
@implementation FBEncryptorAESUtils

+ (NSString *)getDecryptedStrWithKey:(NSString *)key cipherText:(NSString *)cipherText {
    NSData *v9 = [[NSData alloc] initWithBase64EncodedString:key options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
    NSData *v11 = [[NSData alloc] initWithBase64EncodedString:cipherText options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
    if (v11.length > 16) {
        NSData *v12 = [v11 subdataWithRange:NSMakeRange(0, 16)];
        NSInteger v14 = v11.length;
        NSData *v15 = [v11 subdataWithRange:NSMakeRange(16, v14 - 16)];
        NSData *resultData = [FBEncryptorAES decryptData:v15 key:v9 iv:v12];
        NSString *resultText = [[NSString alloc] initWithData:resultData encoding:(NSUTF8StringEncoding)];
        return resultText;
    }
    return @"";
}

@end
