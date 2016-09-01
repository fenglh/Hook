//
//  UIApplication+ITXExtension.m
//  hook1
//
//  Created by 冯立海 on 16/8/31.
//
//

#import "UIApplication+ITXExtension.h"

@implementation UIApplication (ITXExtension)

+ (UIViewController *)itx_topViewController {
    UIViewController *rootViewController = ((UIWindow *)[[[UIApplication sharedApplication] windows] objectAtIndex:0]).rootViewController;
    UIViewController *topViewController = rootViewController;
    NSLog(@"topViewController:%@",[topViewController class]);
    if ([topViewController isKindOfClass:[UITabBarController class]]) {
        topViewController = [(UITabBarController *)topViewController selectedViewController];
        NSLog(@"selectedViewController:%@",[topViewController class]);
    }
    while (topViewController.presentedViewController) {
        NSLog(@"%@可以presentedViewController",[topViewController class]);
        topViewController = topViewController.presentedViewController;
        NSLog(@"presentedViewController topViewController 后:%@",[topViewController class]);
    }
    if ([topViewController isKindOfClass:[UINavigationController class]]) {
        topViewController = [((UINavigationController *)topViewController).viewControllers lastObject];
        NSLog(@"topViewController是UINavigationController,取lastObject :%@",[topViewController class]);
    }
    return topViewController;
}

@end
