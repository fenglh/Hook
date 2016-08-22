//
//  BMFingerprintBindViewController.m
//  BlueMoonHouse
//
//  Created by fenglh on 16/3/24.
//  Copyright © 2016年 bluemoon. All rights reserved.
//

#import "BMFingerprintBindViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "UIColor+CustomColors.h"


@interface BMFingerprintBindViewController ()
@property (strong, nonatomic) UISwitch *switchButton;
@property (strong, nonatomic) UILabel *validTimeLabel;
@property (strong, nonatomic) UISlider *timeSlider;

@property (strong, nonatomic) NSArray *numbers;
@property (strong, nonatomic) UIView *timeBgView;
@property (strong ,nonatomic) UILabel *restTimeLabel;
@property (assign, readwrite,nonatomic) BOOL isLocking;//正在锁定

@property (strong, nonatomic) dispatch_source_t timer;
@end

@implementation BMFingerprintBindViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUI];
    [self loadData];
}


- (void)loadData
{
    //初始化开关按钮
    BOOL fingerAuth =[[[NSUserDefaults standardUserDefaults] objectForKey:@"FingerAuth"] boolValue];
    [self.switchButton setOn:fingerAuth animated:YES];
    
    //初始化滑动按钮
    NSInteger preSliderIndex = [[[NSUserDefaults standardUserDefaults] objectForKey:@"FingerAuthSliderIndex"] integerValue];
    self.timeSlider.value = preSliderIndex;
    NSNumber *number = self.numbers[preSliderIndex];
    [self setLabelContent:number];
    
    //初始化时间设置界面
    NSDate *preBeginTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"FingerAuthBeginTime"];
    double validTimeInterval = [preBeginTime timeIntervalSince1970] + [self.numbers[preSliderIndex] integerValue] * 60;
    double nowTimeInterval = [[NSDate date] timeIntervalSince1970];
    double leftTimeInterval = validTimeInterval - nowTimeInterval;
    if (fingerAuth && leftTimeInterval > 0) {
        [self openAuth:YES];
        [self beginCountDown];
        self.isLocking = YES;
        self.timeSlider.enabled = NO;
    }else{
        //关闭或者已过期
        [self openAuth:NO];
    }
    

    
    
}

- (void)beginCountDown
{
    if(self.timer){
        dispatch_source_cancel(self.timer);
    }
    NSInteger preSliderIndex = [[[NSUserDefaults standardUserDefaults] objectForKey:@"FingerAuthSliderIndex"] integerValue];
    NSDate *preBeginTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"FingerAuthBeginTime"];
    double validTimeInterval = [preBeginTime timeIntervalSince1970] + [self.numbers[preSliderIndex] integerValue] * 60;
    double nowTimeInterval = [[NSDate date] timeIntervalSince1970];
    double leftTimeInterval = validTimeInterval - nowTimeInterval;
    __block int timeout=leftTimeInterval; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(self.timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(self.timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(self.timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.restTimeLabel.text = nil;
                [self openAuth:NO];
                
            });
        }else{
            
            NSString *strTime =[self timeFormatted:timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                self.restTimeLabel.text = strTime;
            });
            timeout--;
            
        }
    });
    dispatch_resume(self.timer);
}


- (void)setUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [finishButton setTitle:@"完成" forState:UIControlStateNormal];
    finishButton.titleLabel.font = [UIFont systemFontOfSize:13];
    finishButton.frame = CGRectMake(0, 0, 44, 44);
    [finishButton addTarget:self action:@selector(finishButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:finishButton];
    
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"icon_fingerprint.png"];
    imageView.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width - 60)/2, 80, 60, 60);
    [self.view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor customGrayColor];
    label.font = [UIFont systemFontOfSize:12];
    label.text = @"指纹认证仅对本机有效";
    label.textAlignment = NSTextAlignmentCenter;
    label.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width - 200)/2, imageView.frame.origin.y + imageView.frame.size.height + 20, 200, 44);
    [self.view addSubview:label];
    
    //
    UIView *switchBgView = [[UIView alloc] initWithFrame:CGRectMake(-0.5, label.frame.origin.y + label.frame.size.height + 40, [[UIScreen mainScreen] bounds].size.width+1, 60)];
    switchBgView.layer.borderWidth = 0.5;
