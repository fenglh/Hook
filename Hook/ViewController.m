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
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setBackgroundColor:[UIColor redColor]];
    [button setTitle:@"点击我" forState:UIControlStateNormal];
    button.frame = CGRectMake(100, 100, 160, 44);
    [self.view addSubview:button];

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
