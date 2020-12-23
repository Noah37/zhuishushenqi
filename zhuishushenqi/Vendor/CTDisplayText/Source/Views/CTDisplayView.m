//
//  CTDisplayView.m
//  CoreTextDemo
//
//  Created by yung on 2017/7/25.
//  Copyright (c) 2017年 yung. All rights reserved.
//

#import "CTDisplayView.h"
#import "CoreTextUtils.h"
#import "MagnifiterView.h"
#import "UIView+frameAdjust.h"

NSString *const CTDisplayViewImagePressed = @"CTDisplayViewImagePressedNotification";
NSString *const CTDisplayViewLinkPressed = @"CTDisplayViewLinkPressedNotification";


typedef enum CTDisplayViewState : NSInteger {
    CTDisplayViewStateNormal,       // 普通状态
    CTDisplayViewStateTouching,     // 正在按下，需要弹出放大镜
    CTDisplayViewStateSelecting     // 选中了一些文本，需要弹出复制菜单
}CTDisplayViewState;

#define ANCHOR_TARGET_TAG 1
#define FONT_HEIGHT  40
#define RGB(A, B, C)    [UIColor colorWithRed:A/255.0 green:B/255.0 blue:C/255.0 alpha:1.0]


@interface CTDisplayView()<UIGestureRecognizerDelegate>

@property (nonatomic) NSInteger selectionStartPosition;
@property (nonatomic) NSInteger selectionEndPosition;
@property (nonatomic) CTDisplayViewState state;
@property (strong, nonatomic) UIImageView *leftSelectionAnchor;
@property (strong, nonatomic) UIImageView *rightSelectionAnchor;
@property (strong, nonatomic) MagnifiterView *magnifierView;
@property (strong, nonatomic) UIGestureRecognizer * tapRecognizer;

@end

@implementation CTDisplayView

- (id)init {
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupEvents];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupEvents];
    }
    return self;
}

- (void)setData:(CoreTextData *)data {
    _data = data;
    self.state = CTDisplayViewStateNormal;
    [self setNeedsDisplay];
}

- (void)setupAnchors {
    _leftSelectionAnchor = [self createSelectionAnchorWithTop:YES];
    _rightSelectionAnchor = [self createSelectionAnchorWithTop:NO];
    [self addSubview:_leftSelectionAnchor];
    [self addSubview:_rightSelectionAnchor];
}

- (MagnifiterView *)magnifierView {
    if (_magnifierView == nil) {
        _magnifierView = [[MagnifiterView alloc] init];
        _magnifierView.viewToMagnify = self;
        [self addSubview:_magnifierView];
    }
    return _magnifierView;
}

- (UIImage *)cursorWithFontHeight:(CGFloat)height isTop:(BOOL)top {
    // 22
    CGRect rect = CGRectMake(0, 0, 22, height * 2);
    UIColor *color = RGB(28, 107, 222);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    // draw point
    if (top) {
        CGContextAddEllipseInRect(context, CGRectMake(0, 0, 22, 22));
    } else {
        CGContextAddEllipseInRect(context, CGRectMake(0, height * 2 - 22, 22, 22));
    }
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillPath(context);
    // draw line
    [color set];
    CGContextSetLineWidth(context, 4);
    CGContextMoveToPoint(context, 11, 22);
    CGContextAddLineToPoint(context, 11, height * 2 - 22);
    CGContextStrokePath(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImageView *)createSelectionAnchorWithTop:(BOOL)isTop {
    UIImage *image = [self cursorWithFontHeight:FONT_HEIGHT isTop:isTop];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, 0, 11, FONT_HEIGHT);
    return imageView;
}

- (void)removeSelectionAnchor {
    if (_leftSelectionAnchor) {
        [_leftSelectionAnchor removeFromSuperview];
        _leftSelectionAnchor = nil;
    }
    if (_rightSelectionAnchor) {
        [_rightSelectionAnchor removeFromSuperview];
        _rightSelectionAnchor = nil;
    }
}

