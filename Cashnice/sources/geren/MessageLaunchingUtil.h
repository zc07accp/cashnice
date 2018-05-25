//
//  MessageLaunchingUtil.h
//  YQS
//
//  Created by a on 16/1/20.
//  Copyright © 2016年 l. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageLaunchingUtil : NSObject

+ (UIImage *)iconImageOfNoticeDict:(NSDictionary *)noticeDict;

+ (void)MesssageLaunchAction:(NSDictionary *)dict viewController:(UIViewController *)view;

//是否满足打开详情的条件
+ (BOOL)shouldReactForDetail:(NSDictionary *)dict;

+ (UIViewController *)destViewControllerOfNotice:(NSDictionary *)noticeDict;

+ (void)readMarkRequestForRemoteNotification:(NSDictionary *)dict;

@end
