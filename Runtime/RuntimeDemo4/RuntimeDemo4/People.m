//
//  People.m
//  RuntimeDemo4
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

///解档
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {

        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList([People class], &count);

        for (NSUInteger i = 0; i < count; i ++) {
            const char *name = ivar_getName(ivars[i]);
            NSString *key = [NSString stringWithUTF8String:name];
            id value = [aDecoder decodeObjectForKey:key];
            [self setValue:value forKey:key];
        }
        free(ivars);
    }
    return  self;
}

///归档
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([People class], &count);

    for (NSUInteger i = 0; i < count; i ++) {
        const char *name = ivar_getName(ivars[i]);
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:key];
        [aCoder encodeObject:value forKey:key];
    }
    free(ivars);
}


@end