- (void)removeMaginfierView {
    if (_magnifierView) {
        [_magnifierView removeFromSuperview];
        _magnifierView = nil;
    }
}

- (void)setState:(CTDisplayViewState)state {
    if (_state == state) {
        return;
    }
    _state = state;
    if (_state == CTDisplayViewStateNormal) {
        _selectionStartPosition = -1;
        _selectionEndPosition = -1;
        [self removeSelectionAnchor];
        [self removeMaginfierView];
        [self hideMenuController];
    } else if (_state == CTDisplayViewStateTouching) {
        if (_leftSelectionAnchor == nil && _rightSelectionAnchor == nil) {
            [self setupAnchors];
        }
    } else if (_state == CTDisplayViewStateSelecting) {
        if (_leftSelectionAnchor == nil && _rightSelectionAnchor == nil) {
            [self setupAnchors];
        }
        if (_leftSelectionAnchor.tag != ANCHOR_TARGET_TAG && _rightSelectionAnchor.tag != ANCHOR_TARGET_TAG) {
            [self removeMaginfierView];
            [self hideMenuController];
        }
    }
    [self setNeedsDisplay];
}

- (void)showMenuController {
    if ([self becomeFirstResponder]) {
        CGRect selectionRect = [self rectForMenuController];
        // 翻转坐标系
        CGAffineTransform transform =  CGAffineTransformMakeTranslation(0, self.bounds.size.height);
        transform = CGAffineTransformScale(transform, 1.f, -1.f);
        selectionRect = CGRectApplyAffineTransform(selectionRect, transform);

        UIMenuController *theMenu = [UIMenuController sharedMenuController];
        [theMenu setTargetRect:selectionRect inView:self];
        [theMenu setMenuVisible:YES animated:YES];
    }
}

- (void)hideMenuController {
    if ([self resignFirstResponder]) {
        UIMenuController *theMenu = [UIMenuController sharedMenuController];
        [theMenu setMenuVisible:NO animated:YES];
    }
}

- (void)setupEvents {
    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(userTapGestureDetected:)];
    
    UIGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(userLongPressedGuestureDetected:)];
    [self addGestureRecognizer:longPressRecognizer];

    UIGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(userPanGuestureDetected:)];
//    [self addGestureRecognizer:panRecognizer];

    self.userInteractionEnabled = YES;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (self.data == nil) {
        return;
    }
    if (self.data.imageArray.count > 0 || self.data.linkArray.count > 0) {
        [self removeGestureRecognizer:_tapRecognizer];
        [self addGestureRecognizer:_tapRecognizer];
    }

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.data.height);
    CGContextScaleCTM(context, 1.0, -1.0);

    if (self.state == CTDisplayViewStateTouching || self.state == CTDisplayViewStateSelecting) {
        [self drawSelectionArea];
        [self drawAnchors];
    }

    CTFrameDraw(self.data.ctFrame, context);
    
    for (CoreTextImageData * imageData in self.data.imageArray) {
        NSString *url = [imageData.url stringByRemovingPercentEncoding];
        NSError *error;
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url] options:(NSDataReadingMappedIfSafe) error:&error];
        UIImage *image = [UIImage imageWithData:data];
        if (image) {
            CGContextDrawImage(context, imageData.imagePosition, image.CGImage);
        }
    }
}

