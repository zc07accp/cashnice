//
//  AppDelegate.m
//  YQS
//
//  Created by l on 3/6/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApi.h"
#import <Bugly/Bugly.h>

#import "NetworkEngine.h"
#import "WeiXinEngine.h"
#import "WXApiObject.h"
#import "UMessage.h"
#import "UtilProvince.h"
#import "UserLoginManager.h"
#import "NoticeManager.h"
#import "ValidationCodeM.h"

#import "PersonHomePage.h"
#import "BillDetail.h"
#import "MyLoansListViewController.h"
#import "GuaranteeListViewController.h"
#import "LoanInfoViewModel.h"
#import "BillInfoViewController.h"

#import "NewReg.h"
#import "JieKuanViewController.h"
#import "InvestmentListViewController.h"
#import "SendLoanViewController.h"
#import "RenMaiViewController.h"
#import "GeRenViewController.h"
#import "ServiceMessageViewController.h"
#import "NewInstruction.h"
//#import "SeachHaoyouViewController.h"
#import "NoLevel.h"
#import "YaoqingHaoyou.h"
#import "ShouxinList.h"
#import "CustomUpdateAlertView.h"
#import "IOUViewController.h"
#import "CNLog.h"
#import "RealReachability.h"
#import "GuideViewController.h"
#import "LoanEngine.h"
#import "UnlockManager.h"
#import "SystemOptionsEngine.h"
#import "LocalAuthen.h"
#import "LocalViewGuide.h"
#import "MessageLaunchingUtil.h"
#import "ContactMgr.h"
#import "LocalViewGuide.h"
#import "ADViewController.h"
#import "ZYNavigationController.h"
//#import "ContactHelper.h"
#import <FLAnimatedImage/FLAnimatedImage.h>


@interface AppDelegate () <UITabBarControllerDelegate, GeTuiSdkDelegate>
{
    GuideViewController *guideviewcontroller;
    UIVisualEffectView  *blurBackView;
}
@property (strong, nonatomic) UINavigationController *nav;

@property (strong, nonatomic) NSDictionary *pushNotification;
@property (strong, nonatomic) NSDictionary *launchOptions;

@property (strong, nonatomic) SystemOptionsEngine *engine;

@property (strong, nonatomic) NSDictionary *ntfUserInfo;
@property (assign, nonatomic) BOOL enterForeground;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.launchOptions = launchOptions; //    ;
    
    //    self.networkAuthEngine;
    //    self.wxEngine;
    //    self.netEngine;
    
    [self test];
    [self lauch];
    //    [self.znotice load];//初始化Notice Manger
    //[self registerUMessagePush];
    
    
    [self initAD];
    
    [self connectToGetSystemOptions];
    
    [GLobalRealReachability startNotifier];
    
    
    return YES;
}

-(SystemOptionsEngine *)engine{
    
    if(!_engine){
        _engine = [[SystemOptionsEngine alloc]init];
    }
    
    return _engine;
}


-(void)initGuide{
    
    guideviewcontroller = GUIDESTORY(@"GuideViewController");
    __weak __typeof__(self) weakSelf = self;
    
    guideviewcontroller.button1Block=^(void){
        [weakSelf initViewStructures:YES];
    };
    
    self.window.rootViewController=guideviewcontroller;
    
}

-(void)initAD{

    ADViewController *adviewcontroller= [[ADViewController alloc]init];
    self.window.rootViewController=adviewcontroller;
    
    WS(weakSelf)
    adviewcontroller.ADComplete = ^(){
        
            if ([GuideViewController skipGuide]) {
                [weakSelf initViewStructures:NO];
            }else{
                //第一次运行程序
                [weakSelf initGuide];
            }
            
    };
}

