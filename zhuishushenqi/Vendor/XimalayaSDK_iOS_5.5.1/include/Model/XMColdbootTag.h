//
//	XMColdbootTag.h
//
//	Create by 瑞 王 on 8/12/2015
//	Copyright © 2015. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface XMColdbootTag : NSObject

@property (nonatomic, strong) NSString * coldbootGenre;
@property (nonatomic, strong) NSString * coldbootSubGenre;
@property (nonatomic, strong) NSArray * coldbootTags;
@property (nonatomic, strong) NSString * kind;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end