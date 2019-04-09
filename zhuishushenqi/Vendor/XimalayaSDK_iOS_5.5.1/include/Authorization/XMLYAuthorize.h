//
//  XMLYAuthorize.h
//  AuthorizeDemo
//
//  Created by jude on 16/10/18.
//  Copyright © 2016年 ximalaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMSingleTone.h"

//响应消息
typedef NS_ENUM(NSInteger, XmlyResponseType) {
    AuthorizeSuccess = 0,       //授权成功
    RefreshTokenSuccess,        //刷新accesstoken成功
    RequestQRCodeSuccess,       // 请求二维码信息成功
    QRCodeLoginSuccess,         // 二维码登录成功
    
    ErrorAuthorizeFail,         //授权失败
    ErrorRefreshTokenFail,      //刷新accesstoken失败
    ErrorQRCodeLoginFail,       // 二维码登录失败
    ErrorRequestQRCodeFail      // 请求二维码信息失败
};

typedef enum {
    kQRCodeSizeMiddle = 0, //!< M表示238*238，默认为M
    kQRCodeSizeSmall,      //!< S表示180*180
    kQRCodeSizeLarge,      //!< L表示418*418
} QRCodeSize;

//授权回调返回数据
@interface XMLYAuthorizeModel : NSObject

//授权后的access_token
@property (nonatomic, strong) NSString          *access_token;

//用来刷新access_token
@property (nonatomic, strong) NSString          *refresh_token;

//access_token的生命周期，单位是秒数
@property (nonatomic, assign) NSTimeInterval    expires_in;

//喜马拉雅用户id
@property (nonatomic, assign) long              uid;

//授权范围
@property (nonatomic, strong) NSString          *scope;

//设备号
@property (nonatomic, strong) NSString          *device_id;

@end

//授权回调代理
@protocol XMLYAuthorizeDelegate <NSObject>

/*
 *  成功回调
 *
 *  @param responseType       响应消息类型
 *  @param authorizeModel     响应数据
 */
- (void)onAuthorizeSuccess:(XmlyResponseType)responseType responseData:(XMLYAuthorizeModel *)authorizeModel;

/*
 *  失败回调
 *
 *  @param errorType       失败消息类型
 *  @param info            错误描述
 */
- (void)onAuthorizeFail:(XmlyResponseType)errorType errorInfo:(NSDictionary*)info;

/*
 *  请求生成二维码成功回调
 *
 *  @param responseType       响应消息类型
 *  @param authorizeModel     响应数据，为二进制流图片数据
 */

- (void)onRequestQRCodeSuccess:(XmlyResponseType)responseType responseData:(NSData *)imageData;

/*
 *  请求生成二维码失败回调
 *
 *  @param errorType       失败消息类型
 *  @param info            错误描述
 */
- (void)onRequestQRCodeFail:(XmlyResponseType)errorType errorInfo:(NSDictionary*)info;



@end


@interface XMLYAuthorize : NSObject

@property (nonatomic,assign) BOOL usingSynRequest; //!< 使用同步的方式进行请求 send request synchronously，目前仅对refreshToken和requestExchangeTokenWithThirdUid两个方法有效

@property (nonatomic, weak) id<XMLYAuthorizeDelegate> callbackMetheds; //!< 代理，一般不建议直接设置该属性，如果设置则要确保其代理一直存在否则将收不到授权相关的一些回调

/*
 *  SDK单例对象
 */
+ (XMLYAuthorize *)shareInstance;

/*
 *  初始化
 *
 *  @param appKey           分配的appkey
 *  @param appSecret        分配的appsecret
 *  @param appRedirectUri   应用定义的回调地址
 *  @param appPackageId     应用定义的包名
 *  @param appName          应用名字
 *  @param delegate         回调
 */
- (void)initWithAppkey:(NSString *)appKey
             appSecret:(NSString *)appSecret
        appRedirectUri:(NSString *)appRedirectUri
          appPackageId:(NSString *)appPackageId
               appName:(NSString *)appName
              delegate:(id<XMLYAuthorizeDelegate>)delegate;

/*
 *  授权接口
 *  @param isOpen     是否跳转喜马拉雅
 */
- (void)authorize:(BOOL)isOpen;

/*
 *  刷新授权信息接口
 */
- (void)refreshToken;

/*
 *  注册并授权接口
 *  @param isOpen     是否跳转喜马拉雅
 */
- (void)registerAndAuthorize:(BOOL)isOpen;

/*
 *  url跳转
 *
 *  @param url       跳转的url
 */
- (void)handleURL:(NSURL *)url;


/*
 *  获取AuthorizeModel
 */
- (XMLYAuthorizeModel *)loadAuthorizeModel;

- (void)saveAuthorizeModel:(XMLYAuthorizeModel *)model;

- (BOOL)isLoggedIn;

- (long)currentUid;


/*
 *  第三方使用third_uid和third_token换取授权后的access_token
 */
- (void)requestExchangeTokenWithThirdUid:(NSString *)tUid thirdToken:(NSString *)tToken;

/*
 *  设置state参数(optional/非必需)。state表示客户端的当前状态，可以指定任意值，认证服务器会原封不动地返回这个值。开发者可以用这个参数验证请求有效性，也可以记录用户请求授权页前的位置。这个参数可用于防止跨站请求伪造（CSRF）攻击
 */
- (void)settingAuthorizeState:(NSString *)state;


/**
 * 请求服务器生成并返回二维码信息用于喜马拉雅APP扫描验证登录
 * @param qrCodeSize    用于选择返回二维码的size大小
 */
-(void)requestGernerateQRCodeForLoginWithSize:(QRCodeSize)qrCodeSize;

/**
 * 查询登录状态及授权信息接口
 * 1. 登录成功，进入AuthorizeSuccess回调
 * 2. 若失败，则进入AuthorizeFail回调
 * - 若用户未登录，则继续轮询本接口查询用户登录状态，建议控制在2-3秒轮询一次
 * - 二维码图片过期，则需要重新调用接口获取新的有效二维码图片
 */
-(void)checkQRCodeLoginStatus;


@end
