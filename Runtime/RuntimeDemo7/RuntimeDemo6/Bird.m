//
//  Bird.m
//  RuntimeDemo6
//
//  Created by daiyan on 16/6/17.
//  Copyright © 2016年 DaiYan. All rights reserved.
//

#import "Bird.h"
#import "People.h"

@implementation Bird

//第一步：我们不动态添加方法，返回NO，进入第二步；
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    return NO;
}

//第二步：我们不指定备选对象响应selector，进入第三步；
- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return nil;
}

//第三步：返回方法选择器，然后进入第四步；
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    if ([NSStringFromSelector(aSelector) isEqualToString:@"sing"]) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return [super methodSignatureForSelector:aSelector];
}

//第四步：这步我们修改调用对象
- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    //我们改变调用对象为People
    People *cangTeather = [[People alloc] init];
    cangTeather.name = @"苍老师";
    [anInvocation invokeWithTarget:cangTeather];
}

@end