-(UINavigationController *)curSelNav{
    
    if (_tabViewCtrl && _tabViewCtrl.viewControllers.count > 0) {
        return _tabViewCtrl.selectedViewController;
    }
    
    return nil;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    if (! blurBackView) {
        UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        
        blurBackView = [[UIVisualEffectView alloc]initWithEffect:beffect];
        
        blurBackView.frame = self.window.bounds;
    }
    
    UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    blurBackView = [[UIVisualEffectView alloc]initWithEffect:beffect];
    
    blurBackView.frame = self.window.bounds;
    
    [self.window addSubview:blurBackView];
    
    [self.znotice stopTimer];
    
    self.enterForeground = false;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [blurBackView removeFromSuperview];
    
    if (! [self isPresentingRegView]) {
        //若果bu在登陆页面
        //登录验证手势密码页面
        [UnlockManager presentGrestureVerifier];
    }
    
    self.enterForeground = YES;
    
    if (! self.ntfUserInfo) {
        // 加载活动弹窗
        UIViewController *topVC = [self.nav.viewControllers lastObject];
        if ([topVC isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tab = (UITabBarController *)topVC;
            if (tab.selectedIndex == 0) {
                JieKuanViewController *jVC = tab.viewControllers[0];
                [jVC loadActivityView];
    #ifdef TEST_TEST_SERVER
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Title" message:@"" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
                //[alert show];
    #endif
            }
        }
    }
    
    self.ntfUserInfo = nil;

    //[self presentWeixinPage:YES];
    
    //[self connectToGetSystemOptions];
    //    [ZAPP.netEngine getSystemConfigurationInfoWithComplete:^{
    //        [Util dispatch:MSG_system_region_update];
    //    } error:^{
    //    }];
    
    
    
    //	[self.znotice startTimer];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    UILocalNotification *notification = [self.launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (notification) {
        //[self application:application didReceiveLocalNotification:notification];
        //[self notificationReceivedOperation:(NSDictionary *)notification];
//        [self.launchOptions setValue:nil forKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    }else{
        //[self notificationReceivedOperation:nil];
    }
    
    if (application.applicationState == UIApplicationStateInactive || application.applicationState == UIApplicationStateBackground) {
        //opened from a push notification when the app was on background
        
    }
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - send email for debugging

- (void)sendEmailAction
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        NSString *str = [NSString stringWithFormat:@"Cashnice调试日志-%@", [Util getUserRealNameOrNickName:ZAPP.myuser.gerenInfoDict]];
        [mail setSubject:str];
        [mail setMessageBody:@"当您发现一个问题时，按Home键退出，应用程序会自动保存状态，并在下次启动时进入此流程。\n\n请提供问题的详细描述，包括问题出现的场景，触发条件，问题当前状态，期望达到的状态（长按可插入截图）：\n\n" isHTML:NO];
        [mail setToRecipients:@[@"342043691@qq.com"]];
        
        NSData *data1 = [[NSData alloc] initWithContentsOfFile:[UtilFile docFile:LOG_FILE_NAME]];
        NSData *data2 = [[NSData alloc] initWithContentsOfFile:[UtilFile docFile:TOKEN_FILE_NAME]];
        NSData *data3 = [[NSData alloc] initWithContentsOfFile:[UtilFile docFile:USER_FILE_NAME]];
        
        [mail addAttachmentData:data1 mimeType:@"text/html" fileName:LOG_FILE_NAME];
        [mail addAttachmentData:data2 mimeType:@"text/html" fileName:TOKEN_FILE_NAME];
        [mail addAttachmentData:data3 mimeType:@"text/html" fileName:USER_FILE_NAME];
        
        [self.window.rootViewController presentViewController:mail animated:YES completion:NULL];
    }
    else
    {
        [Util sendEmail:@"342043691@qq.com" subject:@"这是一封测试邮件，以方便您配置系统邮箱" content:@"此时您已经配置好系统邮箱，可以取消或完成发送测试邮件，然后返回Cashnice重新发送日志。"];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - weixin

- (void)loginToWeiXin {
    SendAuthReq* req = [[SendAuthReq alloc] init];
    //req.scope = @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact"; // @"post_timeline,sns"
    req.scope = @"snsapi_userinfo"; // @"post_timeline,sns"
    req.state =  [self.zlogin generateWeixinLoginLocalState];// token
    
    [WXApi sendReq:req];
}

- (void)onReq:(BaseReq *)req {
    [UtilLog string:@"WeiXin onReq"];
}

- (void)onResp:(BaseResp *)resp {
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        if (ZAPP.myuser.isSharingProcess && resp.errCode == 0) {
            ///分享成功
            [ZAPP.netEngine postShareTriggerWithComplete:^{
                //[[[UIAlertView alloc] initWithTitle:@"测试" message:@"分享成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            } error:^{
                //[[[UIAlertView alloc] initWithTitle:@"测试" message:@"分享Bu成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            } triggerid:self.sharedTriggerId];
        }
        ZAPP.myuser.isSharingProcess = NO;
        //        NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
        //        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
        //
    }else
        if ([resp isKindOfClass:[SendAuthResp class]]) {
            if ([resp errCode] == WXSuccess) {
                SendAuthResp *t = (SendAuthResp *)resp;
                
                //            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                //            [dict setObject:WEIXIN_APP_ID forKey:WEIXIN_KEY_APPID];
                //            [dict setObject:WEIXIN_SECRET forKey:WEIXIN_KEY_SECRET];
                //            [dict setObject:t.code forKey:WEIXIN_KEY_CODE];
                //            [dict setObject:WEIXIN_KEY_AUTHORIZATION_CODE forKey:WEIXIN_KEY_GRANT_TYPE];
                //            MKNetworkOperation *op = [[MKNetworkOperation alloc]initWithURLString:WEIXIN_API_ACCESS_TOKEN params:dict httpMethod:@"GET"];
                //            //MKNetworkOperation *op = [self operationWithPath:WEIXIN_API_ACCESS_TOKEN params:dict httpMethod:@"GET" ssl:YES];
                //            [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
                //            } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
                //            }];
                //
                //            [self.wxEngine enqueueOperation:op];
                
                //            [self.networkAuthEngine accessToken:t.code compeletionHandler:^{
                //            } errorHandler:^{
                //            }];
                
                //            [ZAPP.netEngine getUserInfoWithComplete:^{
                //            } error:^{
                //            }];
                
                //            return;
                
                
                if ([self.zlogin compareWeixinLoginResponseStateWithLocalState:t.state]) {
                    [self getUserInfo:t.code];
                }
            }
            else {
                
                [Util toastStringOfLocalizedKey:@"tip.userCancel"];
            }
        }
}

- (void)getUserInfo:(NSString *)code {
    if ([code notEmpty]) {
        
        [self.wxEngine accessToken:code compeletionHandler:^{
            [self.wxEngine getInfoWithCompeletionHandler:^{
                [Util dispatch:MSG_weixin_login_suc];
            } errorHandler:nil];
        } errorHandler:nil];
        
        
        
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:self];
}

- (void)inviteViaWeixin:(BOOL)isChat_OrCircle {
    
    if (! [WXApi isWXAppInstalled]) {
        [Util toastStringOfLocalizedKey:@"tip.notInstallWeChat"];
        return;
    }
    
    WXMediaMessage *message = [WXMediaMessage message];
    NSString *text = @"我已加入Cashnice！这是手机上的企业家快速借贷网络。快点注册吧！";
    message.title = isChat_OrCircle ? @"邀请好友注册Cashnice" : text;
    //NSString *namestr = [ZAPP.myuser getUserRealName];
    message.description = text;
    [message setThumbImage:[UIImage imageNamed:@"AppIcon-120.png"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    
    ext.webpageUrl = [NSString stringWithFormat:@"%@sourceid=%@", INVITATION_WX_URL, [ZAPP.myuser getUserID]];
    
    message.mediaObject = ext;
    //message.mediaTagName = @"WECHAT_TAG_JUMP_SHOWRANK";
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText   = NO;
    req.message = message;
    req.scene   = isChat_OrCircle ? WXSceneSession : WXSceneTimeline;
    [WXApi sendReq:req];
}

#pragma mark - login page

- (void)changeLoginToTabs {
    
    //读取设置
    [[LocalAuthen sharedInstance] readSetting];
    
    //检查是否需要设置手势密码
    if ([UnlockManager needResetUnlockGesture]) {
        [UnlockManager presentGrestureSetter];
    }
    
//    NSMutableArray *viewControllers = [NSMutableArray new];
//    [viewControllers addObject:[self tabViewCtrl]];
//    [ZAPP.nav setViewControllers:viewControllers animated:NO];
  
    [self initViewStructures:NO];
    
    [self updateNavBarRightItems];
    
    [self.netEngine getUserInfoWithComplete:nil error:nil];
}

- (void)changeToLoginPage {
    
    [self initViewStructures:NO];
    _tabViewCtrl = nil;
}

- (void)loginout {
    
    //删除首页缓存
    LoanEngine *loan_engine = [[LoanEngine alloc] init];
    [loan_engine clearLocalData];
    
    
    //删除推送别名 个推
    [GeTuiSdk unbindAlias:ZAPP.myuser.gerenInfoDict[@"p2paccount"] andSequenceNum:@"alias"];
    
    [UMessage removeAllTags:^(id responseObject, NSInteger remain, NSError *error) {
#ifdef TEST_TEST_SERVER
        NSLog(@"删除推送别名");
#endif
        if (! error) {
        }else{
            //[Util toast:net_error_msg];
        }
    }];
    //[UMessage removeAllAlias: response:^(id responseObject, NSError *error) ];
    //[UMessage unregisterForRemoteNotifications];
    [self clearNotificationCenter];
    [self clearCache];
    [self changeToLoginPage];
    //    [UnlockManager dismissGestureView];
    
    //    [self.netEngine getSystemConfigurationInfoWithComplete:^{
    //        [Util dispatch:MSG_system_region_update];;
    //    } error:^{
    //        ;
    //    }];
    
    [self.engine getInternationListSuccess:^{
        [Util dispatch:MSG_system_region_update];;
    } failure:^(NSString *error) {
        
    }];
    
}

- (void)changeViewToFirstPage{
    if (_tabViewCtrl) {
        [_tabViewCtrl setSelectedIndex:0];
    }
}

- (void)changeViewToIOU{
    if (_tabViewCtrl) {
        /// 去掉借条
        ///[_tabViewCtrl setSelectedIndex:2];
    }
}
- (void)clearNotificationCenter {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)clearCache {
    [self.zlogin clearUserData];
    [self.myuser clearAllCache];
    [self.imgEngine emptyCache];
}

#pragma mark - methods when lauch

- (void)test {
#ifdef TEST_CODE_WHEN_LAUCH
    [UtilLog simulatorLocation];
#endif
}

-(UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 100.0f, 100.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)lauch {
    /**
     *  注册通知  个推
     */
    // [1]:使用APPID/APPKEY/APPSECRENT创建个推实例
    // 该方法需要在主线程中调用
    [self startSdkWith:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret];
    
    // [2]:注册APNS
    [self registerUMessagePush];
    
    /**
     *  状态栏
     */
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
 
    /**
     *  MKNetwork, default image engine
     */
    [UIImageView setDefaultEngine:self.imgEngine];
    
    /**
     *  友盟
     */
    NSString *channelId = @"AppStore";
#ifdef TEST_TEST_SERVER
    channelId = @"测试";
#endif
    [MobClick startWithAppkey:MobClickAppKey reportPolicy:BATCH channelId:channelId];
    [MobClick setAppVersion:[Util appVersion]];
    [MobClick setEncryptEnabled:YES];
    //[MobClick setLogEnabled:YES];
    
    /**
     *  微信
     */
    [WXApi registerApp:WEIXIN_APP_ID];
    
    /**
     *  Bugly
     */
    if (! TARGET_IPHONE_SIMULATOR){
        [Bugly startWithAppId:BUGLY_APP_ID];
    }
    
    /**
     *  其他库
     */
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    CNLog *cnlog = [[CNLog alloc]init];
    [[DDTTYLogger sharedInstance] setLogFormatter:cnlog];
    
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
}

- (void)connectToGetSystemOptions {
    
    bugeili_net_new_withouttoast
    //
    [self.engine getSystemConfigSuccess:^{
        
    } failure:^(NSString *error) {
        
    }];
    
    
    [self.engine getSystemOptionsListSuccess:^{
        
    } failure:^(NSString *error) {
        
    }];
    
    [self.engine getInternationListSuccess:^{
        
    } failure:^(NSString *error) {
    }];
    
    [self.engine getUserTransferSwitchComplete:^(BOOL opened) {
        
    }];
 
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != [alertView cancelButtonIndex]) {
        if (buttonIndex == 1) {
            YaoqingHaoyou *y = ZSTORY(@"YaoqingHaoyou");
            [[self curSelNav] pushViewController:y animated:YES];
        }
        else if (buttonIndex == 2) {
            ShouxinList *s = ZSEC(@"ShouxinList");
            [s setShowXintype:ShouXin_MeiYou];
            [[self curSelNav] pushViewController:s animated:YES];
        }
    }
}


- (void)newbiePressed {
    NewInstruction *xx = ZSTORY(@"NewInstruction");
    [[self curSelNav] pushViewController:xx animated:YES];
}


#pragma mark - nav and tab

- (void)updateNavBarRightItems {
    if(_tabViewCtrl || _tabViewCtrl.viewControllers.count > 3){
        int cnt = [self.znotice getNtfNum];
        [self updateNavBarRightItemsWithBadge:cnt];
    }
}

- (void)updateNavBarRightItemsWithBadge:(NSInteger)num{
    //    UIBarButtonItem *btnAdd = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"add"] target:self action:@selector(addPressed)];
    //    UIBarButtonItem *btnNtf = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:(isBadged ? @"wam2" : @"wam1" )] target:self action:@selector(msgPressed)];
    //        [[[self.nav.viewControllers firstObject] navigationItem] setRightBarButtonItems:@[[UIBarButtonItem spacer], btnAdd, btnNtf]];
    
    if ([self isPresentingRegView]) {
        //若果在登陆页面=>不做处理
        return;
    }
    
    
    //handle
    if(_tabViewCtrl || _tabViewCtrl.viewControllers.count > 3){
        
        UINavigationController *nav0 = _tabViewCtrl.viewControllers[0];
        if(nav0.viewControllers.count == 1){
            CustomViewController *vc0 = [nav0 viewControllers][0];
            [vc0 setNavLeftWarnBadge:num];
        }
        
        UINavigationController *nav1 = _tabViewCtrl.viewControllers[1];
        if(nav1.viewControllers.count == 1){
            CustomViewController *vc1 = [nav1 viewControllers][0];
            [vc1 setNavRightWarnBadge:num];

        }
        
        UINavigationController *nav3 = _tabViewCtrl.viewControllers[3];
        if(nav3.viewControllers.count == 1){
            CustomViewController *vc3 = [nav3 viewControllers][0];
            [vc3 setNavRightWarnBadge:num];

        }
    
        
    }
 
}

/*
 - (void)addPressed {
	NavAddPressed *navpressed = ZSTORY(@"NavAddPressed");
	if ([UtilDevice systemVersionNotLessThan:@"8.0"]) {
 navpressed.modalPresentationStyle = UIModalPresentationOverCurrentContext;
	}
	else {
 self.nav.modalPresentationStyle = UIModalPresentationCurrentContext;
 navpressed.modalPresentationStyle = UIModalPresentationCurrentContext;
	}
	navpressed.delegate               = self;
	[ZAPP.nav presentViewController:navpressed animated:NO completion:^{
 }];
 }
 */

- (void)msgPressed {
    //    BillDetail *e = ZBill(@"BillDetail");
    //    e.billID = [NSString stringWithFormat:@"%@", @(5745)];
    //    [self.nav pushViewController:e animated:YES];
    //    return;
    ServiceMessageViewController *tixing = ZBill(@"ServiceMessageViewController");
    [self.tabViewCtrl.selectedViewController pushViewController:tixing animated:YES];
//    [ZAPP.nav ];
}

- (UITabBarController *)tabViewCtrl {
    if (! _tabViewCtrl) {
        _tabViewCtrl = [[UITabBarController alloc] init];
        __weak id weakSelf = self;
        _tabViewCtrl.delegate = weakSelf;
        
//        //为tabbar设置背景
//        UIImageView *newYearImage = [[UIImageView alloc] init];
//        [newYearImage setFrame:CGRectMake(0, _tabViewCtrl.tabBar.height-15, MainScreenWidth, 15)];
//        newYearImage.backgroundColor = [UIColor clearColor];
//        [newYearImage setImage:[UIImage imageNamed:@"bg_bottom.png"]];
//        newYearImage.contentMode = UIViewContentModeBottomLeft;
//        [_tabViewCtrl.tabBar addSubview:newYearImage];
        
        [_tabViewCtrl.tabBar setBarTintColor:ZCOLOR(COLOR_TAB_BG)];
        [_tabViewCtrl.tabBar setTintColor:ZCOLOR(COLOR_NAV_BG_RED)];
        //[_tabViewCtrl.tabBar setTintColor:ZCOLOR(COLOR_NAV_BG_NEWYEAR)];
        
        
        JieKuanViewController *t0 = ZJIEKUAN(@"JieKuanViewController");
        ZYNavigationController *nav0 = [[ZYNavigationController alloc] initWithRootViewController:t0];
        
        SendLoanViewController *t1 = SENDLOANSTORY(@"SendLoanViewController");
        ZYNavigationController *nav1 = [[ZYNavigationController alloc] initWithRootViewController:t1];

        //去掉借条
        //IOUViewController *ivc = [[IOUViewController alloc]init];
        //ZYNavigationController *nav2 = [[ZYNavigationController alloc] initWithRootViewController:ivc];

        RenMaiViewController *t3 = ZRENMAI(@"RenMaiViewController");
        ZYNavigationController *nav3 = [[ZYNavigationController alloc] initWithRootViewController:t3];
        
        GeRenViewController *t4 = ZPERSON(@"GeRenViewController");
        ZYNavigationController *nav4 = [[ZYNavigationController alloc] initWithRootViewController:t4];
        
        [_tabViewCtrl setViewControllers:@[nav0, nav1, nav3, nav4]];
        
        //tabbar的图片以及文字
        NSArray *tabBarItemImages = @[@"invest_2018", @"borrow_2018", @"friend_2018", @"my_2018"]; // @"iou",
        NSArray *tabBarItemImages_sel = @[@"invest_now_2018", @"borrow_now_2018", @"friend_now_2018", @"my_now_2018"]; //@"iou_now",
        NSArray *tabBarItemNames = @[@"投资", @"借款", @"好友", @"我的"]; //@"借条",
        
        for (int i = 0; i < _tabViewCtrl.viewControllers.count; i++) {
            UIViewController *vc = [_tabViewCtrl.viewControllers objectAtIndex:i];
            UIImage *img = [UIImage imageNamed:[tabBarItemImages objectAtIndex:i]];
            UIImage *img_sel = [UIImage imageNamed:[tabBarItemImages_sel objectAtIndex:i]];
            vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:[tabBarItemNames objectAtIndex:i] image:img selectedImage:img_sel];
        }
//        //调节图片与文字的位置  向上  不至于被背景遮挡
//        for(UITabBarItem * i in _tabViewCtrl.tabBar.items){
//            i.titlePositionAdjustment = UIOffsetMake(0, -8);
//            i.imageInsets = UIEdgeInsetsMake(-4, 0, 4, 0);
//        }
        
        
        
//        //帮助引导页
//        if (0 && ([LocalViewGuide firstPersonGuideRun] || [LocalViewGuide secondPersonGuideRun])) {
//            [_tabViewCtrl setSelectedIndex:4];
//            [self setTabViewTitle:@"  " viewController:t4];
//        }else{
//            [_tabViewCtrl setSelectedIndex:0];
//            [self setTabViewTitle:@"投资" viewController:t1];
//        }
//        
        
        
    }
    return _tabViewCtrl;
}


//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
//
//    if (tabBarController.selectedIndex != 4) {
//        [self updateNavBarRightItems];
//    }
//
//}

- (void)setTabViewTitle:(NSString *)title viewController: (UIViewController *)viewController {
    for (UIView *view in viewController.parentViewController.navigationItem .titleView.subviews)
    {
        if(view)
        {
            [view removeFromSuperview];
        }
    }
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0,0,100,KNAV_SUBVIEW_MAXHEIGHT)];
    [titleView setBackgroundColor:[UIColor clearColor]];
    viewController.parentViewController.navigationItem.titleView = titleView;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, KNAV_SUBVIEW_MAXHEIGHT)];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:20.0f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:titleLabel];
}

