//
//  CircleView.m
//  hook1
//
//  Created by 冯立海 on 16/8/23.
//
//

#import "CircleView.h"
#import "UIColor+CustomColors.h"
#import <POP.h>
#define FingerPrintImageWidth 60
#define LineWidth 4.0f
#define Radius (self.bounds.size.width/2-LineWidth)

@interface CircleView ()
@property (nonatomic, strong)CAShapeLayer *circleLayer;
@property (nonatomic, strong)UIImageView *fingerPrintimageView;
@property(nonatomic,strong)UILabel * label;
@property (nonatomic, assign)NSUInteger maxSecond;//时间最大值，默认1个小时
@end

@implementation CircleView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureCircle];
        [self configureLabel];
        self.maxSecond = 60*60*1;//默认1个小时
    }
    return self;
}

- (void)configureLabel
{
    self.label = [[UILabel alloc]init];
    self.label.text = @"00:00:00";
    self.label.frame = CGRectMake(0, 0, 100, 100);
    self.label.textColor = [UIColor customGrayColor];
    self.label.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    self.label.font = [UIFont fontWithName:@"Avenir-Light" size:25];
    self.label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.label];
}
- (void)configureImage
{
    self.fingerPrintimageView = [[UIImageView alloc] init];
    self.fingerPrintimageView.layer.masksToBounds = YES;
    self.fingerPrintimageView.image = [UIImage imageNamed:@"icon_fingerprint.png"];
    self.fingerPrintimageView.layer.cornerRadius = FingerPrintImageWidth/2.0;
    self.fingerPrintimageView.frame = CGRectMake(0, 0, FingerPrintImageWidth, FingerPrintImageWidth);
    self.fingerPrintimageView.center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
    self.fingerPrintimageView.layer.opacity = 0.0f;
    [self addSubview:self.fingerPrintimageView];
    
}
- (void)configureCircle
{
    self.circleLayer = [CAShapeLayer layer];
    //半径
    CGRect rect = CGRectMake(LineWidth/2, LineWidth/2, Radius*2, Radius*2);
    self.circleLayer.strokeColor = self.lineColor.CGColor;
    UIBezierPath *bezPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:Radius];
    self.circleLayer.path = bezPath.CGPath;
    self.circleLayer.fillColor = nil;
    self.circleLayer.lineJoin = kCALineJoinRound;
    self.circleLayer.lineCap =kCALineCapRound;
    self.circleLayer.lineWidth = LineWidth;
    self.circleLayer.strokeStart = 0.0f;
    self.circleLayer.strokeEnd = 0.0f;
    
    CAShapeLayer *bgCircle = [CAShapeLayer layer];
    bgCircle.lineWidth = 1.0f;
    bgCircle.fillColor = nil;
    bgCircle.strokeColor = [UIColor customGrayColor].CGColor;
    bgCircle.lineJoin = kCALineJoinRound;
    bgCircle.lineCap =kCALineCapRound;
    bgCircle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(LineWidth/2+1, LineWidth/2+1, Radius*2, Radius*2) cornerRadius:Radius-LineWidth].CGPath;
    
    
    [self.layer addSublayer:bgCircle];
    [self.layer addSublayer:self.circleLayer];
}

- (void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
    self.circleLayer.strokeColor = lineColor.CGColor;
}

- (void)labelAnimationWithRate:(CGFloat)rate
{
    POPAnimatableProperty *prop = [POPAnimatableProperty propertyWithName:@"countdown" initializer:^(POPMutableAnimatableProperty *prop) {
        //writeBlock 中修改变化后的属性值
        prop.writeBlock = ^(id obj, const CGFloat values[]){
            UILabel *label = (UILabel *)obj;
            
            CGFloat timeLeft = self.maxSecond*rate - values[0];
            label.text = [NSString stringWithFormat:@"%02d:%02d:%02d",(int)timeLeft/60,(int)timeLeft%60,(int)(timeLeft*100)%60];
            self.circleLayer.strokeEnd = timeLeft/self.maxSecond;
            NSLog(@"剩余时间%@,比例%f",label.text,timeLeft/self.maxSecond);

        };
        //        //决定了动画变化间隔的阈值， 值越大writeBlock的调用次数越少
        prop.threshold = 0.01;
        
        
    }];
    POPBasicAnimation *anBasic = [POPBasicAnimation linearAnimation];//秒表当然必须是线性的时间函数
    anBasic.property = prop;//自定义属性
    anBasic.fromValue = @(0);//从0开始
    anBasic.toValue = @(self.maxSecond*rate);//
    anBasic.duration = self.maxSecond*rate;//持续时间
    anBasic.beginTime = CACurrentMediaTime() + 0.3f;//延迟0.3秒开始
    
    [self.label pop_addAnimation:anBasic forKey:@"countdown"];
}
- (void)iamgeViewAnimation
{
    POPSpringAnimation *scaleAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnim.springBounciness = 10;
    scaleAnim.springSpeed = 20;
    scaleAnim.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    scaleAnim.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
    POPBasicAnimation *opacityAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    opacityAnim.duration = 0.3;
    opacityAnim.toValue = @1.0;
    [self.fingerPrintimageView.layer pop_addAnimation:scaleAnim forKey:@"ScaleAnim"];
    [self.fingerPrintimageView.layer pop_addAnimation:opacityAnim forKey:@"OpacityAnim"];
}
- (void)animationWithStrokeEnd:(CGFloat)strokeEnd
{
    POPBasicAnimation *strokeEndAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeEnd];
    strokeEndAnim.toValue = @(strokeEnd);
    strokeEndAnim.duration = 2.5f;
    strokeEndAnim.removedOnCompletion = NO;
    [strokeEndAnim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            if (self.cirCleType == CirCleTypeLabel) {
                [self labelAnimationWithRate:strokeEnd];
            }else{
                [self iamgeViewAnimation];
            }
            
        }
    }];
    [self.circleLayer pop_addAnimation:strokeEndAnim forKey:@"StrokeEndAnim"];
    
}

- (void)setCircleStrokeEndWithStrokeEnd:(CGFloat)strokeEnd animated:(BOOL)animated
{
    if (animated) {
        [self animationWithStrokeEnd:strokeEnd];
    }else{
        self.circleLayer.strokeEnd = strokeEnd;
    }
}

- (void)setCirCleType:(CirCleType)cirCleType
{
    _cirCleType = cirCleType;
    if (cirCleType == CirCleTypeImage) {
        [self.label removeFromSuperview];
        [self configureImage];
    }
}

- (void)dismissAnimation
{
    [self.label pop_removeAllAnimations];
}
@end
