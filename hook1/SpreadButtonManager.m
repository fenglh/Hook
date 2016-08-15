//
//  SpreadButtonManager.m
//  FloatWindowDemo
//
//  Created by fenglh on 16/7/25.
//  Copyright © 2016年 xiaoxigame. All rights reserved.
//

#import "SpreadButtonManager.h"
#import "ZYSpreadButton.h"
#import "ZYSpreadSubButton.h"
#import "BMFingerprintBindViewController.h"

@interface SpreadButtonManager ()
@property (nonatomic, strong)ZYSpreadButton *spreadButton;
@property (nonatomic,readwrite, assign) BOOL isShowing;
@property (nonatomic,readwrite, assign) BOOL isWXLocking;
@property (nonatomic, strong) BMFingerprintBindViewController *fingerVC;
@end
@implementation SpreadButtonManager


+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static SpreadButtonManager *instanced=nil;
    dispatch_once(&once, ^{
        instanced = [[SpreadButtonManager alloc] init];
        [instanced configureUI];
    });
    return instanced;
}




- (void)configureUI
{
    __weak typeof(self) weakSelf = self;

    ZYSpreadSubButton *subButton5 = [[ZYSpreadSubButton alloc] initWithBackgroundImage:[UIImage imageNamed:@"clock.png"] highlightImage:nil clickedBlock:^(int index, UIButton *sender) {
        NSLog(@"第%d个按钮被被点击！",index);
        
         weakSelf.fingerVC = [[BMFingerprintBindViewController alloc] init];
        UIViewController *topViewController = [weakSelf topViewController];
        if ([topViewController isKindOfClass:[UINavigationController class]]) {
            [(UINavigationController *)topViewController pushViewController:weakSelf.fingerVC animated:YES];
        }else{
            [topViewController presentViewController:weakSelf.fingerVC animated:YES completion:nil];
        }
    }];
    
    self.spreadButton = [[ZYSpreadButton alloc] initWithBackgroundImage:[UIImage imageNamed:@"add"] highlightImage:[UIImage imageNamed:@"add"] position:CGPointMake(40,[[UIScreen mainScreen] bounds].size.height - 100)];
    [self.spreadButton setSubButtons:@[subButton5]];
    NSLog(@"初始化时候的自按钮列表:%@", self.spreadButton.subButtons);
    self.spreadButton.mode = SpreadModeSickleSpread;
    self.spreadButton.direction = SpreadDirectionRightUp;
    self.spreadButton.radius = 120;
    self.spreadButton.positionMode = SpreadPositionModeFixed;
}

- (BOOL)isWXLocking
{
    return self.fingerVC.isLocking;
}


- (void)show
{
    if (!self.isShowing) {
        [[self topViewController].view addSubview:self.spreadButton];
        self.isShowing = YES;
    }

}

- (void)hide
{
    if (self.isShowing) {
        [self.spreadButton removeFromSuperview];
        self.isShowing = NO;
    }

}


- (UIViewController *)topViewController {
    
    UIViewController *rootViewController = ((UIWindow *)[[[UIApplication sharedApplication] windows] objectAtIndex:0]).rootViewController;
    UIViewController *topViewController = rootViewController;
    while (topViewController.presentedViewController) {
        topViewController = rootViewController.presentedViewController;
    }
    if ([topViewController isKindOfClass:[UINavigationController class]]) {
        topViewController = [((UINavigationController *)topViewController).viewControllers lastObject];
    }
    return topViewController;
}

@end