- (void)initViewStructures:(BOOL)animated {
    /*
     [ZAPP.netEngine checkUpdateInfo:^{
     NSDictionary *updateInfo = ZAPP.myuser.versionUpdateInfoDict;
     BOOL isupdate = [updateInfo[@"isupdate"] boolValue];
     if (isupdate) {
     CustomUpdateAlertView *updateAlert = [[CustomUpdateAlertView alloc]initWithUpdateInfo:updateInfo];
     [updateAlert show];
     }
     } error:^{
     ;
     }];
     */
    //[UINavigationBar appearance].barTintColor = ZCOLOR(COLOR_NAV_BG_RED);
    [UINavigationBar appearance].barTintColor = ZCOLOR(COLOR_NAV_BG_RED);
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    NSDictionary *dicTxt = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName : [UIFont boldSystemFontOfSize:20]};
    [UINavigationBar appearance].titleTextAttributes = dicTxt;
    
    UIImage *backgroundImage = [self imageWithColor:ZCOLOR(COLOR_NAV_BG_RED)];
    [[UINavigationBar appearance] setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    
    BOOL hasUserData = [ZAPP.zlogin userDataExists];
    if (hasUserData) {

        self.window.rootViewController = self.tabViewCtrl;
        [self.window makeKeyAndVisible];
        
        if (self.launchOptions) {

            //跳转
            [self performSelector:@selector(notificationReceivedOperation:) withObject:self.launchOptions afterDelay:0.5];
        }
        
    }
    else {//未登录。
        NewReg *wx = ZSTORY(@"NewReg");
        self.nav = [[UINavigationController alloc]initWithRootViewController:wx];
        
        self.window.rootViewController = self.nav;
        [self.window makeKeyAndVisible];

        
    }
 
    if (animated) {
        
        CATransition *animation = [CATransition animation];
        animation.duration = 0.5;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = @"pageFade";
        animation.subtype = kCATransitionFade;
        [self.window.layer addAnimation:animation forKey:@"animation"];
    }
    
    
    //    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    
    if (hasUserData) {
        //登录验证手势密码页面
        [UnlockManager presentGrestureVerifier];
    }
}

