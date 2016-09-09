//
//  ITXBaseViewController.m
//  hook1
//
//  Created by 冯立海 on 16/8/16.
//
//

#import "ITXBaseViewController.h"
#import "UIColor+CustomColors.h"

@interface ITXBaseViewController ()

@end

@implementation ITXBaseViewController

- (void)dealloc
{
    NSLog(@"%@被销毁",[self class]);
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    // 设置CGRectZero从导航栏下开始计算
//    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//    }
    [self configureTitleView];
}
- (void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"%@视图消失",[self class]);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)configureTitleView
{
    if (!self.title) {
        return;
    }
    UILabel *headlinelabel = [UILabel new];
    headlinelabel.font = [UIFont fontWithName:@"Avenir-Light" size:20];
    headlinelabel.textAlignment = NSTextAlignmentCenter;
    headlinelabel.textColor = [UIColor customGrayColor];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.title];
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor customBlueColor]
                             range:NSMakeRange(1, 1)];
    
    headlinelabel.attributedText = attributedString;
    [headlinelabel sizeToFit];
    
    [self.navigationItem setTitleView:headlinelabel];
}

@end
