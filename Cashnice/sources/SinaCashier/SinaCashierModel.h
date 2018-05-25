//
//  SinaCashierModel.h
//  Cashnice
//
//  Created by a on 16/8/17.
//  Copyright © 2016年 l. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SinaCashierModel : NSObject



/**
 *  设置密码
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void)findPayPasswordWithsuccess:(void (^)(NSString * URL, NSData *Content))success
                          failure:(void (^)(NSString * error))failure;

/**
 *  设置密码
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void)setPayPasswordWithsuccess:(void (^)(NSString * URL, NSData *Content))success
                          failure:(void (^)(NSString * error))failure;
/**
 *  修改密码
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void)modifyPayPasswordWithsuccess:(void (^)(NSString * URL, NSData *Content))success
                          failure:(void (^)(NSString * error))failure;


/**
 *  我的银行卡管理
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void)bankCardManagementWithsuccess:(void (^)(NSString * URL, NSData *Content))success
                           failure:(void (^)(NSString * error))failure;

/**
 *  查询是否设置密码【1已设置0未设置】
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void)queryIsSetPayPasswordWithsuccess:(void (^)(BOOL isSetPayPassword))success
                                 failure:(void (^)(NSString * error))failure;

/**
 *  修改绑定的手机号
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void)modifyVerifyMobileWithsuccess:(void (^)(NSString * URL, NSData *Content))success
                                 failure:(void (^)(NSString * error))failure;

/**
 *  找回绑定手机号
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void)findVerifyMobileWithsuccess:(void (^)(NSString * URL, NSData *Content))success
                            failure:(void (^)(NSString * error))failure;
/**
 *  投资
 *
 *  @param value   投资金额
 *  @param loanId  借款项目ID
 *  @param success 成功回调
 *  @param failure 失败回调
 */
-(void)investAction:(NSString *)value
             loanId:(NSString *)loanId
              couId:(NSString *)couId
              bicid:(NSString *)bicid
            success:(void (^)(NSData *contentData))success
            failure:(void (^)(NSDictionary *error))failure;

/**
 *  还款
 *
 *  @param value   还款金额
 *  @param success 成功回调
 *  @param failure 失败回调
 */
-(void)repaymentAction:(NSString *)value
                loanId:(NSString *)loanId
               success:(void (^)(NSData *contentData, NSString *contentString))success
               failure:(void (^)(NSString *error))failure;

/**
 *  支付担保金
 *
 *  @param value   金额
 *  @param success 成功回调
 *  @param failure 失败回调
 */
-(void)guaranteeAction:(NSString *)value
                loanId:(NSString *)loanId
               success:(void (^)(NSData *contentData))success
               failure:(void (^)(NSString *error))failure;
/**
 *  充值
 *
 *  @param value   充值金额
 *  @param success 成功回调
 *  @param failure 失败回调
 */
-(void)recharge:(NSString *)value
                success:(void (^)(NSData *))success
                failure:(void (^)(NSString *error))failure;
/**
 *  体现
 *
 *  @param value   体现金额
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void)withdraw:(NSString *)value
         success:(void (^)(NSData *))success
         failure:(void (^)(NSString *))failure;

/**
 *  转账
 *
 *  @param value            转账金额
 *  @param targetUserId     转账目标
 *  @param comment          转账备注
 *  @param success          成功回调
 *  @param failure          失败回调
 */
- (void)transfer:(NSString *)value
          target:(NSString *)targetUserId
         comment:(NSString *)comment
         success:(void (^)(NSData *contentData))success
         failure:(void (^)(NSString *))failure;

+ (NSData *)ungzipData:(NSData *)compressedData;
@end
