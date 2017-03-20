//
//  main.m
//  RuntimeDemo2
//
//  Created by daiyan on 16/6/16.
//  Copyright © 2016年 DaiYan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        Person *cangTeacher = [[Person alloc] init];
        cangTeacher.name = @"苍井空";
        cangTeacher.age = 18;
        [cangTeacher setValue:@"老师" forKey:@"occupation"];
        
        NSDictionary *propertyResultDic = [cangTeacher allProperties];
        for (NSString *propertyName in propertyResultDic.allKeys) {
            NSLog(@"PropertyName:%@, propertyValue:%@",propertyName, propertyResultDic[propertyName]);
        }
        
        NSDictionary *ivarResultDic = [cangTeacher allIvars];
        for (NSString *ivarName in ivarResultDic.allKeys) {
            NSLog(@"ivarName:%@, ivarValue:%@",ivarName, ivarResultDic[ivarName]);
        }
        
        NSDictionary *methodResultDic = [cangTeacher allMethods];
        NSLog(@"%@",methodResultDic);
        for (NSString *methodName in ivarResultDic.allKeys) {
            NSLog(@"methodName:%@, argumentsCount:%@",methodName, methodResultDic[methodName]);
        }
    }
    return 0;
}
