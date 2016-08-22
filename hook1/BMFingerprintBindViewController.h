//
//  BMFingerprintBindViewController.h
//  BlueMoonHouse
//
//  Created by fenglh on 16/3/24.
//  Copyright © 2016年 bluemoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITXBaseViewController.h"

typedef void(^UpdateBindState)();

@interface BMFingerprintBindViewController : ITXBaseViewController
@property (nonatomic, strong) UpdateBindState updateBindStateBlock;
@property (assign, readonly,nonatomic) BOOL isLocking;//正在锁定
@end
