//
//  NSString+CDEncryption.h
//  NSURLProtocolOC-webView
//
//  Created by 胡明昊 on 16/12/26.
//  Copyright © 2016年 CMCC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CDEncryption)

/**
 *  md5加密
 *
 *  @return (NSString *) 密文
 */
- (NSString *)cd_md5HexDigest;

@end
