#import "CaptainHook.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import <UIKit/UIKit.h>
#define BindFingerPrintOpen @"BindFingerPrintOpen"
#import "SpreadButtonManager.h"
#import "UIApplication+ITXExtension.h"

//Build Setting--> Apple LLVM 6.0 - Preprocessing--> Enable Strict Checking of objc_msgSend Calls  改为 NO


static void motionBegan(id self, SEL _cmd,UIEventSubtype motion, UIEvent *event)
{
    //检测到摇动开始
    if (motion == UIEventSubtypeMotionShake) {
        [[SpreadButtonManager sharedInstance] shake];
    }
}

//hook bundleid
CHDeclareClass(ManualAuthAesReqData);
CHDeclareClass(NewMainFrameViewController);
CHDeclareClass(CMessageMgr);
CHDeclareClass(BaseMsgContentViewController);
CHDeclareClass(MMInputToolView);

//本工程测试ViewController
CHDeclareClass(ViewController);

//****************************微信hook函数*************************************//


CHMethod(1,void,BaseMsgContentViewController,viewWillAppear,BOOL, animated)
{
    CHSuper(1, BaseMsgContentViewController,viewWillAppear,animated);
    UIViewController *selfVC = [UIApplication itx_topViewController];
    if (![selfVC isKindOfClass:objc_getClass("BaseMsgContentViewController")]) {
        NSLog(@"逆向日志>> topViewController 不是 BaseMsgContentViewController");
        return;
    }
    Ivar inputToolViewIvar = class_getInstanceVariable(objc_getClass("BaseMsgContentViewController"), "_inputToolView");
    id toolView = object_getIvar(selfVC, inputToolViewIvar);
    NSLog(@"逆向日志>> selfVC:%@, 变量toolView:%@",selfVC,toolView);
    Ivar recordButtonIvar = class_getInstanceVariable(objc_getClass("MMInputToolView"),"_recordButton");
    id  recordButton = object_getIvar(toolView, recordButtonIvar);
    NSLog(@"逆向日志>> recordButton:%@",recordButton);
    if ([SpreadButtonManager sharedInstance].oneKeyRecord) {
        [(UIButton *)recordButton setTitle:@"一键 说话" forState:0];
    }else{
        [(UIButton *)recordButton setTitle:@"按住 说话" forState:0];
    }
    
}


CHMethod(2, void,MMInputToolView,MMTransparentButton_touchesEnded,id,arg1,withEvent,id,arg2)
{
    if ([SpreadButtonManager sharedInstance].oneKeyRecord) {
        return;
    }
    CHSuper(2, MMInputToolView,MMTransparentButton_touchesEnded,arg1,withEvent,arg2);
}
CHMethod(2, void,MMInputToolView,MMTransparentButton_touchesMoved,id,arg1,withEvent,id,arg2)
{
    if (![SpreadButtonManager sharedInstance].oneKeyRecord) {
        return;
    }
    CHSuper(2, MMInputToolView,MMTransparentButton_touchesMoved,arg1,withEvent,arg2);
}
CHMethod(2, void,MMInputToolView,MMTransparentButton_touchesCancelled,id,arg1,withEvent,id,arg2)
{
    if (![SpreadButtonManager sharedInstance].oneKeyRecord) {
        return;
    }
    CHSuper(2, MMInputToolView,MMTransparentButton_touchesCancelled,arg1,withEvent,arg2);
}
CHMethod(2, void,MMInputToolView,MMTransparentButton_touchesBegan,id,arg1,withEvent,id,arg2)
{
    if (![SpreadButtonManager sharedInstance].oneKeyRecord) {
        CHSuper(2, MMInputToolView,MMTransparentButton_touchesBegan,arg1,withEvent,arg2);
        return;
    }
    UIViewController *selfVC = [UIApplication itx_topViewController];
    Ivar inputToolViewIvar = class_getInstanceVariable(objc_getClass("BaseMsgContentViewController"), "_inputToolView");
    id toolView = object_getIvar(selfVC, inputToolViewIvar);
    [toolView performSelector:@selector(resalStartRecording) withObject:nil];
    NSLog(@"调用toolView resalStartRecording方法:%@",toolView);
}


//聊天内容防撤回
CHMethod(1,void, CMessageMgr,onRevokeMsg,id,arg1)
{
    if ([[SpreadButtonManager sharedInstance] avoidRevoke]) {
        NSLog(@"hook [CMessageMgr:-onRevokeMsg]");
        return;
    }else{
        CHSuper(1, CMessageMgr,onRevokeMsg,arg1);
    }

}

