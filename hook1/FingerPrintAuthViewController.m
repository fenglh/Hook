//
//  FingerPrintAuthViewController.m
//  hook1
//
//  Created by 冯立海 on 16/8/23.
//
//

#import "FingerPrintAuthViewController.h"
#import "CircleView.h"
#import "NSString+Extension.h"
#import "SpreadButtonManager.h"
#import "UIColor+CustomColors.h"
@interface FingerPrintAuthViewController ()
@property(nonatomic, strong)CircleView *circleViewImage;
@property(nonatomic, strong)CircleView *circleViewLabel;
@property(nonatomic, strong)UIButton *tapButton;
@property(nonatomic, strong)UISlider *slider;
@end
@implementation FingerPrintAuthViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor customYellowColor];
    
    
    CGFloat rate = [SpreadButtonManager sharedInstance].authTimeLeftSecond/3600.0;

    //图片圆圈
    self.circleViewImage = [[CircleView alloc] initWithFrame:CGRectMake(0, 0, 160, 160)];
    self.circleViewImage.lineColor = [UIColor customBlueColor];
    self.circleViewImage.cirCleType = CirCleTypeImage;
    [self.view addSubview:self.circleViewImage];
    //label圆圈
    self.circleViewLabel = [[CircleView alloc] initWithFrame:CGRectMake(0, 0, 160, 160)];
    self.circleViewLabel.lineColor = [UIColor customGreenColor];
    [self.view addSubview:self.circleViewLabel];
    __weak typeof(self) weakSelf = self;
    [self.circleViewLabel setCompletionLabelBlock:^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            NSLog(@"label倒计时完成");
            if (!CGPointEqualToPoint(CGPointMake(CGRectGetWidth(self.view.bounds)/2, CGRectGetHeight(self.view.bounds)/2), weakSelf.circleViewImage.center)) {
                [weakSelf beginAnimationWithRate:0.0];
            }
        }
    }];
    
    //按钮
    self.tapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.tapButton setFrame:CGRectMake(20, CGRectGetHeight(self.view.bounds)/2 + 160, CGRectGetWidth(self.view.bounds) - 20 *2, 44)];
    self.tapButton.layer.cornerRadius = 22.0f;
    [self.tapButton addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.tapButton];
    
    //slider
    self.slider = [[UISlider alloc] init];
    self.slider.minimumValue = 0.0f;
    self.slider.maximumValue = 1.0f;
    self.slider.tintColor = [UIColor customGreenColor];
    self.slider.translatesAutoresizingMaskIntoConstraints = NO;
    [self.slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.slider];
    
    if (rate != 0) {
        
        //设置imageCircle右上角，并缩小一倍
        self.circleViewImage.center = CGPointMake(self.view.bounds.size.width - self.view.bounds.size.width/2/2, self.view.bounds.size.height/2/2);
        self.circleViewImage.transform = CGAffineTransformScale(self.circleViewImage.transform, 0.5, 0.5);
        [self.circleViewImage setCircleStrokeEndWithStrokeEnd:0.0 circleAnimated:YES];
        //设置labelCircle居中
        self.circleViewLabel.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
        [self.circleViewLabel setCircleStrokeEndWithStrokeEnd:rate circleAnimated:YES];
        //按钮
        self.tapButton.tag = 1;
        [self.tapButton setTitle:@"已开启" forState:UIControlStateNormal];
        self.tapButton.backgroundColor = self.circleViewLabel.lineColor;
        //slider
        self.slider.frame = CGRectMake(20, CGRectGetHeight(self.view.bounds)/2 + 160/2 +20, CGRectGetWidth(self.view.bounds)-20*2, 44);
        self.slider.value = rate;
        
    }else{
        //设置circleViewLabel左上角，并缩小一倍
        self.circleViewLabel.center = CGPointMake(self.view.bounds.size.width/2/2, self.view.bounds.size.height/2/2);
        self.circleViewLabel.transform = CGAffineTransformScale(self.circleViewLabel.transform, 0.5, 0.5);
        //设置circleViewImage居中
        self.circleViewImage.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
        [self.circleViewImage setCircleStrokeEndWithStrokeEnd:1.0 circleAnimated:YES];
        //按钮
        self.tapButton.tag = 0;
        [self.tapButton setTitle:@"已关闭" forState:UIControlStateNormal];
        self.tapButton.backgroundColor = self.circleViewImage.lineColor;
        //slider
        self.slider.frame = CGRectMake(-CGRectGetWidth(self.view.bounds)-20*2, CGRectGetHeight(self.view.bounds)/2 + 160/2 +20, CGRectGetWidth(self.view.bounds)-20*2, 44);
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.circleViewLabel dismissAnimation];
}


