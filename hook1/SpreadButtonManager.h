//
//  SpreadButtonManager.h
//  FloatWindowDemo
//
//  Created by fenglh on 16/7/25.
//  Copyright © 2016年 xiaoxigame. All rights reserved.
//

#import <Foundation/Foundation.h>

//0：关闭红包插件
//1：打开红包插件
//2: 不抢自己的红包
//3: 不抢群里自己发的红包


typedef NS_ENUM(NSInteger, RedEnvPluginType)
{
    //以下是枚举成员
    kCloseRedEnvPlugin = 0,
    kOpenRedEnvPlugin = 1,
    kCloseRedEnvPluginForMyself = 2,
    kCloseRedEnvPluginForMyselfFromChatroom = 3
};

@interface SpreadButtonManager : NSObject

@property (nonatomic,readonly, assign) BOOL isShowing;//是否显示悬浮按钮
@property (nonatomic,readonly, assign) BOOL avoidRevoke;//防撤销
@property (nonatomic,readonly, assign) BOOL oneKeyRecord;//一键录音
@property (nonatomic, readonly, assign) RedEnvPluginType redEnvPluginType;//抢红包类型

@property (nonatomic,readonly,assign) NSUInteger authTimeLeftSecond;//认证剩余时间


+ (instancetype)sharedInstance;
- (void)shake;
- (void)openAvoidRevoke:(BOOL)open;
- (void)openRedEnvPlugin:(RedEnvPluginType)type;
- (void)openOneKeyRecord:(BOOL)open;
- (void)setAuthValidTime:(double)seconds;
@end
