//
//  SinaCashierNetEngine.h
//  Cashnice
//
//  Created by a on 16/8/17.
//  Copyright © 2016年 l. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CNNetworkEngine.h"

@interface CalendarNetEngine : CNNetworkEngine


- (void)betDateList:(NSString *)value
            success:(void (^)(NSArray *contentArray))success
            failure:(void (^)(NSString *))failure;


- (void)calendarBetListWithBegin:(NSString *)begin
                             end:(NSString *)end
                            page:(NSInteger)page
            success:(void (^)(NSDictionary *content))success
            failure:(void (^)(NSString *))failure;

/**
 *  执行请求
 *
 *  @param parms   参数
 *  @param parms   路径
 *  @param success 成功
 *  @param failure 失败
 */
-(void)doAction:(NSDictionary *)parms
           path:(NSString *)path
              success:(void (^)(NSDictionary *))success
              failure:(void (^)(NSString *error))failure;


-(void)doActionWithResponse:(NSDictionary *)parms
                       path:(NSString *)path
                    success:(void (^)(NSDictionary *))success
                    failure:(void (^)(NSDictionary *))failure;

@end
