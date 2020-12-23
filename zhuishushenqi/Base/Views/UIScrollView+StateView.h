//
//  UIScrollView+StateView.h
//  zhuishushenqi
//
//  Created by yung on 2017/8/23.
//  Copyright © 2017年 QS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ZSTableViewStatusInitial,
    ZSTableViewStatusNoData,
    ZSTableViewStatusLoading,
    ZSTableViewStatusFailure,
} ZSTableViewStatus;

typedef void(^QSErrorHandler)();

@class QSErrorPageView,QSLoadingPageView;
@interface UIScrollView (StateView)

@property (nonatomic, copy)QSErrorHandler reloadAction;
@property (nonatomic, strong)QSErrorPageView *errorPageView;
@property (nonatomic, strong)QSLoadingPageView *loadingPageView;
- (void)showErrorPage;
- (void)showLoadingPage;
@end

@interface QSErrorPageView : UIView
@property (nonatomic,copy)QSErrorHandler didClickReloadBlock;
@end

@interface QSLoadingPageView : UIView

- (void)startAnimate;
- (void)stopAnimate;

@end

@interface UITableView (StateView)

@property (nonatomic, assign, getter=isAutoControlErrorView) BOOL autoControlErrorView;

@property (nonatomic, assign) ZSTableViewStatus status;

@end
