//
//  SendLoanEngine.h
//  Cashnice
//
//  Created by apple on 2016/12/12.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CNNetworkEngine.h"

@interface SendLoanEngine : CNNetworkEngine

-(void)sendLoan:(NSDictionary *)dic
        success:(void (^)(NSDictionary *loanFabuSucDetailDict))success
        failure:(void (^)(NSString *error))failure;

-(void)getLoanConfigWithSuccess:(void (^)(NSDictionary *loanConfigDict))success
                        failure:(void (^)(NSString *error))failure;


/**
 投资转移 投资id

 @param betid
 @param success 成功
 @param failure 失败
 */
-(void)investTransfer:(NSInteger)betid
              success:(void (^)())success
              failure:(void (^)(NSString *error))failure;
    

-(void)getBetTurnDetail:(NSInteger)betid
                success:(void (^)(NSDictionary *))success
                failure:(void (^)(NSString *error))failure;
@end
