//
//  XMErrorModel.h
//  XMOpenPlatform
//
//  Created by chesterchen on 08/05/2017.
//
//

#import <Foundation/Foundation.h>

@interface XMErrorModel : NSObject

/** 错误编号 */
@property (nonatomic, assign) NSInteger error_no;
/** 错误代码 */
@property (nonatomic, strong) NSString *error_code;
/** 错误信息描述 */
@property (nonatomic, strong) NSString *error_desc;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

+ (instancetype)errorWithDic:(NSDictionary *)dictionary;

@end
