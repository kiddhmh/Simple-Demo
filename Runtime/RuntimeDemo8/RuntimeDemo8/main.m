//
//  main.m
//  RuntimeDemo8
//
//  Created by daiyan on 16/6/17.
//  Copyright © 2016年 DaiYan. All rights reserved.
//  将sing方法修改为dance方法

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
        
        ((void(*)(id, SEL)) objc_msgSend)((id)cangTeather,@selector(sing));
    }
    return 0;
}
