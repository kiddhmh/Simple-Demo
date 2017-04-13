//
//  ViewController.m
//  TextKItDemo
//
//  Created by 胡明昊 on 17/4/13.
//  Copyright © 2017年 ccic. All rights reserved.
//

#import "ViewController.h"
#import "MHLabel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MHLabel *label = [[MHLabel alloc] initWithFrame:CGRectMake(100, 100, 200, 100)];
    [self.view addSubview:label];
    label.mhText = @"这是一段测试，如有疑问请点击http://www.baidu.com";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
