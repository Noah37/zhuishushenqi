//
//  ZSAddSourceTextField.m
//  zhuishushenqi
//
//  Created by daye on 2020/12/25.
//  Copyright © 2020 QS. All rights reserved.
//

#import "ZSAddSourceTextField.h"

@implementation ZSAddSourceTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)removeFromSuperview {
    [self resignFirstResponder];
    NSLog(@"------- %s retainCount:%zd",__func__,CFGetRetainCount((__bridge CFTypeRef)(self)));
      
    if (self) {
        CFRelease((__bridge CFTypeRef)(self));
    }
}

@end
