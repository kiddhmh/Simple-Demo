//
//  MHCacheModel.h
//  NSURLProtocolOC-webView
//
//  Created by 胡明昊 on 16/12/26.
//  Copyright © 2016年 CMCC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHCacheModel : NSObject<NSCoding>

@property (nonatomic , strong) NSData *data;
@property (nonatomic , strong) NSURLResponse *response;
@property (nonatomic , strong) NSURLRequest *redirectRequest;

@end
