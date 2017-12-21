# ZLCountdownDemo

iOS活动倒计时的两种实现方式


在做些活动界面或者限时验证码时, 经常会使用一些倒计时突出展现.

![倒计时.png](https://github.com/ZLFighting/ZLCountdownDemo/blob/master/ZLCountdownDemo-活动倒计时两种方式(NSTimer%2C%20GCD)/截图.png)

>现提供两种方案:
一.使用NSTimer定时器来倒计时
二.使用GCD来倒计时(用GCD这个写有一个好处，跳页不会清零, 跳页清零会出现倒计时错误的)

##一. 使用NSTimer定时器来倒计时

**主要步骤:**
Step1. 计算截止时间与当前时间差
Step2. 先递减时间差 倒计时-1(总时间以秒来计算)
Step3. 给时分秒字符串通过递减过后的秒数,重新计算数值,并输出显示.

获取当天的字符串, 格式为年-月-日 时分秒:
```
/**
*  获取当天的字符串
*  @return 格式为年-月-日 时分秒
*/
- (NSString *)getCurrentTimeyyyymmdd {

NSDate *now = [NSDate date];
NSDateFormatter *formatDay = [[NSDateFormatter alloc] init];
formatDay.dateFormat = @"yyyy-MM-dd HH:mm:ss";
NSString *dayStr = [formatDay stringFromDate:now];

return dayStr;
}
```
获取时间差值  截止时间-当前时间:
```
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
```
Step1. 计算时间差值
```
NSInteger secondsCountDown = [self getDateDifferenceWithNowDateStr:nowStr deadlineStr:deadlineStr];
```
Step2. 递减时间差 倒计时-1(总时间以秒来计算):
```
secondsCountDown--;
```
Step3.活动倒计时:
```
// 启动倒计时后会每秒钟调用一次方法
_activeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(activeCountDownAction) userInfo:nil repeats:YES];
[_activeTimer fire];
```
给时分秒字符串通过递减过后的秒数,重新计算数值,并输出显示:
```
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
```
NSTimer-活动倒计时测试效果如下:
![NSTimer-活动倒计时.gif](https://github.com/ZLFighting/ZLCountdownDemo/blob/master/ZLCountdownDemo-活动倒计时两种方式(NSTimer%2C%20GCD)/NSTimer.gif)

##二. 使用GCD来倒计时

**主要步骤:**
Step1. 计算截止时间与当前时间差
Step2. 用GCD倒计时 给时分秒字符串通过递减过后的秒数,重新计算数值,并输出显示, 递减时间差 倒计时-1

Step1. 计算截止时间与当前时间差:
```
// 倒计时的时间 测试数据
NSString *deadlineStr = @"2017-08-19 12:00:00";
// 当前时间的时间戳
NSString *nowStr = [self getCurrentTimeyyyymmdd];
// 计算时间差值
NSInteger secondsCountDown = [self getDateDifferenceWithNowDateStr:nowStr deadlineStr:deadlineStr];
```
Step2.使用GCD来实现倒计时
用GCD这个写有一个好处，跳页不会清零 跳页清零会出现倒计时错误的
活动结束等逻辑及界面处理可以按照自己需求来~
```
__weak __typeof(self) weakSelf = self;

if (_timer == nil) {
__block NSInteger timeout = secondsCountDown; // 倒计时时间

if (timeout!=0) {
dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
_timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC,  0); //每秒执行
dispatch_source_set_event_handler(_timer, ^{
if(timeout <= 0){ //  当倒计时结束时做需要的操作: 关闭 活动到期不能提交
dispatch_source_cancel(_timer);
_timer = nil;
dispatch_async(dispatch_get_main_queue(), ^{
weakSelf.timeLabel.text = @"当前活动已结束";
});
} else { // 倒计时重新计算 时/分/秒
NSInteger days = (int)(timeout/(3600*24));
NSInteger hours = (int)((timeout-days*24*3600)/3600);
NSInteger minute = (int)(timeout-days*24*3600-hours*3600)/60;
NSInteger second = timeout - days*24*3600 - hours*3600 - minute*60;
NSString *strTime = [NSString stringWithFormat:@"活动倒计时 %02ld : %02ld : %02ld", hours, minute, second];
dispatch_async(dispatch_get_main_queue(), ^{
if (days == 0) {
weakSelf.timeLabel.text = strTime;
} else {
weakSelf.timeLabel.text = [NSString stringWithFormat:@"使用GCD来实现活动倒计时            %ld天 %02ld : %02ld : %02ld", days, hours, minute, second];
}

});
timeout--; // 递减 倒计时-1(总时间以秒来计算)
}
});
dispatch_resume(_timer);
}
}
```
GCD-活动倒计时测试效果如下:
![GCD.gif](https://github.com/ZLFighting/ZLCountdownDemo/blob/master/ZLCountdownDemo-活动倒计时两种方式(NSTimer%2C%20GCD)/GCD.gif)


思路详情请移步技术文章:[iOS活动倒计时的两种实现方式](http://blog.csdn.net/smilezhangli/article/details/78548383)

您的支持是作为程序媛的我最大的动力, 如果觉得对你有帮助请送个Star吧,谢谢啦
