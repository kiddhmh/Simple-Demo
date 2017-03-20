//
//  Person.h
//  RuntimeDemo
//
//  Created by daiyan on 16/6/16.
//  Copyright © 2016年 DaiYan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject
{
    NSString *_occupation;
    NSString *_nationality;
}

@property (nonatomic, copy)NSString *name;
@property (nonatomic) NSUInteger age;


- (NSDictionary *)allProperties;
- (NSDictionary *)allIvars;
- (NSDictionary *)allMethods;

@end