#pragma mark - NotificationSetting
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [UMessage registerDeviceToken:deviceToken];
    
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"\n>>>[DeviceToken Success]:%@\n\n", token);
    
    // [3]:向个推服务器注册deviceToken
    [GeTuiSdk registerDeviceToken:token];
    
    //    NSLog(@"%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
    //                  stringByReplacingOccurrencesOfString: @">" withString: @""]
    //                 stringByReplacingOccurrencesOfString: @" " withString: @""]);
    
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    //如果注册不成功，打印错误信息，可以在网上找到对应的解决方案
    //如果注册成功，可以删掉这个方法
    NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
}

// iOS 7
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    
    [self operateRemoteNotification:userInfo];
}

//DEPRECATED
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
//    if ([UtilDevice systemVersionNotLessThan:@"10.0"]) {
//        [self operateRemoteNotification:userInfo];
//    }
//}

- (void)operateRemoteNotification:(NSDictionary *)userInfo{
    
    
    if ([self isPresentingRegView] ) {
        //用户未登陆
        return;
    }
    
    
    if (! self.enterForeground) {
        self. ntfUserInfo = userInfo;
    }

    if([UIApplication sharedApplication].applicationState != UIApplicationStateInactive && userInfo)
    {
        [self operateActiveRemoteNotification:userInfo];
    }else if(userInfo){
        [self notificationReceivedOperation:userInfo];
    }
}

- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId{
    NSLog(@"%@", clientId);
}

/** 个推SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    // [4]: 收到个推消息
    NSString *payloadMsg = nil;
    if (payloadData) {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes
                                              length:payloadData.length
                                            encoding:NSUTF8StringEncoding];
    }
    
    NSString *msg = [NSString stringWithFormat:@"%@%@", payloadMsg, offLine ? @"<离线消息>" : @""];
    NSLog(@"GexinSdkReceivePayload : %@, taskId: %@, msgId :%@", msg, taskId, msgId);
    
    //更新app提醒 小铃铛 加 badge
    [self updateNavBarRightItemsWithBadge:1];
    
    // 汇报个推自定义事件
    // [GeTuiSdk sendFeedbackMessage:90001 taskId:taskId msgId:msgId];
}
//- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void(^)())completionHandler {
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"didReceiveLocalNotification"
//                                                        message:@""
//                                                       delegate:self
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//
//    [alertView show];
//    completionHandler();
//};

- (void)operateActiveRemoteNotification:(NSDictionary *)userInfo{
    //更新app提醒 小铃铛 加 badge
//    NSArray *viewControllers = self.nav.viewControllers;
//    if (!viewControllers || viewControllers.count<1) {
//        return;
//    }
    
    if(!_tabViewCtrl || _tabViewCtrl.viewControllers.count == 0){
        return;
    }
        
    
    
    if (! [self isPresentingRegView]) {
        //不在登陆页面
        [self updateNavBarRightItemsWithBadge:1];
    }
}

- (BOOL)isPresentingRegView{
    
    if (_tabViewCtrl && _tabViewCtrl.viewControllers.count) {
        return NO;
    }
    
    return YES;
}

//通用推送跳转
- (void)notificationReceivedOperation: (NSDictionary *)userInfo {
    
    //关闭友盟自带的弹出框
    [UMessage setAutoAlert:NO];
    
    self.pushNotification = nil;

    
   __block NSDictionary *extra = userInfo[@"extra"];
    
    [[userInfo allKeys] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isEqualToString:UIApplicationLaunchOptionsRemoteNotificationKey]) {
            extra = userInfo[UIApplicationLaunchOptionsRemoteNotificationKey][@"extra"];
            *stop = YES;
        }
        
    }];
    
    
    NSMutableDictionary *infoAdapter = [extra mutableCopy];

    
    if (extra[@"notice_type"]) {
        [infoAdapter setObject:extra[@"notice_type"] forKey:NET_KEY_NOTICETYPE];
    }
    if (extra[@"behavior"]) {
        [infoAdapter setObject:extra[@"behavior"] forKey:NET_KEY_NOTICEBEHAVIOR];
    }
    if (extra[@"notice_id"]) {
        [infoAdapter setObject:extra[@"notice_id"] forKey:NET_KEY_NOTICEID];
    }
    if (extra[@"loan_id"]) {
        [infoAdapter setObject:extra[@"loan_id"] forKey:@"loanid"];
    }
    if (extra[@"bets_id"]) {
        [infoAdapter setObject:extra[@"bets_id"] forKey:@"betid"];
    }
    if (extra[@"iou_id"]) {
        [infoAdapter setObject:extra[@"iou_id"] forKey:@"iouid"];
    }
    
    //标记消息来着推送
    [infoAdapter setObject:@(YES) forKey:@"remoteNtf"];
    
    //标记已读
    [MessageLaunchingUtil readMarkRequestForRemoteNotification:infoAdapter];
    
    NSInteger notice_type = [extra[@"notice_type"] integerValue];
    if (notice_type == 16){
 
        
        if(_tabViewCtrl && _tabViewCtrl.viewControllers){
            UINavigationController *nav3 = _tabViewCtrl.viewControllers[3];
            [nav3 popToRootViewControllerAnimated:NO];
        }
    
        [self changeViewToIOU];
    }else{
//        
//        UIAlertView*alert = [[UIAlertView alloc] initWithTitle:@"step0002" message:infoAdapter.description delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles: nil];
//        [alert show];
        
          UIViewController *destVC = [MessageLaunchingUtil destViewControllerOfNotice:infoAdapter];
          if (! destVC) {
            
              return;
          }
          [self remoteNotificationPushViewController:destVC];
      }
    /*
     NSInteger notice_type = [extra[@"notice_type"] integerValue];
     NSInteger behavior = [extra[@"behavior"] integerValue];
     NSInteger itemId = [EMPTYSTRING_HANDLE(extra[@"id"]) integerValue];
     
     if (notice_type == 1 && behavior == 2) {
     ////转账通知
     [self remoteNotificationPushViewController:[MeRouter notificationPushedBillViewController: itemId]];
     }else if (  notice_type == 3 ||
     (notice_type == 4 && behavior == 1 )||
     notice_type == 5 ||
     notice_type == 9
     ) {
     ///  转向订单详情
     BillDetail *e = ZBill(@"BillDetail");
     e.billID = [NSString stringWithFormat:@"%@", @(itemId)];
     [self remoteNotificationPushViewController:e];
     }else
     if (notice_type == 1 || notice_type == 13) {
     ///  消息列表
     ServiceMessageViewController *tixing = ZBill(@"ServiceMessageViewController");
     [self remoteNotificationPushViewController:tixing];
     }else
     if (notice_type == 2 && behavior != 6 && behavior != 9) {
     ///  我的借款详情，
     LoanInfoViewModel *vm = [[LoanInfoViewModel alloc] initWithLoanId:itemId];
     BillInfoViewController *vc = [[BillInfoViewController alloc] initWithViewModel:vm];
     [self remoteNotificationPushViewController:vc];
     }else
     if (notice_type == 4 && behavior == 2) {
     ///  借款详情
     LoanInfoViewModel *vm = [[LoanInfoViewModel alloc] initWithLoanId:itemId];
     BillInfoViewController *vc = [[BillInfoViewController alloc] initWithViewModel:vm];
     [self remoteNotificationPushViewController:vc];
     }else
     if (notice_type == 6 && behavior == 1) {
     ///  我的借款列表
     MyLoansListViewController *jie = ZLOAN(@"MyLoansListViewController");
     [self remoteNotificationPushViewController:jie];
     }else
     if (notice_type == 6 && behavior == 2) {
     ///  我授信的借款列表
     GuaranteeListViewController *j = ZGUARANTEE(@"GuaranteeListViewController");
     [self remoteNotificationPushViewController:j];
     }else
     if (notice_type == 7 || notice_type == 8) {
     ///  个人主页
     PersonHomePage *per = DQC(@"PersonHomePage");
     [per setTheDataDict:@{NET_KEY_USERID:[NSString stringWithFormat:@"%@", @(itemId)]}];
     [self remoteNotificationPushViewController:per];
     }
     else if (notice_type == 16){
     if (self.nav.viewControllers.count > 1) {
     [self.nav popToRootViewControllerAnimated:NO];
     }
     [self changeViewToIOU];
     }
     */
}

