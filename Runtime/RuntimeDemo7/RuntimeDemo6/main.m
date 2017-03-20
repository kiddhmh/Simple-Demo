//
//  main.m
//  RuntimeDemo6
//
//  Created by daiyan on 16/6/17.
//  Copyright © 2016年 DaiYan. All rights reserved.
//  这里我们不声明sing方法，将调用途中动态更换调用对象。在第一首代码的基础上，创建Bird的model

#import <Foundation/Foundation.h>
#import "People.h"
#import "Bird.h"

#if TARGET_IPHONE_SIMULATOR
#import <objc/objc-runtime.h>
#else
#import <objc/runtime.h>
#import <objc/message.h>
#endif

int main(int argc, const char * argv[]) {
    @autoreleasepool {
       
        Bird *bird = [[Bird alloc] init];
        bird.name = @"小小鸟";
        
        ((void (*)(id, SEL))objc_msgSend)((id)bird, @selector(sing));
    }
    return 0;
}
