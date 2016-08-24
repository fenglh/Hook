//
//  FingerPrintAuthViewController.m
//  hook1
//
//  Created by 冯立海 on 16/8/23.
//
//

#import "FingerPrintAuthViewController.h"
#import "CircleView.h"

@interface FingerPrintAuthViewController ()
@property(nonatomic, strong)CircleView *circleViewImage;
@property(nonatomic, strong)CircleView *circleViewLabel;
@property(nonatomic, strong)UIButton *tapButton;
@end
@implementation FingerPrintAuthViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor customYellowColor];
    //图片圆圈
    self.circleViewImage = [[CircleView alloc] initWithFrame:CGRectMake(0, 0, 160, 160)];
    [self.view addSubview:self.circleViewImage];
    self.circleViewImage.lineColor = [UIColor customBlueColor];
    self.circleViewImage.cirCleType = CirCleTypeImage;
    self.circleViewImage.center = CGPointMake(CGRectGetWidth(self.view.bounds)/2, CGRectGetHeight(self.view.bounds)/2);
    [self.circleViewImage setCircleStrokeEndWithStrokeEnd:1.0 animated:YES];
    //label圆圈
    self.circleViewLabel = [[CircleView alloc] initWithFrame:CGRectMake(0, 0, 160, 160)];
    [self.view addSubview:self.circleViewLabel];
    self.circleViewLabel.lineColor = [UIColor customGreenColor];
    self.circleViewLabel.center = CGPointMake(self.view.bounds.size.width/2/2, self.view.bounds.size.height/2/2);
    self.circleViewLabel.transform = CGAffineTransformScale(self.circleViewLabel.transform, 0.5, 0.5);
    //按钮
    self.tapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.tapButton setTitle:@"开启" forState:UIControlStateNormal];
    [self.tapButton setFrame:CGRectMake(20, CGRectGetHeight(self.view.bounds)/2 + 160, CGRectGetWidth(self.view.bounds) - 20 *2, 44)];
    self.tapButton.backgroundColor = [UIColor customRedColor];
    self.tapButton.layer.cornerRadius = 22.0f;
    [self.tapButton addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.tapButton];
    
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.circleViewLabel dismissAnimation];
}

- (void)buttonTap:(UIButton *)button
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
    
    if (imageIsCenter) {
        //位移变换
        imageCircleCenterAnim.toValue = [NSValue valueWithCGPoint:CGPointMake(self.view.bounds.size.width - self.view.bounds.size.width/2/2, self.view.bounds.size.height/2/2)];
        labelCircleCenterAnim.toValue = [NSValue valueWithCGPoint:CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2)];
        
        //大小变化
        imageCircleScaleAnim.toValue = [NSValue valueWithCGPoint:CGPointMake(0.5, 0.5)];
        labelCircleScaleAnim.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
    }else{
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
    
    if (imageIsCenter) {
        [imageCircleCenterAnim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
            if (finished) {
                [self.circleViewImage setCircleStrokeEndWithStrokeEnd:0.0 animated:YES];
            }
        }];
        [labelCircleCenterAnim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
            if (finished) {
                [self.circleViewLabel setCircleStrokeEndWithStrokeEnd:1.0 animated:YES];
            }
        }];
        
    }else{
        [labelCircleCenterAnim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
            if (finished) {
                [self.circleViewLabel setCircleStrokeEndWithStrokeEnd:0.0 animated:YES];
            }
        }];
        
        [imageCircleCenterAnim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
            if (finished) {
                [self.circleViewImage setCircleStrokeEndWithStrokeEnd:1.0 animated:YES];
            }
        }];
    }
    [self.circleViewImage pop_addAnimation:imageCircleScaleAnim forKey:@"ImageCircleScaleAnim"];
    [self.circleViewLabel pop_addAnimation:labelCircleScaleAnim forKey:@"LabelCircleScaleAnim"];
    [self.circleViewImage pop_addAnimation:imageCircleCenterAnim forKey:@"ImageCircleCenterAnim"];
    [self.circleViewLabel pop_addAnimation:labelCircleCenterAnim forKey:@"LabelCircleCenterAnim"];
    
}

@end
