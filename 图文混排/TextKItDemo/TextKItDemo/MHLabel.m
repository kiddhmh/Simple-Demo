//
//  MHLabel.m
//  TextKItDemo
//
//  Created by 胡明昊 on 17/4/13.
//  Copyright © 2017年 ccic. All rights reserved.
//

#import "MHLabel.h"

@interface MHLabel ()

/**
 属性文本存储
 */
@property (nonatomic,strong) NSTextStorage *textStorage;

/**
 负责文本布局
 */
@property (nonatomic,strong) NSLayoutManager *layoutManager;

/**
 文本绘制区域
 */
@property (nonatomic,strong) NSTextContainer *container;

/**
 返回textStorage 中高度URL range 数组
 */
@property (nonatomic,strong) NSMutableArray *urlRanges;
@end


@implementation MHLabel

- (void)setMhText:(NSString *)mhText {
    _mhText = mhText;
    [self prepareTextContent];
}


- (NSMutableArray *)urlRanges {
    if (!_urlRanges) {
        _urlRanges = [NSMutableArray array];
    }
    return _urlRanges;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareTextSystem];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self prepareTextSystem];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    //指定绘制文本的区域
    self.container.size = self.bounds.size;
}



/**
 绘制
 */
- (void)drawTextInRect:(CGRect)rect {
    NSRange range = NSMakeRange(0, self.textStorage.length);
    
    //绘制背景 在iOS 中绘制巩固走类似油画，后绘制的内容，会把之前绘制的内容覆盖
    [self.layoutManager drawBackgroundForGlyphRange:range atPoint:CGPointZero];
    
    //绘制 Glyphs 字形
    [self.layoutManager drawGlyphsForGlyphRange:range atPoint:CGPointZero];
}


/**
    准备文本系统
 */
- (void)prepareTextSystem {
    
    // 初始化属性
    self.textStorage = [[NSTextStorage alloc] init];
    self.layoutManager = [[NSLayoutManager alloc] init];
    self.container = [[NSTextContainer alloc] init];
    
    // 开启用户交互
    self.userInteractionEnabled = YES;
    
    // 准备文本内容
    [self prepareTextContent];
    // 设置对象的关系
    [self.textStorage addLayoutManager:self.layoutManager];
    [self.layoutManager addTextContainer:self.container];
}



/**
    准备文本内容 - 使用textStorage 接管label 的内容
 */
- (void)prepareTextContent {
    
    if (self.mhText) {
        [self.textStorage setAttributedString:[[NSAttributedString alloc] initWithString:self.mhText]];
    }else if (self.attributedText) {
        [self.textStorage setAttributedString:self.attributedText];
    }else if (self.text) {
        [self.textStorage setAttributedString:[[NSAttributedString alloc] initWithString:self.text]];
    }else {
        [self.textStorage setAttributedString:[[NSAttributedString alloc] initWithString:@""]];
    }
    
    //1.正则表达式
    NSString *patern = @"[a-zA-Z]*://[a-zA-Z0-9/\\.]*";
    NSRegularExpression *regx = [[NSRegularExpression alloc] initWithPattern:patern options:0 error:nil];
    
    //多重匹配
    NSArray *matches = [regx matchesInString:self.textStorage.string options:0 range:NSMakeRange(0, self.textStorage.length)];
    
    //遍历数组,生成range 数组
    for (NSTextCheckingResult *result in matches) {
        [self.urlRanges addObject:NSStringFromRange(result.range)];
    }
    
    NSLog(@"%@",self.urlRanges);
    
    if (self.urlRanges.count == 0) { return; }
    
    //遍历范围数组，设置url 文字的属性
    for (NSString *rangeStr in self.urlRanges) {
        NSRange range = NSRangeFromString(rangeStr);
        [self.textStorage addAttributes:@{
                                          NSForegroundColorAttributeName: [UIColor redColor],
                                          NSBackgroundColorAttributeName: [UIColor groupTableViewBackgroundColor]
                                          } range:range];
    }

}



#pragma mark - 点击事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    // 获取用户点击的位置
    CGPoint point = [[touches anyObject] locationInView:self];
    
    // 获取当前点中字符的索引
    NSUInteger index = [self.layoutManager glyphIndexForPoint:point inTextContainer:self.container];
    
    if (self.urlRanges.count == 0) { return; }
    
    //判断 index 是否子啊urlRanges 的范围内，如果在就高亮
    for (NSString *rangeStr in self.urlRanges) {
        NSRange range = NSRangeFromString(rangeStr);
        if (NSLocationInRange(index, range)) {
            NSLog(@"高亮显示");
            // 修改文本的字体属性
            [self.textStorage addAttributes:@{
                                              NSForegroundColorAttributeName: [UIColor blueColor]
                                              } range:range];
            // 重绘
            [self setNeedsDisplay];
        }else {
            NSLog(@"未检测都可用链接");
        }
    }
}

@end
