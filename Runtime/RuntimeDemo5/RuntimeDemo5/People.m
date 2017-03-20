//
//  People.m
//  RuntimeDemo5
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

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        
        for (NSString *key in dictionary.allKeys) {
            
            id value = dictionary[key];
            
            SEL setter = [self propertySetterByKey:key];
            ((void (*)(id, SEL, id))objc_msgSend)(self, setter, value);
        }
    }
    return self;
}



- (NSDictionary *)coverToDictionary
{
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    if (count != 0) {
        NSMutableDictionary *resultDic = [@{} mutableCopy];
        
        for (NSUInteger i = 0; i < count; i ++) {
            const void *propertyName = property_getName(properties[i]);
            NSString *name = [NSString stringWithUTF8String:propertyName];
            
            SEL getter = [self propertyGetterByKey:name];
            if (getter) {
                id value = ((id (*)(id, SEL))objc_msgSend)(self, getter);
                if (value) {
                    resultDic[name] = value;
                }else {
                    resultDic[name] = @"字典的key对应的value不能为nil";
                }
            }
        }
        
        free(properties);
        return resultDic;
    }
    
    free(properties);
    return nil;
}


#pragma mark - private methods

///生成setter方法
- (SEL)propertySetterByKey:(NSString *)key
{
    //首字母大写
    NSString *selName = [NSString stringWithFormat:@"set%@:",key.capitalizedString];
    
    SEL setter = NSSelectorFromString(selName);
    if ([self respondsToSelector:setter]) {
        return setter;
    }
    
    return nil;
}


///生成getter方法
- (SEL)propertyGetterByKey:(NSString *)key
{
    SEL getter = NSSelectorFromString(key);
    if ([self respondsToSelector:getter]) {
        return getter;
    }
    return nil;
}

@end
