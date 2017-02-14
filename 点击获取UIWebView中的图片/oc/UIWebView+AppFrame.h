//
//  UIWebView+AppFrame.h
//  ZhiHuRiBaoExample
//
//  Created by 胡明昊 on 17/2/9.
//  Copyright © 2017年 HQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (AppFrame)

/// 点击图片回调 返回被点击图片的地址字符串
- (void)mh_didClickImageCall:(void(^)(NSString* URLString)) clickImage;


@end