- (void)remoteNotificationPushViewController:(UIViewController *)viewController{
    
    /*
     NSArray *vcs = self.nav.viewControllers;
     NSArray* reversedVCS = [[vcs reverseObjectEnumerator] allObjects];
     
     static BOOL isPushedFromNtf = NO;
     if (isPushedFromNtf) {
     for (UIViewController *vc in reversedVCS) {
     if ([vc isKindOfClass:[ServiceMessageViewController class]]) {
     NSUInteger serviceVCIndex = [vcs indexOfObject:vc];
     NSInteger previce = --serviceVCIndex;
     if (previce >= 0 && vcs.count > previce) {
     [self.nav popToViewController:vcs[previce] animated:NO];
     }
     }
     }
     
     isPushedFromNtf = NO;
     }
     */
//    
//    UIAlertView*alert = [[UIAlertView alloc] initWithTitle:@"step2" message:@"msg" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles: nil];
//    [alert show];

    
    if ([self isPresentingRegView] ) {
        //用户未登陆
        return;
    }else{
        
        
//        UIAlertView*alert = [[UIAlertView alloc] initWithTitle:@"step3" message:@"msg" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles: nil];
//        [alert show];
//
        
        if (! [viewController isKindOfClass:[ServiceMessageViewController class]]) {
            [[self curSelNav] pushViewController:ZBill(@"ServiceMessageViewController") animated:NO];
        }
        [[self curSelNav]  pushViewController:viewController animated:NO];
    }
    
}

