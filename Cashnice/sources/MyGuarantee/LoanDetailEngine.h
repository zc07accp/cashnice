//
//  LoanDetailEngine.h
//  Cashnice
//
//  Created by apple on 16/9/18.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CNNetworkEngine.h"

@interface  WaterFlowDetail: NSObject

@property(nonatomic) NSString* format_t_money;
@property(nonatomic) NSString* t_time;
@property(nonatomic) NSString* t_type;

@end

@interface LoanDetailEngine : CNNetworkEngine

-(void)getDetail:(NSInteger)loadId
          typeid:(NSString *)typeid
betid:(NSInteger)betid
success:(void (^)(NSDictionary *detail))success
failure:(void (^)(NSString *error))failure;



/**
 获取详情（长列表）
 
 @param loadId  项目id
 @param typeid  查询类型
 @param betid   <#betid description#>
 @param success <#success description#>
 @param failure <#failure description#>
 */
-(void)getListDetail:(NSInteger)loadId
              typeid:(NSString *)typeid
betid:(NSInteger)betid
success:(void (^)(NSDictionary *detail))success
failure:(void (^)(NSString *error))failure;


/**
 获取交易流水
 
 @param loadId  项目id
 @param typeid  查询类型
 @param success <#success description#>
 @param failure <#failure description#>
 */
-(void)getWaterFlowDetail:(NSInteger)loadId
                   typeid:(NSString *)typeid
betid:(NSInteger)betid
success:(void (^)(NSArray *list))success
failure:(void (^)(NSString *error))failure;

/**
 *  同意/不同意 担保
 */
-(void)postConfirmWarranty:(NSInteger)loadId
                   confirm:(NSString*) confirm
                   success:(void (^)(NSDictionary *detail))success
                   failure:(void (^)(NSString *error))failure;
/**
 *  确认借款
 */
-(void)postConfirmLoan:(NSInteger)loadId
                 value:(double) value
               success:(void (^)(NSDictionary *detail))success
               failure:(void (^)(NSString *error))failure;

/**
 *  担保列表
 */
-(void)getWarrantyList:(NSInteger)loadId
               pageNum:(NSInteger) pageNum
               success:(void (^)(NSDictionary *detail))success
               failure:(void (^)(NSString *error))failure;

/**
 *  更换担保列表
 */
-(void)getWithoutWarrantyList:(NSInteger)loadId
                     fromUser:(NSString *)fromUser
                      pageNum:(NSInteger) pageNum
                      success:(void (^)(NSDictionary *detail))success
                      failure:(void (^)(NSString *error))failure;

/**
 *  更换担保人
 */
-(void)changeWarranty:(NSInteger)loadId
                     fromUser:(NSString *)fromUser
                       toUser:(NSString *)toUser
                      success:(void (^)(NSDictionary *detail))success
                      failure:(void (^)(NSString *error))failure;
@end
