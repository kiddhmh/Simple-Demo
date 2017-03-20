//
//  People.m
//  RuntimeDemo8
//
//  Created by daiyan on 16/6/17.
//  Copyright © 2016年 DaiYan. All rights reserved.
//

#import "People.h"

#if TARGET_IPHONE_SIMULAATOR
#import <objc/objc-runtime.h>
#else
#import <objc/runtime.h>
#import <objc/message.h>
#endif

@implementation People

//第一步：我们不动态添加方法，返回NO，进入第二步；
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    return NO;
}


//第二步：我们不指定备选对象响应aSelector，进入第三步；
- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return nil;
}


//第三步：返回方法选择器，然后进入第四部；
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    if ([NSStringFromSelector(aSelector) isEqualToString:@"sing"]) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return [super methodSignatureForSelector:aSelector];
}


//第四步：修改调用的方法
- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    [anInvocation setSelector:@selector(dance)];
    
    //还要指定是哪个对象的方法
    [anInvocation invokeWithTarget:self];
}


//若forwardInvocation没有实现，则会调用此方法
- (void)doesNotRecognizeSelector:(SEL)aSelector
{
    NSLog(@"消息无法处理:%@",NSStringFromSelector(aSelector));
}

- (void)dance
{
    NSLog(@"跳舞！！！");
}

@end