//bundleid
CHMethod(0,NSString *,ManualAuthAesReqData,bundleId)
{
    NSLog(@"hook [ManualAuthAesReqData:-bundleId]");
    return @"com.tencent.xin";
}
CHMethod(1,void,NewMainFrameViewController,viewWillAppear,BOOL, animated)
{
    CHSuper(1, NewMainFrameViewController,viewWillAppear,animated);
    [UIApplication itx_topViewController].navigationController.delegate = nil;
    [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
    NSLog(@"重置navigationController.delegate = nil");
    
}
CHMethod(0,void,NewMainFrameViewController,viewDidLoad)
{
    CHSuper(0, NewMainFrameViewController,viewDidLoad);
    NSLog(@"hook [NewMainFrameViewController:-viewDidLoad]");
    //开启摇一摇功能
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
    //为类添加方法
    class_addMethod(objc_getClass("NewMainFrameViewController"), @selector(motionBegan:withEvent:), (IMP)motionBegan, "V@:");
}

//参数个数、返回值类型、类名、selector名称、selector的类型、selector对应的参数的变量名
CHMethod(2, void, NewMainFrameViewController, tableView, id, tableView, didSelectRowAtIndexPath ,id ,indexPath)
{
    if ([SpreadButtonManager sharedInstance].authTimeLeftSecond != 0) {
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


CHMethod(2, void, CMessageMgr, AsyncOnAddMsg, id, arg1, MsgWrap, id, arg2)
{
    CHSuper(2, CMessageMgr, AsyncOnAddMsg, arg1, MsgWrap, arg2);
    Ivar uiMessageTypeIvar = class_getInstanceVariable(objc_getClass("CMessageWrap"), "m_uiMessageType");
    ptrdiff_t offset = ivar_getOffset(uiMessageTypeIvar);
    unsigned char *stuffBytes = (unsigned char *)(__bridge void *)arg2;
    NSUInteger m_uiMessageType = * ((NSUInteger *)(stuffBytes + offset));
    
    Ivar nsFromUsrIvar = class_getInstanceVariable(objc_getClass("CMessageWrap"), "m_nsFromUsr");
    id m_nsFromUsr = object_getIvar(arg2, nsFromUsrIvar);
    
    Ivar nsContentIvar = class_getInstanceVariable(objc_getClass("CMessageWrap"), "m_nsContent");
    id m_nsContent = object_getIvar(arg2, nsContentIvar);
    
    switch(m_uiMessageType) {
        case 1:
        {
            //普通聊天消息不做处理
        }
            break;
        case 49: {
            // 49=红包
            
            //微信的服务中心
            Method methodMMServiceCenter = class_getClassMethod(objc_getClass("MMServiceCenter"), @selector(defaultCenter));
            IMP impMMSC = method_getImplementation(methodMMServiceCenter);
            id MMServiceCenter = impMMSC(objc_getClass("MMServiceCenter"), @selector(defaultCenter));
            //红包控制器
            id logicMgr = ((id (*)(id, SEL, Class))objc_msgSend)(MMServiceCenter, @selector(getService:),objc_getClass("WCRedEnvelopesLogicMgr"));
            //通讯录管理器
            id contactManager = ((id (*)(id, SEL, Class))objc_msgSend)(MMServiceCenter, @selector(getService:),objc_getClass("CContactMgr"));
            
            Method methodGetSelfContact = class_getInstanceMethod(objc_getClass("CContactMgr"), @selector(getSelfContact));
            IMP impGS = method_getImplementation(methodGetSelfContact);
            id selfContact = impGS(contactManager, @selector(getSelfContact));
            
            Ivar nsUsrNameIvar = class_getInstanceVariable([selfContact class], "m_nsUsrName");
            id m_nsUsrName = object_getIvar(selfContact, nsUsrNameIvar);
            BOOL isMesasgeFromMe = NO;
            BOOL isChatroom = NO;
            if ([m_nsFromUsr isEqualToString:m_nsUsrName]) {
                isMesasgeFromMe = YES;
            }
            if ([m_nsFromUsr rangeOfString:@"@chatroom"].location != NSNotFound)
            {
                isChatroom = YES;
            }
            if (isMesasgeFromMe && kCloseRedEnvPluginForMyself == [SpreadButtonManager sharedInstance].redEnvPluginType && !isChatroom) {
                //不抢自己的红包
                break;
            }
            else if(isMesasgeFromMe && kCloseRedEnvPluginForMyselfFromChatroom == [SpreadButtonManager sharedInstance].redEnvPluginType && isChatroom)
            {
                //不抢群里自己的红包
                break;
            }
            
            if ([m_nsContent rangeOfString:@"wxpay://"].location != NSNotFound)
            {
                NSString *nativeUrl = m_nsContent;
                NSRange rangeStart = [m_nsContent rangeOfString:@"wxpay://c2cbizmessagehandler/hongbao"];
                if (rangeStart.location != NSNotFound)
                {
                    NSUInteger locationStart = rangeStart.location;
                    nativeUrl = [nativeUrl substringFromIndex:locationStart];
                }
                
                NSRange rangeEnd = [nativeUrl rangeOfString:@"]]"];
                if (rangeEnd.location != NSNotFound)
                {
                    NSUInteger locationEnd = rangeEnd.location;
                    nativeUrl = [nativeUrl substringToIndex:locationEnd];
                }
                
                NSString *naUrl = [nativeUrl substringFromIndex:[@"wxpay://c2cbizmessagehandler/hongbao/receivehongbao?" length]];
                
                NSArray *parameterPairs =[naUrl componentsSeparatedByString:@"&"];
                
                NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:[parameterPairs count]];
                for (NSString *currentPair in parameterPairs) {
                    NSRange range = [currentPair rangeOfString:@"="];
                    if(range.location == NSNotFound)
                        continue;
                    NSString *key = [currentPair substringToIndex:range.location];
                    NSString *value =[currentPair substringFromIndex:range.location + 1];
                    [parameters setObject:value forKey:key];
                }
                
                //红包参数
                NSMutableDictionary *params = [@{} mutableCopy];
                
                [params setObject:parameters[@"msgtype"]?:@"null" forKey:@"msgType"];
                [params setObject:parameters[@"sendid"]?:@"null" forKey:@"sendId"];
                [params setObject:parameters[@"channelid"]?:@"null" forKey:@"channelId"];
                
                id getContactDisplayName = objc_msgSend(selfContact, @selector(getContactDisplayName));
                id m_nsHeadImgUrl = objc_msgSend(selfContact, @selector(m_nsHeadImgUrl));
                
                [params setObject:getContactDisplayName forKey:@"nickName"];
                [params setObject:m_nsHeadImgUrl forKey:@"headImg"];
                [params setObject:[NSString stringWithFormat:@"%@", nativeUrl]?:@"null" forKey:@"nativeUrl"];
                [params setObject:m_nsFromUsr?:@"null" forKey:@"sessionUserName"];
                
                if (kCloseRedEnvPlugin != [SpreadButtonManager sharedInstance].redEnvPluginType) {
                    //自动抢红包
                    ((void (*)(id, SEL, NSMutableDictionary*))objc_msgSend)(logicMgr, @selector(OpenRedEnvelopesRequest:), params);
                }
                return;
            }
            
            break;
        }
        default:
            break;
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
    CHClassHook(2, CMessageMgr, AsyncOnAddMsg, MsgWrap);
    
    
    CHLoadLateClass(NewMainFrameViewController);
    CHClassHook(1, NewMainFrameViewController,viewWillAppear);
    CHClassHook(0, NewMainFrameViewController,viewDidLoad);
    CHClassHook(2, NewMainFrameViewController,tableView,didSelectRowAtIndexPath);
    
    //微信一键说话
    CHLoadLateClass(BaseMsgContentViewController);
    CHClassHook(1,BaseMsgContentViewController,viewWillAppear);
    //
    CHLoadLateClass(MMInputToolView);
    CHClassHook(2,MMInputToolView,MMTransparentButton_touchesBegan,withEvent);
    CHClassHook(2,MMInputToolView,MMTransparentButton_touchesCancelled,withEvent);
    CHClassHook(2,MMInputToolView,MMTransparentButton_touchesEnded,withEvent);
    CHClassHook(2,MMInputToolView,MMTransparentButton_touchesMoved,withEvent);
    
    ///***********DEMO测试*************//
//    CHLoadLateClass(ViewController);
//    CHClassHook(0,ViewController,viewDidLoad);
    
    
}


