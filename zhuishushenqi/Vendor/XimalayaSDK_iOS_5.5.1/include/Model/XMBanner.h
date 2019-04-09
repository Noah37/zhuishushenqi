//
//	XMBanner.h
//
//	Create by 王瑞 on 2/9/2015
//	Copyright © 2015. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface XMBanner : NSObject

@property (nonatomic, assign) NSInteger bannerContentType;
@property (nonatomic, strong) NSString * bannerRedirectUrl;
@property (nonatomic, strong) NSString * bannerShortTitle;
@property (nonatomic, strong) NSString * bannerTitle;
@property (nonatomic, strong) NSString * bannerUrl;
@property (nonatomic, assign) BOOL canShare;
@property (nonatomic, assign) NSInteger bannerId;
@property (nonatomic, assign) BOOL isExternalUrl;
@property (nonatomic, strong) NSString * kind;
@property (nonatomic, assign) NSInteger bannerUid;
@property (nonatomic, assign) NSInteger trackId;
@property (nonatomic, assign) NSInteger columnId;
@property (nonatomic, strong) NSString *columnContentType;
@property (nonatomic, assign) NSInteger albumId;
@property (nonatomic, strong) NSString *thirdPartyUrl;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end