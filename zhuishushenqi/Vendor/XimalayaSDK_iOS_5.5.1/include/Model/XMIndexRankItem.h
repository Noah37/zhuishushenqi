//
//	XMIndexRankItem.h
//
//	Create by 王瑞 on 25/8/2015
//	Copyright © 2015. All rights reserved.
//

//	 

#import <UIKit/UIKit.h>

@interface XMIndexRankItem : NSObject

@property (nonatomic, strong) NSString * contentType;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString * title;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end