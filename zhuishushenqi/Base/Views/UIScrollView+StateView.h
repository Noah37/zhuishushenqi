//
//  UIScrollView+StateView.h
//  zhuishushenqi
//
//  Created by caonongyun on 2017/8/23.
//  Copyright © 2017年 QS. All rights reserved.
//

#import <UIKit/UIKit.h>

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
