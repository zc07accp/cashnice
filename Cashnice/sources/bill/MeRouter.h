//
//  MeRouter.h
//  Cashnice
//
//  Created by apple on 2016/11/1.
//  Copyright © 2016年 l. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CardVideoViewControllerDelegate;
@protocol IDCardUploadDelegate;


@interface MeRouter : NSObject

//账单详情

+(UIViewController *)commonPushedBillViewController:(NSDictionary *)dic;

//来自通知
+(UIViewController *)notificationPushedBillViewController:(NSInteger )noticeid;

//小铃铛充值提现
+(UIViewController *)servemsgChongzhiTixianPushedBillViewController:(NSInteger )noticeid;

//成交历史
+(UIViewController *)friendsTradeHistoryViewController;     //好友成交
+(UIViewController *)OuterTradeHistoryViewController;       //周边成交

//身份证拍摄
//type 1正面 2反面
+(UIViewController *)cardIDTakeViewController:(NSInteger)type delegate:(id<CardVideoViewControllerDelegate>)delgate;

//选择身份证，上传
+(UIViewController *)IDCardUploadViewController:(id<IDCardUploadDelegate>)delegate;

//新的个人资料界面
+(UIViewController *)newPersonDetailViewController;

//个人资料-工作在
+(UIViewController *)editUserWorkplace:(NSString *)workplace;

//个人资料-职务
+(UIViewController *)editUserPosition:(NSString *)position;

//个人资料-通讯地址
+(UIViewController *)editUserAddress:(NSString *)address;

//个人资料-邮箱
+(UIViewController *)editUserEmailViewController;

//个人资料-社会职务
+(UIViewController *)editUserSocietyViewController;

//个人资料-手机号
+(UIViewController *)editUserPhoneViewController;

//个人资料-绑卡
+(UIViewController *)UserBindBankViewController;

//身份证认证成功
+(UIViewController *)IDCardIdentifiedViewController;

//个人资料-营业执照
+(UIViewController *)businessLicense;


@end