- (void)userTapGestureDetected:(UIGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:self];
    if (_state == CTDisplayViewStateNormal) {
        for (CoreTextImageData * imageData in self.data.imageArray) {
            // 翻转坐标系，因为imageData中的坐标是CoreText的坐标系
            CGRect imageRect = imageData.imagePosition;
            CGPoint imagePosition = imageRect.origin;
            imagePosition.y = self.bounds.size.height - imageRect.origin.y - imageRect.size.height;
            CGRect rect = CGRectMake(imagePosition.x, imagePosition.y, imageRect.size.width, imageRect.size.height);
            // 检测点击位置 Point 是否在rect之内
            if (CGRectContainsPoint(rect, point)) {
                NSLog(@"hint image");
                // 在这里处理点击后的逻辑
                NSDictionary *userInfo = @{ @"imageData": imageData };
                if (_handler) {
                    _handler(userInfo);
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:CTDisplayViewImagePressed
                                                                    object:self userInfo:userInfo];
                return;
            }
        }
        
        CoreTextLinkData *linkData = [CoreTextUtils touchLinkInView:self atPoint:point data:self.data];
        if (linkData) {
            NSLog(@"hint link!");
            NSDictionary *userInfo = @{ @"linkData": linkData };
            if (_handler) {
                _handler(userInfo);
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:CTDisplayViewLinkPressed
                                                                object:self userInfo:userInfo];
            return;
        }
    } else {
        self.state = CTDisplayViewStateNormal;
    }
}

- (void)userLongPressedGuestureDetected:(UILongPressGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:self];
//    debugMethod();
//    debugLog(@"state = %d", recognizer.state);
//    debugLog(@"point = %@", NSStringFromCGPoint(point));
    if (recognizer.state == UIGestureRecognizerStateBegan ||
        recognizer.state == UIGestureRecognizerStateChanged) {
        CFIndex index = [CoreTextUtils touchContentOffsetInView:self atPoint:point data:self.data];
        if (index != -1 && index < self.data.content.length) {
            _selectionStartPosition = index;
            _selectionEndPosition = index + 2;
        }
        self.magnifierView.touchPoint = point;
        self.state = CTDisplayViewStateTouching;
    } else {
        if (_selectionStartPosition >= 0 && _selectionEndPosition <= self.data.content.length) {
            self.state = CTDisplayViewStateSelecting;
            [self showMenuController];
        } else {
            self.state = CTDisplayViewStateNormal;
        }
    }
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
//    debugMethod();
    if (action == @selector(copy:) || action == @selector(selectAll:)) {
        return YES;
    }
//    if (action == @selector(cut:) || action == @selector(copy:) || action == @selector(paste:) || action == @selector(selectAll:)) {
//        return YES;
//    }
    return NO;
}

- (void)userPanGuestureDetected:(UIGestureRecognizer *)recognizer {
    if (self.state == CTDisplayViewStateNormal) {
        
        return;
    }
    CGPoint point = [recognizer locationInView:self];
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        if (_leftSelectionAnchor && CGRectContainsPoint(CGRectInset(_leftSelectionAnchor.frame, -25, -6), point)) {
//            debugLog(@"try to move left anchor");
            _leftSelectionAnchor.tag = ANCHOR_TARGET_TAG;
            [self hideMenuController];
        } else if (_rightSelectionAnchor && CGRectContainsPoint(CGRectInset(_rightSelectionAnchor.frame, -25, -6), point)) {
//            debugLog(@"try to move right anchor");
            _rightSelectionAnchor.tag = ANCHOR_TARGET_TAG;
            [self hideMenuController];
        }
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CFIndex index = [CoreTextUtils touchContentOffsetInView:self atPoint:point data:self.data];
        if (index == -1) {
            return;
        }
        if (_leftSelectionAnchor.tag == ANCHOR_TARGET_TAG && index < _selectionEndPosition) {
//            debugLog(@"change start position to %ld", index);
            _selectionStartPosition = index;
            self.magnifierView.touchPoint = point;
            [self hideMenuController];
        } else if (_rightSelectionAnchor.tag == ANCHOR_TARGET_TAG && index > _selectionStartPosition) {
//            debugLog(@"change end position to %ld", index);
            _selectionEndPosition = index;
            self.magnifierView.touchPoint = point;
            [self hideMenuController];
        }

    } else if (recognizer.state == UIGestureRecognizerStateEnded ||
               recognizer.state == UIGestureRecognizerStateCancelled) {
//        debugLog(@"end move");
        _leftSelectionAnchor.tag = 0;
        _rightSelectionAnchor.tag = 0;
        [self removeMaginfierView];
        [self showMenuController];
    }
    [self setNeedsDisplay];
}

