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
#import "FlatButton.h"
@interface FingerPrintAuthViewController ()
@property(nonatomic, strong)CircleView *circleViewImage;
@property(nonatomic, strong)CircleView *circleViewLabel;
@property(nonatomic, strong)FlatButton *tapButton;
@property(nonatomic, strong)UISlider *slider;
@property (nonatomic) UILabel *errorLabel;
@end
@implementation FingerPrintAuthViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor customYellowColor];
    
    
    CGFloat rate = [SpreadButtonManager sharedInstance].authTimeLeftSecond/3600.0;
    [self addImageCircle];
    [self addLabelCircle];
    [self addSlider];
    [self addTapButton];
    [self addErrorLabel];
    if (rate != 0) {
        //设置imageCircle右上角，并缩小一倍
        self.circleViewImage.center = CGPointMake(self.view.bounds.size.width - self.view.bounds.size.width/2/2, self.view.bounds.size.height/2/2);
        self.circleViewImage.transform = CGAffineTransformScale(self.circleViewImage.transform, 0.5, 0.5);
        [self.circleViewImage animationWithStrokeEnd:0.0 labelAutoCountDownAnimation:YES];
        //设置labelCircle居中
        self.circleViewLabel.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
        [self.circleViewLabel animationWithStrokeEnd:rate labelAutoCountDownAnimation:YES];
        [self.circleViewLabel setLabelTimeWithTimeLeft:rate * self.circleViewLabel.maxSecond];
        //按钮
        self.tapButton.tag = 1;
        [self.tapButton setTitle:@"已开启" forState:UIControlStateNormal];
        self.tapButton.backgroundColor = self.circleViewLabel.lineColor;
        //slider
        [self showSliderAnimationWithRate:rate];
        
    }else{
        //设置circleViewLabel左上角，并缩小一倍
        self.circleViewLabel.center = CGPointMake(self.view.bounds.size.width/2/2, self.view.bounds.size.height/2/2);
        self.circleViewLabel.transform = CGAffineTransformScale(self.circleViewLabel.transform, 0.5, 0.5);
        //设置circleViewImage居中
        self.circleViewImage.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
        [self.circleViewImage animationWithStrokeEnd:1.0 labelAutoCountDownAnimation:NO];
        //按钮
        self.tapButton.tag = 0;
        [self.tapButton setTitle:@"已关闭" forState:UIControlStateNormal];
        self.tapButton.backgroundColor = self.circleViewImage.lineColor;
        
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
    [sliderPositionAnim setCompletionBlock:^(POPAnimation *anim, BOOL finished ) {
        
        
        CGFloat fromX = (CGRectGetWidth(self.view.bounds)-20*2) * rate;
        CGPoint fromPoint = CGPointMake(fromX, -44);
        CGPoint toPoint = CGPointMake(fromX, self.slider.frame.origin.y);
        [self showBubbleAnimationFromPosition:fromPoint toPoint:toPoint];
    }];
    [self.slider pop_addAnimation:sliderPositionAnim forKey:@"SliderPositionAnim"];
}

- (void)showBubbleAnimationFromPosition:(CGPoint)fromPoint toPoint:(CGPoint)toPoint
{
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor customGreenColor];
    label.frame = CGRectMake(fromPoint.x, fromPoint.y, 44, 44);
    [self.view addSubview:label];
    POPSpringAnimation *springAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
    springAnim.springBounciness = 10;
    springAnim.fromValue = [NSValue valueWithCGPoint:fromPoint];
    springAnim.toValue = [NSValue valueWithCGPoint:toPoint];
    [label.layer pop_addAnimation:springAnim forKey:@"SpringAnim"];
}

