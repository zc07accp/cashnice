//
//  BillDetailConfig.h
//  Cashnice
//
//  Created by apple on 16/8/18.
//  Copyright © 2016年 l. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BillDetailConfig : NSObject

+(NSArray *)configTitleArr:(NSString *)type;

+(NSArray *)configHeadArr:(NSString *)type;


+(NSAttributedString *)reformMoney:(NSString *)money;


/**
 从详情dic抽取账单详情数据

 @param type 账单类型
 @param key  标题键
 @param dic  账单详情dic

 @return value数据
 */
+(NSString *)value:(NSString *)type keyName:(NSString*)key detailDic:(NSDictionary *)dic;

+(NSString *)value:(NSString *)key listDic:(NSDictionary *)dic;

//+(NSString *)value:(NSString *)key listDic:(NSDictionary *)dic;


+(UIColor *)contentColor:(NSString *)type title:(NSString *)title;

+(BOOL)shouldTapToOpen:(NSString *)type title:(NSString *)title;


/**
 分发账单详情跳转信息页的vc

 @param flag
 @param loanid
 @param bet_id
 @return 
 */
+(UIViewController *)dispathTapOpenViewController:(NSString *)flag loadid:(NSInteger)loanid betid:(NSInteger)bet_id;

@end
