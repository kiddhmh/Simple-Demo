//
//  MHCache.m
//  NSURLProtocolOC-webView
//
//  Created by 胡明昊 on 16/12/26.
//  Copyright © 2016年 CMCC. All rights reserved.
//

#import "MHCache.h"

static NSString *const cacheName = @"MHCacheName";

@implementation MHCache

+ (instancetype)defaultcache {
    
    static MHCache *cache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [[MHCache alloc] initWithName:cacheName];
    });
    
    return cache;
}

@end
