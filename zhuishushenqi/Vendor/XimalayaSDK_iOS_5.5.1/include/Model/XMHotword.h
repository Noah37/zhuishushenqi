//
//	XMHotword.h
//
//	Create by 王瑞 on 25/8/2015
//	Copyright © 2015. All rights reserved.
//

//	 

#import <UIKit/UIKit.h>

@interface XMHotword : NSObject

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger degree;
@property (nonatomic, strong) NSString * searchWord;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end