- (void)drawAnchors {
    if (_selectionStartPosition < 0 || _selectionEndPosition > self.data.content.length) {
        return;
    }
    CTFrameRef textFrame = self.data.ctFrame;
    CFArrayRef lines = CTFrameGetLines(self.data.ctFrame);
    if (!lines) {
        return;
    }

    // 翻转坐标系
    CGAffineTransform transform =  CGAffineTransformMakeTranslation(0, self.bounds.size.height);
    transform = CGAffineTransformScale(transform, 1.f, -1.f);

    CFIndex count = CFArrayGetCount(lines);
    // 获得每一行的origin坐标
    CGPoint origins[count];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0,0), origins);
    for (int i = 0; i < count; i++) {
        CGPoint linePoint = origins[i];
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CFRange range = CTLineGetStringRange(line);

        if ([self isPosition:_selectionStartPosition inRange:range]) {
            CGFloat ascent, descent, leading, offset;
            offset = CTLineGetOffsetForStringIndex(line, _selectionStartPosition, NULL);
            CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
            CGPoint origin = CGPointMake(linePoint.x + offset - 5, linePoint.y + ascent + 11);
            origin = CGPointApplyAffineTransform(origin, transform);
            _leftSelectionAnchor.origin = origin;
        }
        if ([self isPosition:_selectionEndPosition inRange:range]) {
            CGFloat ascent, descent, leading, offset;
            offset = CTLineGetOffsetForStringIndex(line, _selectionEndPosition, NULL);
            CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
            CGPoint origin = CGPointMake(linePoint.x + offset - 5, linePoint.y + ascent + 11);
            origin = CGPointApplyAffineTransform(origin, transform);
            _rightSelectionAnchor.origin = origin;
            break;
        }
    }
}

- (void)drawSelectionArea {
    if (_selectionStartPosition < 0 || _selectionEndPosition > self.data.content.length) {
        return;
    }
    CTFrameRef textFrame = self.data.ctFrame;
    CFArrayRef lines = CTFrameGetLines(self.data.ctFrame);
    if (!lines) {
        return;
    }
    CFIndex count = CFArrayGetCount(lines);
    // 获得每一行的origin坐标
    CGPoint origins[count];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0,0), origins);
    for (int i = 0; i < count; i++) {
        CGPoint linePoint = origins[i];
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CFRange range = CTLineGetStringRange(line);
        // 1. start和end在一个line,则直接弄完break
        if ([self isPosition:_selectionStartPosition inRange:range] && [self isPosition:_selectionEndPosition inRange:range]) {
            CGFloat ascent, descent, leading, offset, offset2;
            offset = CTLineGetOffsetForStringIndex(line, _selectionStartPosition, NULL);
            offset2 = CTLineGetOffsetForStringIndex(line, _selectionEndPosition, NULL);
            CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
            CGRect lineRect = CGRectMake(linePoint.x + offset, linePoint.y - descent, offset2 - offset, ascent + descent);
            [self fillSelectionAreaInRect:lineRect];
            break;
        }

        // 2. start和end不在一个line
        // 2.1 如果start在line中，则填充Start后面部分区域
        if ([self isPosition:_selectionStartPosition inRange:range]) {
            CGFloat ascent, descent, leading, width, offset;
            offset = CTLineGetOffsetForStringIndex(line, _selectionStartPosition, NULL);
            width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
            CGRect lineRect = CGRectMake(linePoint.x + offset, linePoint.y - descent, width - offset, ascent + descent);
            [self fillSelectionAreaInRect:lineRect];
        } // 2.2 如果 start在line前，end在line后，则填充整个区域
        else if (_selectionStartPosition < range.location && _selectionEndPosition >= range.location + range.length) {
            CGFloat ascent, descent, leading, width;
            width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
            CGRect lineRect = CGRectMake(linePoint.x, linePoint.y - descent, width, ascent + descent);
            [self fillSelectionAreaInRect:lineRect];
        } // 2.3 如果start在line前，end在line中，则填充end前面的区域,break
        else if (_selectionStartPosition < range.location && [self isPosition:_selectionEndPosition inRange:range]) {
            CGFloat ascent, descent, leading, width, offset;
            offset = CTLineGetOffsetForStringIndex(line, _selectionEndPosition, NULL);
            width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
            CGRect lineRect = CGRectMake(linePoint.x, linePoint.y - descent, offset, ascent + descent);
            [self fillSelectionAreaInRect:lineRect];
        }
    }
}

