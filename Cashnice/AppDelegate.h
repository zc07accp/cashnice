//
//  AppDelegate.h
//  YQS
//
//  Created by l on 3/6/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"

@class UtilDevice;
@class UtilProvince;

@class NetworkEngine;
@class WeiXinEngine;
@class NetworkAuthEngine;
@class ImageEngine;

@class UserLoginManager;
@class UserManager;
@class NoticeManager;
@class ValidationCodeM;
@class LocalViewGuide;

#import <MessageUI/MessageUI.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate, WXApiDelegate, UIAlertViewDelegate, MFMailComposeViewControllerDelegate>

+ (AppDelegate *)zapp;

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UITabBarController *tabViewCtrl;

@property (strong, nonatomic) UtilDevice *zdevice;
@property (strong, nonatomic) UtilProvince *zprovince;
@property (strong, nonatomic) UserLoginManager *zlogin;
@property (strong, nonatomic) UserManager *myuser;
@property (strong, nonatomic) ValidationCodeM *zvalidation;

@property (strong, nonatomic) WeiXinEngine *wxEngine;
@property (strong, nonatomic) NetworkEngine *netEngine;
@property (strong, nonatomic) NetworkAuthEngine *networkAuthEngine;
@property (strong, nonatomic) ImageEngine *imgEngine;

@property (strong, nonatomic) NSString *sharedTriggerId;

@property (strong, nonatomic) MKNetworkOperation *systemParaOp;

@property(nonatomic, strong) LocalViewGuide *lvg;

/**
 *  借款详情，点击进入附件的图片详情，标志位
 */
@property (nonatomic, assign) BOOL inFullImageView;

/**
 *  微信相关
 */
- (void)loginToWeiXin;
- (void)inviteViaWeixin:(BOOL)isChat_OrCircle;

/**
 *  友盟推送
 */
- (void)registerUMessagePush;
- (void)unRegisterUMessagePush;

/**
 *  页面的切换
 */
- (void)changeLoginToTabs;
- (void)loginout;
- (void)changeViewToFirstPage; //转到首页
- (void)changeViewToIOU; //转借条页面
//
- (void)clearCache;

/**
 *  通知管理
 */
@property (strong, nonatomic) NoticeManager *znotice;
- (void)updateNavBarRightItems;
//-(void)updateNavLeftLogo;

- (void)msgPressed ;


@end
