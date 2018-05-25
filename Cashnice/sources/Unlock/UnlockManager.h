//
//  UnlockManager.h
//  Cashnice
//
//  Created by a on 2016/11/16.
//  Copyright © 2016年 l. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  设置touchid提示
 */
#define touchIDSettingNote @"请在我的-设置-指纹、手势密码，开启Touch ID指纹解锁"
#define touchIDDeviceSettingNote @"请在“设置-Touch ID与密码”中设置Touch ID"


@class GestureViewController;

@interface UnlockManager : NSObject

/**
 *  设置手势密码页面
 */
+ (void)presentGrestureSetter;

/**
 *  登录验证手势密码页面
 */
+ (void)presentGrestureVerifier;

/**
 *  手势密码是否已设置
 */
+ (BOOL)gestureSetted;

//发送通知更新手势设置
+ (void)dispachGestureSettingNotification;

+ (BOOL)needResetUnlockGesture;

+ (void)setNeedResetUnlockGesture;

+ (void)clearNeedResetUnlockGesture;

+ (void)dismissGestureView;
//+ (GestureViewController *)currentGestureVC;
//+ (void)cleanCurrentGestureVC;
//+ (void)setCurrentGestureVC:(GestureViewController *)vc;

@end
