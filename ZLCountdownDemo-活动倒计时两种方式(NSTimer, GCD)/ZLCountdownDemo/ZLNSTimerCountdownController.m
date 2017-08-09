//
//  ZLCountdownController.m
//  ZLCountdownDemo
//
//  Created by ZL on 2017/8/4.
//  Copyright © 2017年 ZL. All rights reserved.
//

#import "ZLNSTimerCountdownController.h"

#define ZLColor(R,G,B) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1]
#define UI_View_Width [UIScreen mainScreen].bounds.size.width//屏幕宽度

@interface ZLNSTimerCountdownController ()

// 倒计时时间显示标签
@property (nonatomic, strong) UILabel *timeLabel;

// 创建活动定时器
@property (nonatomic, strong) NSTimer *activeTimer;

@end

@implementation ZLNSTimerCountdownController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1.0];
    self.title = @"使用NSTimer来实现:时分秒倒计时";
    
    // 活动倒计时
    // 启动倒计时后会每秒钟调用一次方法
    _activeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(activeCountDownAction) userInfo:nil repeats:YES];
    [_activeTimer fire];
    
    // 设置文字颜色
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 100, [UIScreen mainScreen].bounds.size.width - 50 * 2, 80)];
    timeLabel.textColor = [UIColor  redColor];
    timeLabel.numberOfLines = 0;
    timeLabel.text = @"使用NSTimer来实现 活动倒计时";
    [self.view addSubview:timeLabel];
    self.timeLabel = timeLabel;
}

#pragma mark - 倒计时计数

// 实现活动倒计时
-(void)activeCountDownAction {

    // 1.计算截止时间与当前时间差值
    // 倒计时的时间 测试数据
    NSString *deadlineStr = @"2017-08-09 10:28:00";
    // 当前时间的时间戳
    NSDate *dateNow = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *nowStr = [formatter stringFromDate:dateNow];
    // 计算时间差值
    NSInteger secondsCountDown = [self getDateDifferenceWithNowDateStr:nowStr deadlineStr:deadlineStr];

    // 2.先递减 倒计时-1(总时间以秒来计算)
    secondsCountDown--;

    // 3.给时分秒字符串通过递减过后的秒数,重新计算数值,并输出显示
    // 重新计算 时/分/秒
    NSString *str_hour = [NSString stringWithFormat:@"%02ld", secondsCountDown / 3600];
    NSString *str_minute = [NSString stringWithFormat:@"%02ld", (secondsCountDown % 3600) / 60];
    NSString *str_second = [NSString stringWithFormat:@"%02ld", secondsCountDown % 60];
    NSString *format_time = [NSString stringWithFormat:@"%@ : %@ : %@", str_hour, str_minute, str_second];
    // 修改倒计时标签及显示内容
    self.timeLabel.text = [NSString stringWithFormat:@"使用NSTimer来实现 活动倒计时: %@", format_time];

    // 当倒计时结束时做需要的操作: 比如活动到期不能提交
    if(secondsCountDown <= 0) {

        self.timeLabel.text = @"当前活动已结束";

        [_activeTimer invalidate];
        _activeTimer = nil;

        return;
    }
}

/**
 *  获取时间差值  截止时间-当前时间
 *  nowDateStr : 当前时间
 *  deadlineStr : 截止时间
 *  @return 时间戳差值
 */
- (NSInteger)getDateDifferenceWithNowDateStr:(NSString*)nowDateStr deadlineStr:(NSString*)deadlineStr {
    
    NSInteger timeDifference = 0;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yy-MM-dd HH:mm:ss"];
    NSDate *nowDate = [formatter dateFromString:nowDateStr];
    NSDate *deadline = [formatter dateFromString:deadlineStr];
    NSTimeInterval oldTime = [nowDate timeIntervalSince1970];
    NSTimeInterval newTime = [deadline timeIntervalSince1970];
    timeDifference = newTime - oldTime;
    
    return timeDifference;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
