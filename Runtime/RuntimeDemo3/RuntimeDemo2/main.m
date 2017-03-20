//
//  main.m
//  RuntimeDemo2
//
//  Created by daiyan on 16/6/16.
//  Copyright © 2016年 DaiYan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"
#import "Person+Associated.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        Person *cangTeather = [[Person alloc] init];
        cangTeather.name = @"苍井空";
        cangTeather.age = 18;
        [cangTeather setValue:@"老师" forKey:@"occupation"];
        cangTeather.associatedBust = @(90);
        cangTeather.associatedCallBack = ^(){
            
            NSLog(@"苍老师要写代码了");
            
        };
        cangTeather.associatedCallBack();
    }
    return 0;
}
