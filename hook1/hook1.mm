#import "CaptainHook.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import <UIKit/UIKit.h>
#define BindFingerPrintOpen @"BindFingerPrintOpen"
#import "SpreadButtonManager.h"


static void motionBegan(id self, SEL _cmd,UIEventSubtype motion, UIEvent *event)
{
    //检测到摇动开始
    if (motion == UIEventSubtypeMotionShake) {
        NSLog(@"摇一摇了");
    }
}

//hook bundleid
CHDeclareClass(ManualAuthAesReqData);
CHDeclareClass(NewMainFrameViewController);
CHDeclareClass(CMessageMgr);

//本工程测试ViewController
CHDeclareClass(ViewController);

//****************************微信hook函数*************************************//

//聊天内容防撤回
CHMethod(1,void, CMessageMgr,onRevokeMsg,id,arg1)
{
    NSLog(@"hook [CMessageMgr:-onRevokeMsg]");
    return;
}

//bundleid
CHMethod(0,NSString *,ManualAuthAesReqData,bundleId)
{
    NSLog(@"hook [ManualAuthAesReqData:-bundleId]");
    return @"com.tencent.xin";
}

CHMethod(0,void,NewMainFrameViewController,viewDidLoad)
{
    NSLog(@"hook [NewMainFrameViewController:-viewDidLoad]");
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

//****************************微信hook函数*************************************//


//****************************demo测试 hook函数*************************************//

CHMethod(0,void,ViewController,viewDidLoad)
{
    CHSuper(0, ViewController,viewDidLoad);
    
    NSLog(@"hook [ViewController:-viewDidLoad]");
    //开启摇一摇功能
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
    //为类添加方法
    class_addMethod(objc_getClass("ViewController"), @selector(motionBegan:withEvent:), (IMP)motionBegan, "V@:");
    
}

//****************************demo测试 hook函数*************************************//

__attribute__((constructor)) static void entry()
{

    CHLoadLateClass(ManualAuthAesReqData);
    CHClassHook(0,ManualAuthAesReqData,bundleId);
    
    CHLoadLateClass(CMessageMgr);
    CHClassHook(1,CMessageMgr,onRevokeMsg);
    
    
    CHLoadLateClass(NewMainFrameViewController);
    CHClassHook(0, NewMainFrameViewController,viewDidLoad);
    CHClassHook(2, NewMainFrameViewController,tableView,didSelectRowAtIndexPath);
    
    
    ///***********DEMO测试*************//
    CHLoadLateClass(ViewController);
    CHClassHook(0,ViewController,viewDidLoad);
    
    
}


