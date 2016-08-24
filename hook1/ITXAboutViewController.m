//
//  ITXAboutViewController.m
//  hook1
//
//  Created by 冯立海 on 16/8/16.
//
//

#import "ITXAboutViewController.h"
#import "NSString+Extension.h"
#import "UIColor+CustomColors.h"
#import "FoldingView.h"

#define Padding 10

@interface ITXAboutViewController ()
@property (nonatomic, strong) NSArray <UILabel *> *labels;
@property (nonatomic, strong) NSArray <UILabel *> *labelsAuthor;
@property(nonatomic) FoldingView *foldView;
@end

@implementation ITXAboutViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.autoresizesSubviews = NO;

    [self addFoldView];
    //免责声明
    NSString *content = @"软件仅供技术交流，请勿用于商业及非法用途，如产生法律纠纷与本人无关!";
    CGFloat offsetY = self.foldView.frame.origin.y + self.foldView.frame.size.height+20;
    self.labels = [self labelsWithString:content offsetY:offsetY];
    [self flyInAnimWithLabels:self.labels index:0];
}

- (void)addFoldView
{
    CGFloat width = CGRectGetWidth(self.view.bounds) - Padding * 2;
    CGRect frame = CGRectMake(10, 80, width, width);
    
    self.foldView = [[FoldingView alloc] initWithFrame:frame
                                                 image:[UIImage imageNamed:@"eyu.jpeg"]];
    [self.view addSubview:self.foldView];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self resetAnim];
}

- (void)resetAnim
{
    for (UILabel *label in self.labels) {
        [label.layer pop_removeAllAnimations];
    }

}

- (void)flyInAnimWithLabels:(NSArray <UILabel *>*)labels index:(NSUInteger)index
{
    UILabel *label = labels[index];
    [self.view addSubview:label];
    //落地弹簧效果
    POPSpringAnimation *springAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    springAnim.springBounciness = 16;
    springAnim.beginTime = CACurrentMediaTime() + 0.5;
    springAnim.fromValue = @0;
    springAnim.toValue = @(-label.frame.origin.y);
    //透明度
    POPBasicAnimation *opacityAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    opacityAnim.duration = 0.5;
    opacityAnim.fromValue = @0;
    opacityAnim.toValue = @1.0;
    [label.layer pop_addAnimation:springAnim forKey:[NSString stringWithFormat:@"SpringAnim%ld",label.tag]];
    [label.layer pop_addAnimation:opacityAnim forKey:[NSString stringWithFormat:@"OpacityAnim%lu",label.tag]];
    __weak typeof(self) weakSelf = self;
    __block NSUInteger blockIndex = index;
    [opacityAnim setAnimationDidStartBlock:^(POPAnimation *anim) {
        if (++blockIndex < labels.count) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.08f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf flyInAnimWithLabels:labels index:blockIndex];
            });
        }
        
    }];
    
    
}



- (NSArray <UILabel *>*)labelsWithString:(NSString *)string offsetY:(CGFloat)offsetY
{
    NSMutableArray *labels = [NSMutableArray array];
    CGFloat totalWidth = 0;
    CGFloat nextCharWidth=0;
    NSUInteger lineNumber = 1;
    for (int i = 0; i<string.length; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont fontWithName:@"Avenir-Light" size:16];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor customGrayColor];
        NSString *oneChar = [string substringWithRange:NSMakeRange(i, 1)];
        label.text = oneChar;
        //计算字符宽度
        CGFloat maxWidth = self.view.frame.size.width-Padding * 2;
        CGSize size =  [oneChar sizeWithFont:label.font maxSize:CGSizeMake(maxWidth, self.view.frame.size.height)];
        nextCharWidth = size.width;
        totalWidth = totalWidth + nextCharWidth;
        if (totalWidth > maxWidth) {
            lineNumber++;
            totalWidth=nextCharWidth;
        }
        CGFloat x = 10 + totalWidth - nextCharWidth;
        CGFloat y = offsetY + lineNumber *size.height;
        label.frame = CGRectMake(x,-y, size.width, size.height);
        [labels addObject:label];
    }
    return labels;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
