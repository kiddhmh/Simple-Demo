//
//  NSURLRequest+MutableCopyWorkaround.h
//  NSURLProtocolOC-webView
//
//  Created by 胡明昊 on 16/12/26.
//  Copyright © 2016年 CMCC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLRequest (MutableCopyWorkaround)

- (id) mutableCopyWorkaround;

@end
