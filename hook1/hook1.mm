#import "CaptainHook.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import <UIKit/UIKit.h>
#define BindFingerPrintOpen @"BindFingerPrintOpen"
#import "SpreadButtonManager.h"



static void motionBegan(id self, SEL _cmd,UIEventSubtype motion, UIEvent *event)
{
    //检测到摇动开始
    NSLog(@"摇一摇了");
    if (motion == UIEventSubtypeMotionShake) {
        if ([SpreadButtonManager sharedInstance].isShowing) {
            [[SpreadButtonManager sharedInstance] hide];
        }else{
            [[SpreadButtonManager sharedInstance] show];
        }
    }
}

//hook bundleid
CHDeclareClass(ManualAuthAesReqData);
CHDeclareClass(NewMainFrameViewController);
CHDeclareClass(CMessageMgr);

//聊天内容防撤回
CHMethod(1,void, CMessageMgr,onRevokeMsg,id,arg1)
{
    NSLog(@"撤回被拦截...");
    return;
}

CHMethod(0,NSString *,ManualAuthAesReqData,bundleId)
{
    return @"com.tencent.xin";
}



//参数个数、返回值类型、类名、selector名称、selector的类型、selector对应的参数的变量名
CHMethod(2, void, NewMainFrameViewController, tableView, id, tableView, didSelectRowAtIndexPath ,id ,indexPath)
{
    if ([SpreadButtonManager sharedInstance].isWXLocking) {
        LAContext *context = [[LAContext alloc] init];
        NSError *authError = nil;
        NSString *localizedReasonString = @"请输入指纹";
        if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
            [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:localizedReasonString reply:^(BOOL success, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (success) {
                        CHSuper(2, NewMainFrameViewController, tableView, tableView, didSelectRowAtIndexPath, indexPath);
                    }else{
                        
                    }
                });
                
            }];
        }
    }else{
        CHSuper(2, NewMainFrameViewController, tableView, tableView, didSelectRowAtIndexPath, indexPath);
    }
    
}

/*
 *添加摇一摇功能
 *微信聊天界面所在viewController ：NewMainFrameViewController
 */

CHMethod(0,void,NewMainFrameViewController,viewDidLoad)
{
    CHSuper(0, NewMainFrameViewController,viewDidLoad);
    //开启悬浮按钮
    [[SpreadButtonManager sharedInstance] show];
    

}


__attribute__((constructor)) static void entry()
{

    CHLoadLateClass(ManualAuthAesReqData);
    CHClassHook(0,ManualAuthAesReqData,bundleId);
    
    CHLoadLateClass(CMessageMgr);
    CHClassHook(1,CMessageMgr,onRevokeMsg);
    
    
    CHLoadLateClass(NewMainFrameViewController);
    CHClassHook(2, NewMainFrameViewController,tableView,didSelectRowAtIndexPath);
    CHClassHook(0, NewMainFrameViewController,viewDidLoad);
    
    
}


