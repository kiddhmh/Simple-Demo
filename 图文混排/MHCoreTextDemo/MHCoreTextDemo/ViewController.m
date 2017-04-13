//
//  ViewController.m
//  MHCoreTextDemo
//
//  Created by 胡明昊 on 17/4/13.
//  Copyright © 2017年 ccic. All rights reserved.
//

#import "ViewController.h"
#import "MHTextView.h"
#import "MHOptimize.h"


@interface ViewController ()<MHTextViewDelegate>

@property (nonatomic, strong) MHTextView * textView;
@property (nonatomic, strong) NSFileManager * txtManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString * filePath = [[NSBundle mainBundle] pathForResource: @"三体" ofType: @"txt"];
    NSData * data = [NSData dataWithContentsOfFile: filePath];
    NSInteger length = 900;
    NSData * subData = [data subdataWithRange: NSMakeRange(0, length)];
    NSString * text = [[NSString alloc] initWithData: subData encoding: CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
    while (!text) {
        length++;
        subData = [data subdataWithRange: NSMakeRange(0, length)];
        text = [[NSString alloc] initWithData: subData encoding: CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
    }
    NSLog(@"read text: %@ \n ----- length: %lu", text, text.length);
    
    //    NSString * fileText = [[NSString alloc] initWithData: txtData encoding: encoding];
    //    NSLog(@"fileText %@", fileText);
    
    MHTextView * textView = [[MHTextView alloc] initWithFrame: self.view.bounds];
    textView.delegate = self;
    [self.view addSubview: textView];
    textView.text = text;
    textView.center = self.view.center;
    _textView = textView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)textView: (MHTextView *)textView didSelectedHyperlink: (NSString *)hyperlink
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle: nil message: hyperlink preferredStyle: UIAlertControllerStyleAlert];
    [alert addAction: [UIAlertAction actionWithTitle: @"yes" style: UIAlertActionStyleCancel handler: nil]];
    [self presentViewController: alert animated: YES completion: nil];
}

- (void)textView: (MHTextView *)textView didSelectedEmoji: (NSString *)emojiName
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle: nil message: emojiName preferredStyle: UIAlertControllerStyleAlert];
    [alert addAction: [UIAlertAction actionWithTitle: @"yes" style: UIAlertActionStyleCancel handler: nil]];
    [self presentViewController: alert animated: YES completion: nil];
}

- (void)textView: (MHTextView *)textView didFinishTextRender: (NSInteger)reasonableLength
{
    
}


@end