- (void)sliderChanged:(UISlider *)slider
{
    [self.circleViewLabel animationWithStrokeEnd:slider.value labelAutoCountDownAnimation:NO];
    [self buttonAnimationToClickOpen];
}
//交换
- (BOOL)exchangeAnimationWithRate:(CGFloat)rate
{
    BOOL imageIsCenter = NO;
    if (CGPointEqualToPoint(CGPointMake(CGRectGetWidth(self.view.bounds)/2, CGRectGetHeight(self.view.bounds)/2), self.circleViewImage.center)) {
        imageIsCenter = YES;
    }
    //设置位移和缩放动画
    POPBasicAnimation *imageCircleCenterAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    POPBasicAnimation *labelCircleCenterAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    POPSpringAnimation *imageCircleScaleAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    POPSpringAnimation *labelCircleScaleAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    
    
    CGFloat springSpeed = 12.f;//速度
    CGFloat springBounciness =20.0f;//弹力
    CGFloat duration = 0.4;//动画时间
    CGPoint velocity = CGPointMake(5, 5);
    CGPoint scaleSmall = CGPointMake(0.5, 0.5);
    CGPoint scaleLarge = CGPointMake(1, 1);
    CGPoint leftUpPosition = CGPointMake(self.view.bounds.size.width/2/2, self.view.bounds.size.height/2/2);
    CGPoint rightUpPosition = CGPointMake(self.view.bounds.size.width - self.view.bounds.size.width/2/2, self.view.bounds.size.height/2/2);
    CGPoint centerPosition = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    
    imageCircleScaleAnim.springSpeed = springSpeed;
    imageCircleScaleAnim.springBounciness = springBounciness;
    imageCircleScaleAnim.velocity = [NSValue valueWithCGPoint:velocity];
    imageCircleCenterAnim.duration = duration;
    
    labelCircleScaleAnim.springSpeed = springSpeed;
    labelCircleScaleAnim.springBounciness = springBounciness;
    labelCircleScaleAnim.velocity = [NSValue valueWithCGPoint:velocity];
    labelCircleCenterAnim.duration = duration;
    
    if (imageIsCenter) {//开启
        //image移动到右上角，并缩小
        imageCircleCenterAnim.toValue = [NSValue valueWithCGPoint:rightUpPosition];
        imageCircleScaleAnim.toValue = [NSValue valueWithCGPoint:scaleSmall];
        //label移动到中心，并放大
        labelCircleCenterAnim.toValue = [NSValue valueWithCGPoint:centerPosition];
        labelCircleScaleAnim.toValue = [NSValue valueWithCGPoint:scaleLarge];
        //设置画圈动画
        [imageCircleCenterAnim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
            if (finished) {
                [self.circleViewImage animationWithStrokeEnd:0.0 labelAutoCountDownAnimation:YES];
            }
        }];
        [labelCircleCenterAnim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
            if (finished) {
                [self.circleViewLabel animationWithStrokeEnd:rate labelAutoCountDownAnimation:NO];
                [self buttonAnimationToClickOpen];
            }
        }];
    }else{//关闭
        
        //image移动到中心，并放大
        imageCircleCenterAnim.toValue = [NSValue valueWithCGPoint:centerPosition];
        imageCircleScaleAnim.toValue = [NSValue valueWithCGPoint:scaleLarge];
        //label移动到左上角，并缩小
        labelCircleCenterAnim.toValue = [NSValue valueWithCGPoint:leftUpPosition];
        labelCircleScaleAnim.toValue = [NSValue valueWithCGPoint:scaleSmall];
        //画圆圈动画
        [labelCircleCenterAnim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
            if (finished) {
                [self.circleViewLabel animationWithStrokeEnd:0.0 labelAutoCountDownAnimation:YES];
            }
        }];
        [imageCircleCenterAnim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
            if (finished) {
                [self.circleViewImage animationWithStrokeEnd:1.0 labelAutoCountDownAnimation:YES];
            }
        }];
    }
    

    [self.circleViewImage pop_addAnimation:imageCircleScaleAnim forKey:@"ImageCircleScaleAnim"];
    [self.circleViewLabel pop_addAnimation:labelCircleScaleAnim forKey:@"LabelCircleScaleAnim"];
    [self.circleViewImage pop_addAnimation:imageCircleCenterAnim forKey:@"ImageCircleCenterAnim"];
    [self.circleViewLabel pop_addAnimation:labelCircleCenterAnim forKey:@"LabelCircleCenterAnim"];
    return imageIsCenter;
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
                [self.circleViewImage animationWithStrokeEnd:0.0 labelAutoCountDownAnimation:YES];
            }
        }];
        [labelCircleCenterAnim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
            if (finished) {
                if (rate>0) {
                    [self.circleViewLabel animationWithStrokeEnd:rate labelAutoCountDownAnimation:YES];
                }else{
                    [self buttonAnimationToOpened];
                }
                [self showSliderAnimationWithRate:rate];
            }
        }];
        
    }else{//关闭
        [labelCircleCenterAnim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
            if (finished) {
                if (rate>0) {
                    [self.circleViewLabel animationWithStrokeEnd:0.0 labelAutoCountDownAnimation:YES];
                }
                
                [self hideSliderAnimationWithRate:0.0];
            }
        }];
        
        [imageCircleCenterAnim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
            if (finished) {
                [self.circleViewImage animationWithStrokeEnd:1.0 labelAutoCountDownAnimation:YES];
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


- (void)buttonAnimationToClosed
{
    [self buttonAnimationWithTitle:@"已关闭" backgroundColor:[UIColor customBlueColor] tag:0];
}
- (void)buttonAnimationToOpened
{
    [self buttonAnimationWithTitle:@"已开启" backgroundColor:[UIColor customGreenColor] tag:1];
}
- (void)buttonAnimationToClickOpen
{
    [self buttonAnimationWithTitle:@"点我开启" backgroundColor:[UIColor customRedColor] tag:2];
}

//设置按钮动画
- (void)buttonAnimationWithTitle:(NSString *)title backgroundColor:(UIColor *)bgColor tag:(NSUInteger)tag
{
    self.tapButton.tag = tag;
    CGFloat minWidth = [self.tapButton.titleLabel.text sizeWithFont:self.tapButton.titleLabel.font maxSize:CGSizeMake(CGRectGetWidth(self.view.bounds)-20 *2, self.tapButton.frame.size.height)].width + 60;
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

//按钮点击事件
- (void)buttonTap:(UIButton *)button
{
    [self hideErrorLabel:^(POPAnimation *anim, BOOL finished) {
        if (button.tag !=  2) {
            BOOL imageIsCenter = [self exchangeAnimationWithRate:0.5];
            imageIsCenter?[self showSliderAnimationWithRate:0.5]:[self hideSliderAnimationWithRate:0];
            imageIsCenter?[self buttonAnimationToOpened]:[self buttonAnimationToClosed];
            if (button.tag == 1) {
                [[SpreadButtonManager sharedInstance] setAuthValidTime:0];
            }
        }else{
            if (self.slider.value == 0) {
                [self showErrorLabel];
                return;
            }
            [self.circleViewLabel labelCountDownAnimationWithRate:self.slider.value];
            [self buttonAnimationToOpened];
            [[SpreadButtonManager sharedInstance] setAuthValidTime:self.slider.value * self.circleViewLabel.maxSecond];
        }
    }];
    
}

- (void)addErrorLabel
{
    NSString *tips = @"请选择锁定时间.";
    UIFont *font = [UIFont fontWithName:@"Avenir-Light" size:18];
    CGSize size = [tips sizeWithFont:font maxSize:CGSizeMake(CGRectGetWidth(self.view.bounds), 44)];
    self.errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    self.errorLabel.center = self.tapButton.center;
    self.errorLabel.font = font;
    self.errorLabel.textColor = [UIColor customRedColor];
    self.errorLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.errorLabel.text = tips;
    self.errorLabel.textAlignment = NSTextAlignmentCenter;
    [self.view insertSubview:self.errorLabel belowSubview:self.tapButton];
    self.errorLabel.layer.opacity = 0.0;
}

- (void)showErrorLabel
{
    self.errorLabel.layer.opacity = 1.0;
    POPSpringAnimation *layerScaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    layerScaleAnimation.springBounciness = 18;
    layerScaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    [self.errorLabel.layer pop_addAnimation:layerScaleAnimation forKey:@"labelScaleAnimation"];
    
    POPSpringAnimation *layerPositionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    layerPositionAnimation.toValue = @(self.tapButton.center.y + CGRectGetHeight(self.tapButton.bounds));
    layerPositionAnimation.springBounciness = 12;
    [self.errorLabel.layer pop_addAnimation:layerPositionAnimation forKey:@"layerPositionAnimation"];
}

- (void)hideErrorLabel:(void (^)(POPAnimation *anim, BOOL finished))completionBlock
{
    POPBasicAnimation *layerScaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    layerScaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(0.5f, 0.5f)];
    [self.errorLabel.layer pop_addAnimation:layerScaleAnimation forKey:@"layerScaleAnimation"];
    
    POPBasicAnimation *layerPositionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    layerPositionAnimation.toValue = @(self.tapButton.center.y);
    [self.errorLabel.layer pop_addAnimation:layerPositionAnimation forKey:@"layerPositionAnimation"];
    [layerPositionAnimation setCompletionBlock:completionBlock];
}

- (void)shakeButton:(UIButton *)button
{
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    positionAnimation.velocity = @2000;
    positionAnimation.springBounciness = 20;
    [positionAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
        button.userInteractionEnabled = YES;
    }];
    [button.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
}

- (void)addImageCircle
{
    //图片圆圈
    self.circleViewImage = [[CircleView alloc] initWithFrame:CGRectMake(0, 0, 160, 160)];
    self.circleViewImage.lineColor = [UIColor customBlueColor];
    self.circleViewImage.cirCleType = CirCleTypeImage;
    [self.view addSubview:self.circleViewImage];
}

- (void)addLabelCircle
{
    //label圆圈
    self.circleViewLabel = [[CircleView alloc] initWithFrame:CGRectMake(0, 0, 160, 160)];
    self.circleViewLabel.lineColor = [UIColor customGreenColor];
    [self.view addSubview:self.circleViewLabel];
}

- (void)addTapButton
{
    //按钮
    self.tapButton = [FlatButton buttonWithType:UIButtonTypeCustom];
    [self.tapButton setFrame:CGRectMake(20, CGRectGetHeight(self.view.bounds)/2 + 160, CGRectGetWidth(self.view.bounds) - 20 *2, 44)];
    self.tapButton.layer.cornerRadius = 22.0f;
    [self.tapButton addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.tapButton];
}

- (void)addSlider
{
    //slider
    self.slider = [[UISlider alloc] init];
    self.slider.minimumValue = 0.0f;
    self.slider.maximumValue = 1.0f;
    self.slider.tintColor = [UIColor customGreenColor];
    self.slider.translatesAutoresizingMaskIntoConstraints = NO;
    [self.slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    self.slider.frame = CGRectMake(-CGRectGetWidth(self.view.bounds)-20*2, CGRectGetHeight(self.view.bounds)/2 + 160/2 +20, CGRectGetWidth(self.view.bounds)-20*2, 44);
    self.slider.layer.opacity = 0;
    [self.view addSubview:self.slider];
}

@end