- (CGRect)rectForMenuController {
    if (_selectionStartPosition < 0 || _selectionEndPosition > self.data.content.length) {
        return CGRectZero;
    }
    CTFrameRef textFrame = self.data.ctFrame;
    CFArrayRef lines = CTFrameGetLines(self.data.ctFrame);
    if (!lines) {
        return CGRectZero;
    }
    CFIndex count = CFArrayGetCount(lines);
    // 获得每一行的origin坐标
    CGPoint origins[count];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0,0), origins);

    CGRect resultRect = CGRectZero;
    for (int i = 0; i < count; i++) {
        CGPoint linePoint = origins[i];
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CFRange range = CTLineGetStringRange(line);
        // 1. start和end在一个line,则直接弄完break
        if ([self isPosition:_selectionStartPosition inRange:range] && [self isPosition:_selectionEndPosition inRange:range]) {
            CGFloat ascent, descent, leading, offset, offset2;
            offset = CTLineGetOffsetForStringIndex(line, _selectionStartPosition, NULL);
            offset2 = CTLineGetOffsetForStringIndex(line, _selectionEndPosition, NULL);
            CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
            CGRect lineRect = CGRectMake(linePoint.x + offset, linePoint.y - descent, offset2 - offset, ascent + descent);
            resultRect = lineRect;
            break;
        }
    }
    if (!CGRectIsEmpty(resultRect)) {
        return resultRect;
    }

    // 2. start和end不在一个line
    for (int i = 0; i < count; i++) {
        CGPoint linePoint = origins[i];
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CFRange range = CTLineGetStringRange(line);
        // 如果start在line中，则记录当前为起始行
        if ([self isPosition:_selectionStartPosition inRange:range]) {
            CGFloat ascent, descent, leading, width, offset;
            offset = CTLineGetOffsetForStringIndex(line, _selectionStartPosition, NULL);
            width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
            CGRect lineRect = CGRectMake(linePoint.x + offset, linePoint.y - descent, width - offset, ascent + descent);
            resultRect = lineRect;
        }
    }
    return resultRect;
}

- (BOOL)isPosition:(NSInteger)position inRange:(CFRange)range {
    if (position >= range.location && position < range.location + range.length) {
        return YES;
    } else {
        return NO;
    }
}

- (void)fillSelectionAreaInRect:(CGRect)rect {
    UIColor *bgColor = RGB(204, 221, 236);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, bgColor.CGColor);
    CGContextFillRect(context, rect);
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)copy:(id)sender{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:@""];
    NSRange range = NSMakeRange(self.selectionStartPosition, self.selectionEndPosition);
    NSString *selectedString = [self.data.content.string substringWithRange:range];
    NSLog(@"selectedString:%@",selectedString);
    [pasteboard setImage:[UIImage imageNamed:@"coretext-image-1.jpg"]];
    
    NSArray *images = [pasteboard images];
    NSLog(@"images:%@",images);
}

- (void)selectAll:(id)sender{
    
}

@end
