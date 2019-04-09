//
//	XMAnnouncerCategory.h
//
//	Create by 瑞 王 on 18/12/2015
//	Copyright © 2015. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

/**
 *  主播分类
 */
@interface XMAnnouncerCategory : NSObject

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString * kind;
@property (nonatomic, assign) NSInteger orderNum;
@property (nonatomic, strong) NSString * vcategoryName;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end