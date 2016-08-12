//
//  SpreadButtonManager.h
//  FloatWindowDemo
//
//  Created by fenglh on 16/7/25.
//  Copyright © 2016年 xiaoxigame. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpreadButtonManager : NSObject

@property (nonatomic,readonly, assign) BOOL isShowing;//是否显示悬浮按钮
@property (nonatomic,readonly, assign) BOOL isWXLocking;
+ (instancetype)sharedInstance;
- (void)show;
- (void)hide;
@end
