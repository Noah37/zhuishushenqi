//
//  CTDisplayView.m
//  CoreTextDemo
//
//  Created by caonongyun on 2017/7/25.
//  Copyright © 2017年 QS. All rights reserved.
//

#import "CTDisplayView.h"
#import <CoreText/CoreText.h>
#import "CoreTextImageData.h"
#import "CoreTextLinkData.h"
#import "CoreTextUtils.h"

@interface CTDisplayView ()<UIGestureRecognizerDelegate>

@end

@implementation CTDisplayView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupEvents];
    }
    return self;
}

- (void)setupEvents {
    UIGestureRecognizer * tapRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(userTapGestureDetected:)];
    tapRecognizer.delegate = self;
    [self addGestureRecognizer:tapRecognizer];
    self.userInteractionEnabled = YES;
}

- (void)userTapGestureDetected:(UITapGestureRecognizer *)recognizer{
    CGPoint point = [recognizer locationInView:self];
    for (CoreTextImageData * imageData in self.data.imageArray) {
        // 翻转坐标系，因为 imageData 中的坐标是 CoreText 的坐标系
        CGRect imageRect = imageData.imagePosition;
        CGPoint imagePosition = imageRect.origin;
        imagePosition.y = self.bounds.size.height - imageRect.origin.y
        - imageRect.size.height;
        CGRect rect = CGRectMake(imagePosition.x, imagePosition.y, imageRect.size.width, imageRect.size.height);
        // 检测点击位置 Point 是否在 rect 之内
        if (CGRectContainsPoint(rect, point)) {
            // 在这里处理点击后的逻辑
            
            
            NSLog(@"bingo");
            break;
        }
    }
    CoreTextLinkData *linkData = [CoreTextUtils touchLinkInView:self atPoint:point data:self.data];
    if (linkData) {
        NSLog(@"hint link!");
        return;
    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
//    NSLog(@"familyNames:%@",UIFont.familyNames); 
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    if (self.data) {
        //
        CGContextTranslateCTM(context, 0, self.data.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        CTFrameDraw(self.data.ctFrame, context);
    }
    
    for (CoreTextImageData * imageData in self.data.imageArray) {
        UIImage *image = [UIImage imageNamed:imageData.name];
        if (image) {
            CGContextDrawImage(context, imageData.imagePosition, image.CGImage);
        }
    }
    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    // 平移
//    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
//    CGContextTranslateCTM(context, 0, self.bounds.size.height);
//    
//    //翻转，对于底层的绘制引擎来说，屏幕的左下角是（0, 0）坐标。而对于上层的 UIKit 来说，左上角是 (0, 0) 坐标。所以我们为了之后的坐标系描述按 UIKit 来做，所以先在这里做一个坐标系的上下翻转操作。翻转之后，底层和上层的 (0, 0) 坐标就是重合的了。
//    CGContextScaleCTM(context, 1.0, -1);
//    
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathAddRect(path, NULL, self.bounds);
//    
//    NSAttributedString *attri = [[NSAttributedString alloc] initWithString:@"Hello,world!"
//                        " 创建绘制的区域，CoreText 本身支持各种文字排版的区域，"
//                        " 我们这里简单地将 UIView 的整个界面作为排版的区域。"
//                        " 为了加深理解，建议读者将该步骤的代码替换成如下代码，"
//                        " 测试设置不同的绘制区域带来的界面变化。"];
//    
//    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attri);
//    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attri.length), path, NULL);
//    CTFrameDraw(frame, context);
//    
//    CFRelease(frame);
//    CFRelease(path);
//    CFRelease(framesetter);
}

@end
