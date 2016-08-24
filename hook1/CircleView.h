//
//  CircleView.h
//  hook1
//
//  Created by 冯立海 on 16/8/23.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CirCleType) {
    //以下是枚举成员
    CirCleTypeLabel = 0,
    CirCleTypeImage = 1
};

@interface CircleView : UIView
@property (nonatomic, strong)UIColor *lineColor;//线条颜色
@property (nonatomic, assign)CirCleType cirCleType;
- (void)setCircleStrokeEndWithStrokeEnd:(CGFloat)strokeEnd animated:(BOOL)animated;
- (void)dismissAnimation;
@end
