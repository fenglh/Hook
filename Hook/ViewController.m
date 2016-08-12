//
//  ViewController.m
//  Hook
//
//  Created by 冯立海 on 16/8/12.
//
//

#import "ViewController.h"
#import "SpreadButtonManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //开启悬浮按钮
    [[SpreadButtonManager sharedInstance] show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
