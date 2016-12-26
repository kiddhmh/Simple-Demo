//
//  NSURLRequest+MutableCopyWorkaround.m
//  NSURLProtocolOC-webView
//
//  Created by 胡明昊 on 16/12/26.
//  Copyright © 2016年 CMCC. All rights reserved.
//

#import "NSURLRequest+MutableCopyWorkaround.h"

@implementation NSURLRequest (MutableCopyWorkaround)

- (id) mutableCopyWorkaround {
    NSMutableURLRequest *mutableURLRequest = [[NSMutableURLRequest alloc] initWithURL:[self URL]
                                                                          cachePolicy:[self cachePolicy]
                                                                      timeoutInterval:[self timeoutInterval]];
    [mutableURLRequest setAllHTTPHeaderFields:[self allHTTPHeaderFields]];
    if ([self HTTPBodyStream]) {
        [mutableURLRequest setHTTPBodyStream:[self HTTPBodyStream]];
    } else {
        [mutableURLRequest setHTTPBody:[self HTTPBody]];
    }
    [mutableURLRequest setHTTPMethod:[self HTTPMethod]];
    
    return mutableURLRequest;
}

@end