//    switchBgView.layer.borderColor = [UIColor redColor].CGColor;
    switchBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:switchBgView];
    //
    UILabel *authLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (switchBgView.frame.size.height -44)/2.0, 80, 44)];
    authLabel.text = @"微信指纹认证";
    authLabel.font = [UIFont systemFontOfSize:12];
    authLabel.textColor = [UIColor customGrayColor];
    [switchBgView addSubview:authLabel];
    
    //滑动按钮
    self.switchButton = [[UISwitch alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 51 -10, (switchBgView.frame.size.height - 31)/2.0, 51, 31)];
    [self.switchButton addTarget:self action:@selector(switchOnTap:) forControlEvents:UIControlEventTouchUpInside];
    [switchBgView addSubview:self.switchButton];
    
    
    //背景视图
    self.timeBgView = [[UIView alloc] initWithFrame:CGRectMake(-0.5, switchBgView.frame.origin.y + label.frame.size.height + 40, [[UIScreen mainScreen] bounds].size.width+1, 96)];
    self.timeBgView.clipsToBounds = YES;
    self.timeBgView.layer.borderWidth = 0.5;
    self.timeBgView.layer.borderColor = [UIColor customGrayColor].CGColor;
    [self.view addSubview:self.timeBgView];
    
    //
    self.validTimeLabel= [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 30)];
    self.validTimeLabel.text = @"设置锁定时间";
    self.validTimeLabel.textColor = [UIColor customGrayColor];
    self.validTimeLabel.font = [UIFont systemFontOfSize:12];
    [self.timeBgView addSubview:self.validTimeLabel];
    
    self.timeSlider = [[UISlider alloc] initWithFrame:CGRectMake(10, (self.timeBgView.frame.size.height - 31.0)/2.0, [[UIScreen mainScreen] bounds].size.width -10 *2 , 31)];
    self.numbers = @[@(1),@(5),@(10),@(30),@(60),@(120),@(180)];
    NSInteger numberOfSteps = (NSInteger)([self.numbers count] -1);
    self.timeSlider.minimumValue = 0;
    self.timeSlider.maximumValue = numberOfSteps;
    self.timeSlider.continuous = YES;
    [self.timeSlider addTarget:self action:@selector(timeSliderValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.timeBgView addSubview:self.timeSlider];
    //剩余时间
    self.restTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.timeBgView.frame.size.height - 30, 200, 30)];
    self.restTimeLabel.textColor = [UIColor customGrayColor];
    self.restTimeLabel.font = [UIFont systemFontOfSize:12];
    [self.timeBgView addSubview:self.restTimeLabel];
    
    
}

- (NSString *)timeFormatted:(int)totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    return [NSString stringWithFormat:@"剩余时间 %02d:%02d:%02d",hours, minutes, seconds];
}


- (void)showtimeConfigure:(BOOL)show
{
    CGFloat height = 0;
    if (show) {
        height = 96;
    }
    
    [UIView animateWithDuration:0.35 animations:^{
        self.timeBgView.frame = CGRectMake(self.timeBgView.frame.origin.x, self.timeBgView.frame.origin.y, self.timeBgView.frame.size.width, height);
    }];
}
- (void)openAuth:(BOOL)open
{
    self.isLocking = open;
    self.timeSlider.enabled = open;
    [self.switchButton setOn:open animated:YES];
    self.timeSlider.enabled = open;
    [self showtimeConfigure:open];
    if(!open && self.timer ){
        dispatch_source_cancel(self.timer);
        self.restTimeLabel.text =nil;
    }
    
}

- (void)saveConfigureWithIndex:(CGFloat)index open:(BOOL)open
{
    
    NSDate *now = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:now forKey:@"FingerAuthBeginTime"];
    [[NSUserDefaults standardUserDefaults] setObject:@(index) forKey:@"FingerAuthSliderIndex"];
    [[NSUserDefaults standardUserDefaults] setObject:@(open) forKey:@"FingerAuth"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)finishButtonClick:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)timeSliderValueChange:(UISlider *)slider
{
    NSUInteger index = (NSUInteger)(slider.value + 0.5);
    [slider setValue:index animated:YES];
    NSNumber *number = self.numbers[index];
    [self setLabelContent:number];
    [self saveConfigureWithIndex:[slider value] open:self.switchButton.isOn];
    [self beginCountDown];
}



- (void)setLabelContent:(NSNumber *)number
{
    if ([number integerValue] >= 60) {
        CGFloat hour = [number integerValue] / 60.0;
        self.validTimeLabel.text = [NSString stringWithFormat:@"锁定时间：%.0f小时",hour];
    }else{
        self.validTimeLabel.text = [NSString stringWithFormat:@"锁定时间：%ld分钟",(long)[number integerValue]];
    }
}

- (void)switchOnTap:(id)sender {
    UISwitch *switchButton = (UISwitch *)sender;
    LAContext *context = [[LAContext alloc] init];
    NSError *authError = nil;
    NSString *localizedReasonString = @"请输入指纹";
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:localizedReasonString reply:^(BOOL success, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) {
                    [self openAuth:switchButton.isOn];
                    [self saveConfigureWithIndex:[self.timeSlider value] open:switchButton.isOn];
                }else{
                    [self openAuth:!switchButton.isOn];

                }
            });

        }];
    }
}

@end
