//
//  main.m
//  RuntimeDemo5
//
//  Created by daiyan on 16/6/17.
//  Copyright © 2016年 DaiYan. All rights reserved.
//  Runtime实现JSON和Model互转

#import <Foundation/Foundation.h>
#import "People.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        NSDictionary *dict = @{
                               @"name" : @"苍井空",
                               @"age" : @18,
                               @"occupation" : @"老师",
                               @"nationality" : @"日本"
                               };
        
        //字典转模型
        People *cangTeather = [[People alloc] initWithDictionary:dict];
        NSLog(@"热烈欢迎,从%@远道而来的%@岁的%@%@",cangTeather.nationality,cangTeather.age,cangTeather.name,cangTeather.occupation);
        
        
        //模型转字典
        NSDictionary *covertedDict = [cangTeather coverToDictionary];
        NSLog(@"%@",covertedDict);
    }
    return 0;
}