- (void)hideSliderAnimationWithRate:(CGFloat)rate
{
    self.slider.value = rate;
    POPSpringAnimation *sliderPositionAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    sliderPositionAnim.toValue = @(-CGRectGetWidth(self.view.bounds));
    sliderPositionAnim.springSpeed = 5.0f;
    sliderPositionAnim.springBounciness = 10.0f;
    [self.slider pop_addAnimation:sliderPositionAnim forKey:@"SliderPositionAnim"];
}
- (void)showSliderAnimationWithRate:(CGFloat)rate
{
    self.slider.value = rate;
    POPSpringAnimation *sliderPositionAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    sliderPositionAnim.toValue = @(CGRectGetWidth(self.view.bounds)/2);
    sliderPositionAnim.springSpeed = 5.0f;
    sliderPositionAnim.springBounciness = 10.0f;
    [self.slider pop_addAnimation:sliderPositionAnim forKey:@"SliderPositionAnim"];
    
}
- (void)sliderChanged:(UISlider *)slider
{
    [self.circleViewLabel setCircleStrokeEndWithStrokeEnd:slider.value circleAnimated:YES labelAnimated:NO];
    [self buttonAnimationWithTitle:@"点击开始" backgroundColor:[UIColor customRedColor] tag:2];
}

- (void)beginAnimationWithRate:(CGFloat)rate
{
    BOOL imageIsCenter;
    if (CGPointEqualToPoint(CGPointMake(CGRectGetWidth(self.view.bounds)/2, CGRectGetHeight(self.view.bounds)/2), self.circleViewImage.center)) {
        imageIsCenter = YES;
    }else{
        imageIsCenter = NO;
    }
    
    POPBasicAnimation *imageCircleCenterAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    POPBasicAnimation *labelCircleCenterAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    POPSpringAnimation *imageCircleScaleAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    POPSpringAnimation *labelCircleScaleAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    
    if (imageIsCenter) {//开启
        //位移变换
        imageCircleCenterAnim.toValue = [NSValue valueWithCGPoint:CGPointMake(self.view.bounds.size.width - self.view.bounds.size.width/2/2, self.view.bounds.size.height/2/2)];
        labelCircleCenterAnim.toValue = [NSValue valueWithCGPoint:CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2)];
        
        //大小变化
        imageCircleScaleAnim.toValue = [NSValue valueWithCGPoint:CGPointMake(0.5, 0.5)];
        labelCircleScaleAnim.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
    }else{//关闭
        //位移变换
        imageCircleCenterAnim.toValue = [NSValue valueWithCGPoint:CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2)];
        labelCircleCenterAnim.toValue = [NSValue valueWithCGPoint:CGPointMake(self.view.bounds.size.width/2/2, self.view.bounds.size.height/2/2)];
        
        //大小变化
        imageCircleScaleAnim.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
        labelCircleScaleAnim.toValue = [NSValue valueWithCGPoint:CGPointMake(0.5, 0.5)];
    }
    
    imageCircleScaleAnim.springSpeed = 12.0f;
    labelCircleScaleAnim.springSpeed = 12.0f;
    imageCircleScaleAnim.springBounciness = 20.0f;
    labelCircleScaleAnim.springBounciness = 20.0f;
    imageCircleScaleAnim.velocity = [NSValue valueWithCGPoint:CGPointMake(5, 5)];
    labelCircleScaleAnim.velocity = [NSValue valueWithCGPoint:CGPointMake(5, 5)];
    imageCircleCenterAnim.duration = 0.4f;
    labelCircleCenterAnim.duration = 0.4f;
    
    
    
    if (imageIsCenter) {//开启
        [imageCircleCenterAnim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
            if (finished) {
                [self.circleViewImage setCircleStrokeEndWithStrokeEnd:0.0 circleAnimated:YES];
            }
        }];
        [labelCircleCenterAnim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
            if (finished) {
                if (rate>0) {
                    [self.circleViewLabel setCircleStrokeEndWithStrokeEnd:rate circleAnimated:YES];
                }
                [self showSliderAnimationWithRate:rate];
            }
        }];
        
    }else{//关闭
        [labelCircleCenterAnim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
            if (finished) {
                if (rate>0) {
                    [self.circleViewLabel setCircleStrokeEndWithStrokeEnd:0.0 circleAnimated:YES];
                }
                
                [self hideSliderAnimationWithRate:0.0];
            }
        }];
        
        [imageCircleCenterAnim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
            if (finished) {
                [self.circleViewImage setCircleStrokeEndWithStrokeEnd:1.0 circleAnimated:YES];
            }
        }];
    }
    [self.circleViewImage pop_addAnimation:imageCircleScaleAnim forKey:@"ImageCircleScaleAnim"];
    [self.circleViewLabel pop_addAnimation:labelCircleScaleAnim forKey:@"LabelCircleScaleAnim"];
    [self.circleViewImage pop_addAnimation:imageCircleCenterAnim forKey:@"ImageCircleCenterAnim"];
    [self.circleViewLabel pop_addAnimation:labelCircleCenterAnim forKey:@"LabelCircleCenterAnim"];
    
    NSString *title = nil;
    UIColor *bgColor = nil;
    NSUInteger tag = 0;
    if (!imageIsCenter) {
        title = @"已关闭";
        bgColor = self.circleViewImage.lineColor;
        tag = 0;
    }else{
        title = @"已开启";
        bgColor = self.circleViewLabel.lineColor;
        tag = 1;
    }
    [self buttonAnimationWithTitle:title backgroundColor:bgColor tag:tag];
}

