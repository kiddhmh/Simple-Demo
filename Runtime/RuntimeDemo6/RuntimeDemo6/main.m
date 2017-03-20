//
//  main.m
//  RuntimeDemo6
//
//  Created by daiyan on 16/6/17.
//  Copyright © 2016年 DaiYan. All rights reserved.
//  添加sing实例方法，但是不提供方法的实现。验证当找不到方法的实现时，动态添加方法。

#import <Foundation/Foundation.h>
#import "People.h"

#if TARGET_IPHONE_SIMULATOR
#import <objc/objc-runtime.h>
#else
#import <objc/runtime.h>
#import <objc/message.h>
#endif

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        People *cangTeather = [[People alloc] init];
        cangTeather.name = @"苍老师";
        [cangTeather sing];
    }
    return 0;
}
