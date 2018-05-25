//
//  BillNetEngine.h
//  Cashnice
//
//  Created by apple on 16/8/19.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CNNetworkEngine.h"
//#import "BillDetailUnit.h"

@interface BillNetEngine : CNNetworkEngine


-(void)getBillDetailFromServeMsgChongzhiTixian:(NSDictionary *)parms
                                       success:(void (^)(NSDictionary *))success
                                       failure:(void (^)(NSString *error))failure;
    
-(void)getBillDetailFromNoti:(NSDictionary *)parms
                     success:(void (^)(NSDictionary *))success
                     failure:(void (^)(NSString *error))failure;


/**
 *  获取账单详情
 *
 *  @param parms   参数
 *  @param success 成功
 *  @param failure 失败
 */
-(void)getBillDetail:(NSDictionary *)parms
             success:(void (^)(NSDictionary *))success
             failure:(void (^)(NSString *error))failure;



/**
 获取账单列表

 @param parms   参数
 @param success 成功，返回账单列表
 @param failure 失败
 */
-(void)getBillList:(NSDictionary *)parms
           success:(void (^)(NSDictionary *))success
           failure:(void (^)(NSString *error))failure;
@end
