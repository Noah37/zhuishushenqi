//
//	XMCategoryHumanRecommend.h
//
//	Create by 王瑞 on 7/9/2015
//	Copyright © 2015. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface XMCategoryHumanRecommend : NSObject

@property (nonatomic, strong) NSString * categoryName;
@property (nonatomic, strong) NSString * coverUrlLarge;
@property (nonatomic, strong) NSString * coverUrlMiddle;
@property (nonatomic, strong) NSString * coverUrlSmall;
@property (nonatomic, strong) NSString * humanRecommendCategoryName;
@property (nonatomic, assign) NSInteger categoryId;
@property (nonatomic, strong) NSString * kind;
@property (nonatomic, assign) NSInteger orderNum;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end