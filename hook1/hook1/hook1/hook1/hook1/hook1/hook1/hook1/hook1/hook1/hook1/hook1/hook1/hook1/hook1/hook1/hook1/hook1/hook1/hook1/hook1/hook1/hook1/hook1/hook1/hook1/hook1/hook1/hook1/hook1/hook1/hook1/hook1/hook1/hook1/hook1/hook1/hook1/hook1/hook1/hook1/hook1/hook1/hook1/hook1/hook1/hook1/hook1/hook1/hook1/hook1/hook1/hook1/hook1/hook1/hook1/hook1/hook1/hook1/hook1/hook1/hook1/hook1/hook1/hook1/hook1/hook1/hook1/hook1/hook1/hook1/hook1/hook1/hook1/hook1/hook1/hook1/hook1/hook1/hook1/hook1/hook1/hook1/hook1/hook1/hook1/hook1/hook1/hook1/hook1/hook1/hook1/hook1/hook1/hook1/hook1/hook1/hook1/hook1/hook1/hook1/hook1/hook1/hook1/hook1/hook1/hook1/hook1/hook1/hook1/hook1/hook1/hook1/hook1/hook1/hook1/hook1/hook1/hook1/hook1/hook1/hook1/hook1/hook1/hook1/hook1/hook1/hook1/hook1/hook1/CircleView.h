//
//  CircleView.h
//  hook1
//
//  Created by 冯立海 on 16/8/23.
//
//

#import <UIKit/UIKit.h>
#import <POP.h>

typedef NS_ENUM(NSInteger, CirCleType) {
    //以下是枚举成员
    CirCleTypeLabel = 0,
    CirCleTypeImage = 1
};


//static const NSString *kITXCountDownNotification @"kITXCountDownNotification";

@interface CircleView : UIView
@property (nonatomic,readonly, assign)NSUInteger maxSecond;//时间最大值，默认1个小时

@property (nonatomic, strong)UIColor *lineColor;//线条颜色
@property (nonatomic, assign)CirCleType cirCleType;
@property (copy, nonatomic) void (^completionCircleBlock)(POPAnimation *anim, BOOL finished);
@property (copy, nonatomic) void (^completionLabelBlock)(POPAnimation *anim, BOOL finished);

- (void)animationWithStrokeEnd:(CGFloat)strokeEnd labelAutoCountDownAnimation:(BOOL)autoCountDown;
- (void)labelCountDownAnimationWithRate:(CGFloat)rate;
- (void)labelCountUpAnimationWithRate:(CGFloat)rate;
- (void)setLabelTimeWithTimeLeft:(CGFloat)timeLeft;
- (void)dismissAnimation;
@end
