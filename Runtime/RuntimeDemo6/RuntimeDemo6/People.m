//
//  People.m
//  RuntimeDemo6
//
//  Created by daiyan on 16/6/17.
//  Copyright © 2016年 DaiYan. All rights reserved.
//

#import "People.h"

#if TARGET_IPHONE_SIMULATOR
#import <objc/objc-runtime.h>
#else
#import <objc/runtime.h>
#import <objc/message.h>
#endif

@implementation People

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    // 我们没有给People类声明sing方法，我们这里动态添加方法
    if ([NSStringFromSelector(sel) isEqualToString:@"sing"]) {
        class_addMethod(self, sel, (IMP)otherSing, "v@:");
        return NO;
    }
    return [super resolveInstanceMethod:sel];
}



void otherSing(id self, SEL cmd)
{
    NSLog(@"%@ 唱歌啦！",((People *)self).name);
}


- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return nil;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature *sinn = [[NSMethodSignature alloc] init];
    return sinn;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    
}

/*
 第一步：通过resolveInstanceMethod：方法决定是否动态添加方法。如果返回Yes则通过class_addMethod动态添加方法，消息得到处理，结束；如果返回No，则进入下一步；
 第二步：这步会进入forwardingTargetForSelector:方法，用于指定备选对象响应这个selector，不能指定为self。如果返回某个对象则会调用对象的方法，结束。如果返回nil，则进入第三部；
 第三步：这步我们要通过methodSignatureForSelector:方法签名，如果返回nil，则消息无法处理。如果返回methodSignature，则进入下一步；
 第四步：这步调用forwardInvocation：方法，我们可以通过anInvocation对象做很多处理，比如修改实现方法，修改响应对象等，如果方法调用成功，则结束。如果失败，则进入doesNotRecognizeSelector方法，若我们没有实现这个方法，那么就会crash。
 */

@end
