//
//  UnlockManager.m
//  Cashnice
//
//  Created by a on 2016/11/16.
//  Copyright © 2016年 l. All rights reserved.
//

#import "UnlockManager.h"
#import "GestureViewController.h"
#import "PCCircleViewConst.h"
#import "LocalAuthen.h"
#import "GestureUnlockContainerView.h"

@implementation UnlockManager

static NSString* needResetUnlockGesture;
static GestureUnlockContainerView *ges;
//static GestureViewController *_currentInstance;


+ (void)presentGrestureSetter{
    
    //设置手势密码
    ges = [[GestureUnlockContainerView alloc] init];
    [ges showGestureSetter];
}

/**
 *  登录验证手势密码页面
 */
+ (void)presentGrestureVerifier{
    
//    if (_currentInstance) {
//        [_currentInstance dismissViewControllerAnimated:NO completion:^{
//            [UnlockManager presentGresture];
//            return ;
//        }];
//    }
    {
        [UnlockManager presentGresture];
    }
}

+ (void)presentGresture{
    if ([[PCCircleViewConst getGestureWithKey:gestureFinalSaveKey] length]  &&
        [[LocalAuthen sharedInstance] isGesturePasswdOpened]) {
        GestureViewController *gestureVc = [[GestureViewController alloc] init];
        [gestureVc setType:GestureViewControllerTypeLogin];
        
        //[[UINavigationController alloc] initWithRootViewController:gestureVc]
        
        ges = [[GestureUnlockContainerView alloc] init];
        [ges show];
    }
}

+ (void)dismissGestureView{
    
    [ges close];
}

+(BOOL)gestureSetted{
    NSString *gestureOne = [PCCircleViewConst getGestureWithKey:gestureFinalSaveKey];
    // 看是否存在一个密码
    if ([gestureOne length]) {
        return YES;
    }
    return NO;
}

//发送通知更新手势设置
+(void)dispachGestureSettingNotification{
    [Util dispatch:MSG_GESTUREWINDOW_CLOSED];
}

//+ (GestureViewController *)currentGestureVC{
//    return _currentInstance;
//}
//
//+ (void)cleanCurrentGestureVC{
//    _currentInstance = nil;
//}
//
//+ (void)setCurrentGestureVC:(GestureViewController *)vc{
//    _currentInstance = vc;
//}

+ (BOOL)needResetUnlockGesture{
    return [needResetUnlockGesture isEqualToString:[ZAPP.myuser getUserID]];
}

+ (void)setNeedResetUnlockGesture{
    needResetUnlockGesture = [ZAPP.myuser getUserID];
}
+ (void)clearNeedResetUnlockGesture{
    needResetUnlockGesture = nil;
}

@end
