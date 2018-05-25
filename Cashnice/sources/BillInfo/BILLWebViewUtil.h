//
//  BILLWebViewUtil.h
//  Cashnice
//
//  Created by a on 16/9/26.
//  Copyright © 2016年 l. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BILLWebViewUtil : NSObject

//催收系统保护中
+ (void)presentOverdueIndexFrom:(UIViewController *)vc;

//了解逾期后果
+ (void)presentOverdueRulesFrom:(UIViewController *)vc;

//催收进展
+ (void)presentOverdueCollection:(NSUInteger)loanId vc:(UIViewController *)vc;

//抵押用户
+ (void)presentPrivilegedUserWithViewController:(UIViewController *)vc ;
@end