- (void)unRegisterUMessagePush{
    [UMessage unregisterForRemoteNotifications];
}

- (void)registerUMessagePush{
    {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        BOOL synchronizedNotificationOff = [[userDefaults valueForKey:kSynchronizedNotificationOffKey ] boolValue];
        if(synchronizedNotificationOff){
            //推送已关闭
            return;
        }
        //set AppKey and LaunchOptions
        [UMessage startWithAppkey:UMessageAppKey launchOptions:self.launchOptions];
#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define _IPHONE80_ 80000
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
        if(UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
        {
            //register remoteNotification types
            UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
            action1.identifier = @"action1_identifier";
            action1.title=@"Accept";
            action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
            
            UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
            action2.identifier = @"action2_identifier";
            action2.title=@"Reject";
            action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
            action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
            action2.destructive = YES;
            
            UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
            categorys.identifier = @"category1";//这组动作的唯一标示
            [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
            
            UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                         categories:[NSSet setWithObject:categorys]];
            [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
            
        } else{
            //register remoteNotification types
            [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
             |UIRemoteNotificationTypeSound
             |UIRemoteNotificationTypeAlert];
        }
#else
        
        //register remoteNotification types
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
         |UIRemoteNotificationTypeSound
         |UIRemoteNotificationTypeAlert];
        
#endif
#ifdef TEST_TEST_SERVER
        //for log
        [UMessage setLogEnabled:YES];
#endif
    }
}

#pragma mark - 启动GeTuiSdk

- (void)startSdkWith:(NSString *)appID appKey:(NSString *)appKey appSecret:(NSString *)appSecret {
    //[1-1]:通过 AppId、 appKey 、appSecret 启动SDK
    //该方法需要在主线程中调用
    [GeTuiSdk startSdkWithAppId:appID appKey:appKey appSecret:appSecret delegate:self];
    
    //[1-2]:设置是否后台运行开关
    [GeTuiSdk runBackgroundEnable:YES];
    //[1-3]:设置电子围栏功能，开启LBS定位服务 和 是否允许SDK 弹出用户定位请求
    [GeTuiSdk lbsLocationEnable:YES andUserVerify:YES];
}
#pragma mark - background fetch  唤醒
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    //[5] Background Fetch 恢复SDK 运行
    [GeTuiSdk resume];
    
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - getters

+ (AppDelegate *)zapp {
    
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (ValidationCodeM *)zvalidation {
    if (_zvalidation == nil) {
        _zvalidation = [[ValidationCodeM alloc] init];
    }
    return _zvalidation;
}

- (UserLoginManager *)zlogin {
    if (_zlogin == nil) {
        _zlogin = [[UserLoginManager alloc] init];
    }
    return _zlogin;
}

- (UserManager *)myuser {
    if (_myuser == nil) {
        _myuser = [[UserManager alloc] init];
    }
    return _myuser;
}

- (UtilProvince *)zprovince {
    if (ZNULL(_zprovince)) {
        _zprovince = [[UtilProvince alloc] init];
    }
    return _zprovince;
}

- (NoticeManager *)znotice {
    if (_znotice == nil) {
        _znotice = [[NoticeManager alloc] init];
    }
    return _znotice;
}

- (UtilDevice *)zdevice {
    if (ZNULL(_zdevice)) {
        _zdevice = [[UtilDevice alloc] init];
    }
    return _zdevice;
}

- (WeiXinEngine *)wxEngine {
    if (_wxEngine == nil) {
        _wxEngine = [[WeiXinEngine alloc] initWithHostName:WEIXIN_SERVER_URL];
    }
    return _wxEngine;
}

- (NetworkEngine *)netEngine {
    if (_netEngine == nil) {
        _netEngine = [[NetworkEngine alloc] initWithHostName:YQS_SERVER_URL];
    }
    return _netEngine;
}
- (ImageEngine *)imgEngine {
    if (_imgEngine == nil) {
        _imgEngine = [[ImageEngine alloc] initWithHostName:YQS_IMAGE_URL];
        [_imgEngine useCache];
    }
    return _imgEngine;
}

-(void)addTabbarBK{
    
    
    if(MainScreenWidth<=320){
        
        UIImage *image = [UIImage imageNamed:@"bottom_bj_320"];
        [[self.tabViewCtrl tabBar] setBackgroundImage:image];
        
    }else if(iPhone6Plus){
        
//        CGRect rec = self.tabViewCtrl.tabBar.frame;
        
        UIImage *image = [UIImage imageNamed:@"bottombj_1080"];
        [[self.tabViewCtrl tabBar] setBackgroundImage:image];

    }else{
        
        UIImage *image = [UIImage imageNamed:@"bottom_bj"];
//        UIEdgeInsets insets = UIEdgeInsetsMake(49, 190, 170, 0);
//        UIImage *streImage = [image resizableImageWithCapInsets:insets];

        [[self.tabViewCtrl tabBar] setBackgroundImage:image];
        
    }
}
@end
