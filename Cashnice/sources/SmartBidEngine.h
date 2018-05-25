//
//  SmartBidEngine.h
//  Cashnice
//
//  Created by apple on 2017/3/20.
//  Copyright © 2017年 l. All rights reserved.
//

#import "CNNetworkEngine.h"

@interface SmartBidEngine : CNNetworkEngine


/**
 获取智能投标设置

 @param userid 用户id
 @param success 成功
 @param failure 失败
 */
-(void)getAutobiddingSetting:(NSString *)userid
                     success:(void (^)(NSDictionary *))success
                     failure:(void (^)(NSString *error))failure;


/**
 智能投标设置

 @param params 参数
 @param success <#success description#>
 @param failure <#failure description#>
 */
-(void)autobiddingPost:(NSDictionary *)params
               success:(void (^)(NSDictionary *))success
               failure:(void (^)(NSString *error))failure;

/**
 是否获取授权

 @param dic 数据项
 @param vc pusher vc
 @return 
 */
-(BOOL)canset:(NSDictionary *)dic originvc:(UIViewController *)vc;



/**
 修改投标状态

 @param status 是否启用 0:未启用 1:已启用
 @param userid 用户id
 @param success <#success description#>
 @param failure <#failure description#>
 */
-(void)autobiddingStatusChange:(NSInteger)status
                        userid:(NSString *)userid
                       success:(void (^)())success
                       failure:(void (^)(NSString *error))failure;
@end

