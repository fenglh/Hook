//
//  FlatButton.m
//  Popping
//
//  Created by fenglh on 12.05.14.
//  Copyright (c) 2014 fenglh. All rights reserved.
//

#import "FlatButton.h"
#import <POP/POP.h>

@interface FlatButton()
- (void)setup;
- (void)scaleToSmall;
- (void)scaleAnimation;
- (void)scaleToDefault;
@end

@implementation FlatButton

+ (instancetype)button
{
    return [self buttonWithType:UIButtonTypeCustom];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark - Instance methods


- (CGSize)intrinsicContentSize
{
    [super intrinsicContentSize];
    return CGSizeMake(40,40);
    
}

#pragma mark - Private instance methods

- (void)setup
{
    self.backgroundColor = self.tintColor;
    self.layer.cornerRadius = 4.f;
//    [self setTitleColor:[UIColor whiteColor]
//                 forState:UIControlStateNormal];
//    self.titleLabel.font = [UIFont fontWithName:@"Avenir-Medium"
//                                             size:18];

    [self addTarget:self action:@selector(scaleToSmall)
   forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter];
    [self addTarget:self action:@selector(scaleAnimation)
   forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(scaleToDefault)
   forControlEvents:UIControlEventTouchDragExit];
}

- (void)scaleToSmall
{
    POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(0.75f, 0.75f)];
    [self.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSmallAnimation"];
}

- (void)scaleAnimation
{
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(3.f, 3.f)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    scaleAnimation.springBounciness = 18.0f;
    [self.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSpringAnimation"];
}

- (void)scaleToDefault
{
    POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    [self.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleDefaultAnimation"];
}

@end
