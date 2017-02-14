//
//  MHCacheModel.m
//  NSURLProtocolOC-webView
//
//  Created by 胡明昊 on 16/12/26.
//  Copyright © 2016年 CMCC. All rights reserved.
//

#import "MHCacheModel.h"

@implementation MHCacheModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.data forKey:@"data"];
    [aCoder encodeObject:self.response forKey:@"response"];
    [aCoder encodeObject:self.redirectRequest forKey:@"redirectRequest"];
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _data = [coder decodeObjectForKey:@"data"];
        _response = [coder decodeObjectForKey:@"response"];
        _redirectRequest = [coder decodeObjectForKey:@"redirectRequest"];
    }
    return self;
}

@end
