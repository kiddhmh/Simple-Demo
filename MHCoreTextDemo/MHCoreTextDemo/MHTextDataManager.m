//
//  MHTextDataManager.m
//  MHCoreTextDemo
//
//  Created by 胡明昊 on 17/4/13.
//  Copyright © 2017年 ccic. All rights reserved.
//

#import "MHTextDataManager.h"

#ifndef MAX_CACHE_NUMBER
#define MAX_CACHE_NUMBER 1024 * 1024 * 2
#endif

static NSString * const kMHTextDataAttributeName = @"kMHTextDataAttributeName";
static NSString * const kMHDataVisitTimeAttributeName = @"kMHDataVisitTimeAttributeName";
static NSString * const kMHCacheStorageMemoryAttributeName = @"kMHCacheStorageMemoryAttributeName";

static inline dispatch_queue_t kSerialQueue()
{
    static dispatch_queue_t serialQueue;
    static dispatch_once_t queueOnce;
    dispatch_once(&queueOnce, ^{
        serialQueue = dispatch_queue_create("com.sindrilin.serial_queue", DISPATCH_QUEUE_SERIAL);
    });
    return serialQueue;
}

static inline NSMutableDictionary * kTextCacheStorage()
{
    static NSMutableDictionary * textStorage;
    static dispatch_once_t storageOnce;
    dispatch_once(&storageOnce, ^{
        textStorage = @{}.mutableCopy;
    });
    return textStorage;
}

static inline void kCacheData(NSData * data, NSString * name)
{
    NSMutableDictionary * textStorage = kTextCacheStorage();
    textStorage[name] = data;
    
    __block NSInteger cacheMemory = [textStorage[kMHCacheStorageMemoryAttributeName] integerValue];
    cacheMemory += data.length;
    /*!
     *  @brief 缓存数据超过2M时清空访问量少的数据
     */
    dispatch_async(kSerialQueue(), ^{
        @autoreleasepool {
            NSInteger lessVisitTime = 1;
            while (cacheMemory > MAX_CACHE_NUMBER) {
                
                NSMutableArray * removeKeys = @[].mutableCopy;
                for (NSString * name in textStorage) {
                    NSDictionary * cacheData = textStorage[name];
                    if ([cacheData[kMHDataVisitTimeAttributeName] integerValue] <= lessVisitTime) {
                        [removeKeys addObject: name];
                    }
                }
                [textStorage removeObjectsForKeys: removeKeys];
                lessVisitTime++;
                cacheMemory = [textStorage[kMHCacheStorageMemoryAttributeName] integerValue];
            }
            textStorage[kMHCacheStorageMemoryAttributeName] = @(cacheMemory);
        }
    });
    
}

static inline NSData * kDataFrom(NSString * name)
{
    NSMutableDictionary * textStorage = kTextCacheStorage();
    NSDictionary * cacheData = textStorage[name];
    if (cacheData) {
        NSInteger visitTime = [cacheData[kMHDataVisitTimeAttributeName] integerValue];
        textStorage[name] = @{
                              kMHTextDataAttributeName: cacheData[kMHTextDataAttributeName],
                              kMHDataVisitTimeAttributeName: @(++visitTime),
                              };
    }
    return cacheData[kMHTextDataAttributeName];
}

static inline void kTextDataFrom(NSString * name, NSString * type, void(^handler)(NSData * textData))
{
    if (!handler) { return; }
    NSString * textName = [name stringByAppendingFormat: @".%@", type];
    NSData * textData = kDataFrom(textName);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (!textData) {
            NSString * filePath = [[NSBundle mainBundle] pathForResource: name ofType: type];
            NSData * data = [NSData dataWithContentsOfFile: filePath options: NSDataReadingMappedIfSafe error: nil];
            kCacheData(data, textName);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(textData);
        });
    });
}


@implementation MHTextDataManager

+ (void)textDataWithName: (NSString *)name handler: (void (^)(NSData *))handler
{
    [self textDataWithName: name type: @"txt" handler: handler];
}

+ (void)textDataWithName: (NSString *)name type: (NSString *)type handler: (void (^)(NSData *))handler
{
    kTextDataFrom(name, type, handler);
}


@end