- (void)buttonAnimationWithTitle:(NSString *)title backgroundColor:(UIColor *)bgColor
{
    [self buttonAnimationWithTitle:title backgroundColor:bgColor tag:0];
}
- (void)buttonAnimationWithTitle:(NSString *)title backgroundColor:(UIColor *)bgColor tag:(NSUInteger)tag
{
    self.tapButton.tag = tag;
    CGFloat minWidth = [self.tapButton.titleLabel.text sizeWithFont:self.tapButton.titleLabel.font maxSize:CGSizeMake(CGRectGetWidth(self.view.bounds)-20 *2, self.tapButton.frame.size.height)].width + 10;
    //按钮缩小动画
    POPBasicAnimation *buttonSizeSmallAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewSize];
    buttonSizeSmallAnim.duration = 0.4f;
    buttonSizeSmallAnim.toValue = [NSValue valueWithCGPoint:CGPointMake(minWidth, self.tapButton.frame.size.height)];
    [buttonSizeSmallAnim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            [self.tapButton setTitle:title forState:UIControlStateNormal];
            //放大动画
            POPBasicAnimation *buttonSizeLargeAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewSize];
            buttonSizeLargeAnim.duration = 0.4f;
            buttonSizeLargeAnim.toValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetWidth(self.view.bounds) - 20 *2, self.tapButton.frame.size.height)];
            [self.tapButton pop_addAnimation:buttonSizeLargeAnim forKey:@"ButtonSizeLargeAnim"];
            
            //背景颜色变化动画
            POPBasicAnimation *buttonBackgroundColorAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewBackgroundColor];
            buttonBackgroundColorAnim.toValue = bgColor;
            [self.tapButton pop_addAnimation:buttonBackgroundColorAnim forKey:@"ButtonBackgroundColorAnim"];
        }
    }];
    [self.tapButton pop_addAnimation:buttonSizeSmallAnim forKey:@"ButtonSizeSmallAnim"];
}

- (void)buttonTap:(UIButton *)button
{
    if (self.tapButton.tag == 2) {
        [self.circleViewLabel labelAnimationWithRate:self.slider.value];
        [self buttonAnimationWithTitle:@"已开启" backgroundColor:self.circleViewLabel.lineColor tag:1];
        double timeLeftSeconds = self.slider.value * self.circleViewLabel.maxSecond;
        NSLog(@"当前剩余时间%fs",timeLeftSeconds);
        [[SpreadButtonManager sharedInstance] setAuthValidTime:timeLeftSeconds];
    }else{
        [self beginAnimationWithRate:self.slider.value];
    }
    
    
}


@end
