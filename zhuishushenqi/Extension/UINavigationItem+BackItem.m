//
//  UINavigationItem+BackItem.m
//  zhuishushenqi
//
//  Created by Nory Chao on 16/10/4.
//  Copyright © 2016年 QS. All rights reserved.
//

#import "UINavigationItem+BackItem.h"
#import <objc/runtime.h>

@implementation UINavigationItem (BackItem)


+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originalMethodImp = class_getInstanceMethod(self, @selector(backBarButtonItem));
        Method destMethodImp = class_getInstanceMethod(self, @selector(myCustomBackButton));
        method_exchangeImplementations(originalMethodImp, destMethodImp);
    });
}

static char kCustomBackButtonKey;

-(UIBarButtonItem *)myCustomBackButton{
    UIBarButtonItem *item = [self myCustomBackButton];
    if (item) {
        return item;
    }
    item = objc_getAssociatedObject(self, &kCustomBackButtonKey);
    if (!item) {
        item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:NULL];
        objc_setAssociatedObject(self, &kCustomBackButtonKey, item, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return item;
}


@end
