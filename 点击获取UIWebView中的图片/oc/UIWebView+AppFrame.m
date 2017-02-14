//
//  UIWebView+AppFrame.m
//  ZhiHuRiBaoExample
//
//  Created by 胡明昊 on 17/2/9.
//  Copyright © 2017年 HQ. All rights reserved.
//

typedef void (^MHClickImageBlock)(NSString *URLString);
#import "UIWebView+AppFrame.h"
#import <objc/runtime.h>


@interface UIWebView()<UIGestureRecognizerDelegate>
@property (nonatomic, copy) MHClickImageBlock mh_clickImage;
@property (nonatomic, copy) NSString* mh_imageString;
@property (nonatomic, strong) NSNumber* mh_isClickImage;
@property (nonatomic, strong) UITapGestureRecognizer* mh_customTap;
@end

@implementation UIWebView (AppFrame)

- (MHClickImageBlock)mh_clickImage{
    return objc_getAssociatedObject(self, @selector(mh_clickImage));
}
- (void)setmh_clickImage:(MHClickImageBlock)clickImage{
    objc_setAssociatedObject(self, @selector(mh_clickImage), clickImage, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)mh_imageString{
    return objc_getAssociatedObject(self, @selector(mh_imageString));
}
-(void)setmh_imageString:(NSString *)mh_imageString{
    objc_setAssociatedObject(self, @selector(mh_imageString), mh_imageString, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSNumber*)mh_isClickImage{
    return objc_getAssociatedObject(self, @selector(mh_isClickImage));
}
- (void)setmh_isClickImage:(NSNumber*)mh_isClickImage{
    objc_setAssociatedObject(self, @selector(mh_isClickImage), mh_isClickImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UITapGestureRecognizer *)mh_customTap{
    return objc_getAssociatedObject(self, @selector(mh_customTap));
}

- (void)setmh_customTap:(UITapGestureRecognizer *)mh_customTap{
    objc_setAssociatedObject(self, @selector(mh_customTap), mh_customTap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void)mh_didClickImageCall:(void (^)(NSString *imgURLString))clickImage{
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:nil action:nil];
    [self addGestureRecognizer:gesture];
    
    gesture.delegate = self;
    self.mh_customTap = gesture;
    self.mh_clickImage = clickImage;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        if (gestureRecognizer == self.mh_customTap) {
            CGPoint touchPoint = [touch locationInView:self];
            NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", touchPoint.x, touchPoint.y];
            NSString *URLString = [self stringByEvaluatingJavaScriptFromString:imgURL];
            self.mh_isClickImage = @(NO);
            if (URLString == nil) {
                URLString = @"";
            }
            if (URLString.length > 0) {
                self.mh_isClickImage = @(YES);
                self.mh_imageString = URLString;
            }
        }
    }
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer == self.mh_customTap) {
        if (self.mh_imageString && [self.mh_isClickImage boolValue]) {
            !self.mh_clickImage ? : self.mh_clickImage(self.mh_imageString);
            self.mh_imageString = nil;
        }
        return NO;
    }
    
    return YES;
}


@end

