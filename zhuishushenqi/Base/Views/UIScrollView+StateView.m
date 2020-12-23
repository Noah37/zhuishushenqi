//
//  UIScrollView+StateView.m
//  zhuishushenqi
//
//  Created by yung on 2017/8/23.
//  Copyright © 2017年 QS. All rights reserved.
//

#import "UIScrollView+StateView.h"
#import <objc/runtime.h>
#import "zhuishushenqi-Swift.h"

void qs_swizzle(Class cls,SEL old,SEL new){
    Method oldMethod = class_getInstanceMethod(cls, old);
    Method newMethod = class_getInstanceMethod(cls, new);
    if (class_addMethod(cls, old, class_getMethodImplementation(cls, new), method_getTypeEncoding(newMethod))) {
        class_replaceMethod(cls, new, class_getMethodImplementation(cls, old), method_getTypeEncoding(oldMethod));
    }else
        method_exchangeImplementations(oldMethod, newMethod);
}

@implementation UITableView (StateView)

- (void)setAutoControlErrorView:(BOOL)autoControlErrorView {
    objc_setAssociatedObject(self, @selector(isAutoControlErrorView), @(autoControlErrorView), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isAutoControlErrorView {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setStatus:(ZSTableViewStatus)status {
    objc_setAssociatedObject(self, @selector(status), @(status), OBJC_ASSOCIATION_ASSIGN);
}

- (ZSTableViewStatus)status {
    ZSTableViewStatus ss = [objc_getAssociatedObject(self, _cmd) integerValue];
    return ss;
}

- (void)setReloadAction:(QSErrorHandler)reloadAction{
    objc_setAssociatedObject(self, @selector(reloadAction), reloadAction, OBJC_ASSOCIATION_COPY);
}
- (QSErrorHandler)reloadAction{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setErrorPageView:(QSErrorPageView *)errorPageView{
    [self willChangeValueForKey:NSStringFromSelector(@selector(errorPageView))];
    objc_setAssociatedObject(self, @selector(errorPageView), errorPageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:NSStringFromSelector(@selector(errorPageView))];

}

- (QSErrorPageView *)errorPageView{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setLoadingPageView:(QSLoadingPageView *)loadingPageView{
    [self willChangeValueForKey:NSStringFromSelector(@selector(loadingPageView))];
    objc_setAssociatedObject(self, @selector(loadingPageView), loadingPageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:NSStringFromSelector(@selector(loadingPageView))];
    
}

- (QSLoadingPageView *)loadingPageView{
    return objc_getAssociatedObject(self, _cmd);
}

+ (void)load{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        Class cls  = [self class];
        if ([self instancesRespondToSelector:@selector(reloadData)]) {
            qs_swizzle(cls, @selector(reloadData), @selector(qs_reloadData));
        }
    });
}

- (BOOL)hasRowToDisplay{
    NSInteger totalRows = 0;
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self;
        NSInteger numOfSections = [tableView numberOfSections];
        for (NSInteger section = 0; section < numOfSections; section++) {
            NSInteger numOfRows = [tableView numberOfRowsInSection:section];
            totalRows += numOfRows;
        }
    }
    return (totalRows != 0);
}

- (void)showLoadingPage{
    if (!self.loadingPageView) {
        QSLoadingPageView *loadingPage = [[QSLoadingPageView alloc] initWithFrame:self.bounds];
        self.loadingPageView = loadingPage;
    }
    self.status = ZSTableViewStatusLoading;
    self.loadingPageView.hidden = NO;
    self.loadingPageView.maskView.hidden = YES;
    if (self.subviews.count > 0) {
        [self insertSubview:self.loadingPageView atIndex:0];
    }else{
        [self addSubview:self.loadingPageView];
    }
}

- (void)showErrorPage{
    if (self.loadingPageView) {
        self.loadingPageView.hidden = YES;
        self.loadingPageView.maskView.hidden = NO;
    }
    if (!self.errorPageView) {
        QSErrorPageView *errorPage = [[QSErrorPageView alloc] initWithFrame:self.bounds];
        if (self.reloadAction) {
            errorPage.didClickReloadBlock = self.reloadAction;
        }
        self.errorPageView = errorPage;
    }
    // 初始状态不显示错误页面
    if (self.status == ZSTableViewStatusInitial) {
        return;
    }
    self.status = ZSTableViewStatusFailure;
    self.errorPageView.hidden = YES;
    if (self.subviews.count > 0) {
        [self insertSubview:self.errorPageView atIndex:0];
    }else{
        [self addSubview:self.errorPageView];
    }
    if (![self hasRowToDisplay]) {
        self.errorPageView.hidden = NO;
    }
}

- (void)hideErrorPage{
    self.errorPageView.hidden = YES;
    self.errorPageView.maskView.hidden = NO;
}

- (void)qs_reloadData{
    [self qs_reloadData];
    if (self.isAutoControlErrorView) {
        [self showErrorPage];
    }
}

@end

@interface QSErrorPageView ()

@property (nonatomic, weak)UIView *maskView;
@property (nonatomic, weak)UIImageView *errorImageView;
@property (nonatomic, weak)UILabel *errorTipLabel;
@property (nonatomic, weak)UIButton *reloadButton;

@end

@implementation QSErrorPageView

- (instancetype)init
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self  = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    
    UIImageView* errorImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_tip_fail"]];
    errorImageView.frame = CGRectMake(0, 0, 120, 140);
    errorImageView.center = CGPointMake(self.center.x, self.center.y - 70);
    _errorImageView = errorImageView;
    [self addSubview:_errorImageView];
    
    UILabel* errorTipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 50)];
    errorTipLabel.center = CGPointMake(self.center.x, self.center.y + 20);
    errorTipLabel.numberOfLines = 1;
    errorTipLabel.font = [UIFont systemFontOfSize:15];
    errorTipLabel.textAlignment = NSTextAlignmentCenter;
    errorTipLabel.textColor = [UIColor grayColor];
    errorTipLabel.text = @"很抱歉,网络似乎出了点状况...";
    _errorTipLabel = errorTipLabel;
    [self addSubview:_errorTipLabel];
    
    UIButton* reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    reloadButton.frame = CGRectMake(0, 0, 120, 40);
    reloadButton.center = CGPointMake(self.center.x, self.center.y + 90);
    reloadButton.layer.masksToBounds = YES;
    reloadButton.layer.cornerRadius = 15;
    reloadButton.layer.borderColor = [UIColor grayColor].CGColor;
    reloadButton.layer.borderWidth = 1.0f;
    [reloadButton setBackgroundImage:[self createImageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [reloadButton setBackgroundImage:[self createImageWithColor:[[UIColor grayColor] colorWithAlphaComponent:0.3]] forState:UIControlStateHighlighted];
    [reloadButton setTitle:@"重新加载" forState:UIControlStateNormal];
    [reloadButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [reloadButton addTarget:self action:@selector(_clickReloadButton:) forControlEvents:UIControlEventTouchUpInside];
    _reloadButton = reloadButton;
    [self addSubview:_reloadButton];
    
    UIView *maskView = [[UIView alloc] initWithFrame:self.bounds];
    if ([self.backgroundColor isEqual:UIColor.clearColor]) {
        maskView.backgroundColor = [UIColor whiteColor];;
    } else {
        maskView.backgroundColor = self.backgroundColor;
    }
    _maskView = maskView;
    [self addSubview:_maskView];
    
}

- (void)_clickReloadButton:(UIButton *)sender{
    if (_didClickReloadBlock) {
        _didClickReloadBlock();
    }
}

- (UIImage*)createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0,0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end

@interface QSLoadingPageView()

@property (nonatomic, weak)UIView *maskView;
@property (nonatomic, weak)UIActivityIndicatorView *activityIndicatorView;

@end

@implementation QSLoadingPageView

- (instancetype)init
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setupSubviews{
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicatorView.center = self.center;
    _activityIndicatorView = activityIndicatorView;
    [self addSubview:_activityIndicatorView];
    
    UILabel* errorTipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 50)];
    errorTipLabel.center = CGPointMake(self.center.x, self.center.y + 30);
    errorTipLabel.numberOfLines = 1;
    errorTipLabel.font = [UIFont systemFontOfSize:15];
    errorTipLabel.textAlignment = NSTextAlignmentCenter;
    errorTipLabel.textColor = [UIColor grayColor];
    errorTipLabel.text = @"正在加载...";
    [self addSubview:errorTipLabel];
    
    UIView *maskView = [[UIView alloc] initWithFrame:self.bounds];
    if ([self.backgroundColor isEqual:UIColor.clearColor]) {
        maskView.backgroundColor = [UIColor whiteColor];;
    } else {
        maskView.backgroundColor = self.backgroundColor;
    }
    _maskView = maskView;
    [self addSubview:_maskView];
}

- (void)startAnimate{
    [_activityIndicatorView startAnimating];
}

- (void)stopAnimate{
    [_activityIndicatorView stopAnimating];
}

@end
