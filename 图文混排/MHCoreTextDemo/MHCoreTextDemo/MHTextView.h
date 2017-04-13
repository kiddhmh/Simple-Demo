//
//  MHTextView.h
//  MHCoreTextDemo
//
//  Created by 胡明昊 on 17/4/13.
//  Copyright © 2017年 ccic. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MHTextView;
@protocol MHTextViewDelegate <NSObject>

@optional
- (void)textView: (MHTextView *)textView didSelectedEmoji: (NSString *)emojiName;
- (void)textView: (MHTextView *)textView didSelectedHyperlink: (NSString *)hyperlink;
- (void)textView: (MHTextView *)textView didFinishTextRender: (NSInteger)reasonableLength;

@end


/**
 超链接富文本/emoji表情控件
 */
@interface MHTextView : UIView

/**
 emoji图片是否能够响应点击
 */
@property (nonatomic, assign) BOOL emojiUserInteractionEnabled;

/**
 回调代理
 */
@property (nonatomic, weak) id<MHTextViewDelegate> delegate;

/**
 显示文本（所有的链接文本、图片名称都应该放到这里面）
 */
@property (nonatomic, copy) NSString * text;

/**
 文本属性
 */
@property (nonatomic, strong) NSDictionary * textAttributes;

/**
 超链接文本映射
 key值为文本，value是地址链接。比如@{ @"百度": @"https://www.baidu.com" }
 */
@property (nonatomic, strong) NSDictionary * hyperlinkMapper;

/**
 emoji表情映射
 key值为图片文本，value为图片名称。比如@{ @"[emoji11]": @"emoji11" }
 */
@property (nonatomic, strong) NSDictionary * emojiTextMapper;

@end
