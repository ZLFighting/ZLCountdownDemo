//
//  ViewController.m
//  ZLCountdownDemo
//
//  Created by ZL on 2017/8/4.
//  Copyright © 2017年 ZL. All rights reserved.
//

#import "ViewController.h"
#import "ZLNSTimerCountdownController.h"
#import "ZLGCDCountdownController.h"


@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self judementActiveTime];
    
    // 实现跳转入口而已~
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"使用NSTimer来实现" forState:UIControlStateNormal];
    btn.frame = CGRectMake(15, 100, [UIScreen mainScreen].bounds.size.width - 15 * 2, 40);
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [btn addTarget:self action:@selector(btnPress) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor redColor];
    btn.titleLabel.textColor = [UIColor whiteColor];
    btn.layer.cornerRadius = 3.0;
    btn.clipsToBounds = YES;
    [self.view addSubview:btn];
    
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setTitle:@"使用GCD来实现" forState:UIControlStateNormal];
    btn2.frame = CGRectMake(15, 180, [UIScreen mainScreen].bounds.size.width - 15 * 2, 40);
    btn2.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [btn2 addTarget:self action:@selector(btn2Press) forControlEvents:UIControlEventTouchUpInside];
    btn2.backgroundColor = [UIColor redColor];
    btn2.titleLabel.textColor = [UIColor whiteColor];
    btn2.layer.cornerRadius = 3.0;
    btn2.clipsToBounds = YES;
    [self.view addSubview:btn2];
}

#pragma mark - 跳转

- (void)btnPress {
    
    ZLNSTimerCountdownController *vc = [[ZLNSTimerCountdownController alloc] init];
    [self presentViewController:vc animated:NO completion:nil];
}

- (void)btn2Press {
    
    ZLGCDCountdownController *vc = [[ZLGCDCountdownController alloc] init];
    [self presentViewController:vc animated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
