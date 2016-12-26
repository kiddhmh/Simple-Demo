//
//  ViewController.m
//  NSURLProtocolOC-webView
//
//  Created by 胡明昊 on 16/12/26.
//  Copyright © 2016年 CMCC. All rights reserved.
//

#import "ViewController.h"
#import "MHURLProtocol.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NSURLProtocol registerClass:[MHURLProtocol class]];
    
    self.view.backgroundColor = [UIColor cyanColor];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://blog.csdn.net/hmh007/article/details/53887199"]]];
    
    
    /// 不需要缓存的url，取消注册，即不回走urlprotocol机制了
    //    [NSURLProtocol unregisterClass:[MHURLProtocol class]];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
